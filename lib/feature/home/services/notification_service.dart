import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:adhan/adhan.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Handles local notification initialization and scheduling for prayer times.
class PrayerNotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  static const int nsBase = 2000; // namespace for prayer notifications

  Future<void> init() async {
    if (_initialized) return;
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );
    await _plugin.initialize(initSettings);

    final androidImpl =
        _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    // Request all necessary permissions for reliable notifications
    await androidImpl?.requestExactAlarmsPermission();
    await androidImpl?.requestNotificationsPermission();

    // Create high-priority notification channel for prayer times
    await _createPrayerNotificationChannel(androidImpl);

    _initialized = true;
  }

  Future<void> _createPrayerNotificationChannel(
    AndroidFlutterLocalNotificationsPlugin? androidImpl,
  ) async {
    if (androidImpl == null) return;

    final AndroidNotificationChannel channel = AndroidNotificationChannel(
      'prayer_times_channel',
      'Prayer Times',
      description: 'Azan notifications for prayer times',
      importance: Importance.max,
      sound: const RawResourceAndroidNotificationSound('azan'),
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
      enableLights: true,
      ledColor: const Color(0xFFFF0000),
      showBadge: true,
    );

    await androidImpl.createNotificationChannel(channel);
  }

  NotificationDetails _details({bool withSound = true}) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'prayer_times_channel',
        'Prayer Times',
        channelDescription: 'Azan notifications for prayer times',
        importance: Importance.max,
        priority: Priority.high,
        visibility: NotificationVisibility.public,
        playSound: withSound,
        sound:
            withSound
                ? const RawResourceAndroidNotificationSound('azan')
                : null,
        icon: '@mipmap/ic_launcher',
        // Additional settings for reliable delivery when app is closed
        enableVibration: true,
        vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
        enableLights: true,
        ledColor: const Color(0xFFFF0000),
        showWhen: true,
        when: DateTime.now().millisecondsSinceEpoch,
        usesChronometer: false,
        timeoutAfter: null, // Don't auto-dismiss
        category: AndroidNotificationCategory.alarm,
        autoCancel: false, // Keep notification until user interacts
        ongoing: true, // Make it persistent
        fullScreenIntent: true, // Show full screen when device is locked
        ticker: 'Prayer Time Alert',
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: withSound,
        sound: withSound ? 'azan.mp3' : null,
        interruptionLevel: InterruptionLevel.critical,
      ),
    );
  }

  Future<void> scheduleOneShot({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    bool withSound = true,
  }) async {
    final tz.TZDateTime tzTime = tz.TZDateTime.from(scheduledTime, tz.local);

    // Use the most reliable scheduling mode for prayer notifications
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tzTime,
      _details(withSound: withSound),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'prayer_$id',
    );

    // Log the scheduled notification for debugging
    print('Scheduled prayer notification: $title at $scheduledTime (ID: $id)');
  }

  Future<void> scheduleDaily({
    required int id,
    required String title,
    required String body,
    required DateTime time,
    bool withSound = true,
  }) async {
    // Deprecated in favor of scheduleForDay one-shot scheduling
    final DateTime now = DateTime.now();
    DateTime target = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (target.isBefore(now)) target = target.add(const Duration(days: 1));
    await scheduleOneShot(
      id: id,
      title: title,
      body: body,
      scheduledTime: target,
      withSound: withSound,
    );
  }

  /// One-day scheduler for all prayers.
  Future<List<Map<String, dynamic>>> scheduleForDay({
    required Map<Prayer, DateTime> prayerTimes,
    required DateTime day,
    required bool
    preReminderEnabled, // Keep parameter for compatibility but ignore it
    String Function(Prayer)? prayerName,
  }) async {
    final List<Map<String, dynamic>> scheduled = [];
    final DateTime now = DateTime.now();
    for (final entry in prayerTimes.entries) {
      final Prayer p = entry.key;
      final DateTime t = entry.value;
      final DateTime target = DateTime(
        day.year,
        day.month,
        day.day,
        t.hour,
        t.minute,
      );
      if (target.isAfter(now)) {
        final int id = nsBase + p.index;
        await scheduleOneShot(
          id: id,
          title:
              "It's time for ${(prayerName != null ? prayerName(p) : p.name)}",
          body: 'Prayer time has started',
          scheduledTime: target,
          withSound: true,
        );
        scheduled.add({'id': id, 'time': target});
      }
      // Removed pre-reminder scheduling - no more 1-minute advance notifications
    }
    return scheduled;
  }

  Future<void> cancel(int id) => _plugin.cancel(id);
  Future<void> cancelAll() => _plugin.cancelAll();

  /// Check and request all necessary permissions for reliable notifications
  Future<bool> ensurePermissions() async {
    final androidImpl =
        _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidImpl == null) return false;

    try {
      // Check and request notification permissions
      final notificationPermission =
          await androidImpl.requestNotificationsPermission();
      if (notificationPermission != true) {
        print('Notification permission denied');
        return false;
      }

      // Check and request exact alarms permission
      final alarmPermission = await androidImpl.requestExactAlarmsPermission();
      if (alarmPermission != true) {
        print('Exact alarms permission denied');
        return false;
      }

      print('All notification permissions granted');
      return true;
    } catch (e) {
      print('Error requesting permissions: $e');
      return false;
    }
  }

  /// Get list of pending notifications for debugging
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _plugin.pendingNotificationRequests();
  }

  /// Test notification to verify setup
  Future<void> testNotification() async {
    await _plugin.show(
      999999, // Use a unique ID for test
      'Test Prayer Notification',
      'This is a test to verify notification setup',
      _details(withSound: true),
      payload: 'test',
    );
  }
}
