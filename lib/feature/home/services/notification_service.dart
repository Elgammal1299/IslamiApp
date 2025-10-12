import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:adhan/adhan.dart';
import 'package:timezone/data/latest_all.dart' as tz;
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
    await androidImpl?.requestExactAlarmsPermission();
    _initialized = true;
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
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: withSound,
        sound: withSound ? 'azan.mp3' : null,
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
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tzTime,
      _details(withSound: withSound),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'prayer',
    );
    // Also trigger playback when the time comes
    final Duration delay = tzTime.difference(tz.TZDateTime.now(tz.local));
    if (!delay.isNegative) {
      Future.delayed(delay, () async {
      });
    }
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

  /// One-day scheduler for all prayers (and optional pre-reminders).
  Future<List<Map<String, dynamic>>> scheduleForDay({
    required Map<Prayer, DateTime> prayerTimes,
    required DateTime day,
    required bool preReminderEnabled,
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
              "لقد حان الوقت ل ${(prayerName != null ? prayerName(p) : p.name)}",
          body: 'لقد بدأ وقت الصلاة',
          scheduledTime: target,
          withSound: true,
        );
        scheduled.add({'id': id, 'time': target});
      }
    }
    return scheduled;
  }

  Future<void> cancel(int id) => _plugin.cancel(id);
  Future<void> cancelAll() => _plugin.cancelAll();
}
