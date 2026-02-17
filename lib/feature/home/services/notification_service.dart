import 'dart:async';

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
  static const int prayersPerDay = 6; // fajr, sunrise, dhuhr, asr, maghrib, isha
  static const int preReminderOffset = 1000;

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
  }

  /// Generate unique notification ID per prayer per day.
  /// dayOffset: 0 = today, 1 = tomorrow, etc.
  static int notificationId(int prayerIndex, int dayOffset) {
    return nsBase + (dayOffset * prayersPerDay) + prayerIndex;
  }

  static int preReminderId(int prayerIndex, int dayOffset) {
    return notificationId(prayerIndex, dayOffset) + preReminderOffset;
  }

  /// One-day scheduler for all prayers (and optional pre-reminders).
  /// [dayOffset] is used to generate unique IDs (0=today, 1=tomorrow, ...).
  Future<List<Map<String, dynamic>>> scheduleForDay({
    required Map<Prayer, DateTime> prayerTimes,
    required DateTime day,
    required bool preReminderEnabled,
    String Function(Prayer)? prayerName,
    int dayOffset = 0,
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
        final int id = notificationId(p.index, dayOffset);
        await scheduleOneShot(
          id: id,
          title:
              "لقد حان الوقت ل ${(prayerName != null ? prayerName(p) : p.name)}",
          body: 'لقد بدأ وقت الصلاة',
          scheduledTime: target,
          withSound: true,
        );
        scheduled.add({'id': id, 'time': target});

        if (preReminderEnabled) {
          final DateTime reminderTime = target.subtract(
            const Duration(minutes: 10),
          );
          if (reminderTime.isAfter(now)) {
            final int reminderId = preReminderId(p.index, dayOffset);
            await scheduleOneShot(
              id: reminderId,
              title:
                  "تبقى 10 دقائق على ${(prayerName != null ? prayerName(p) : p.name)}",
              body: 'استعد للصلاة',
              scheduledTime: reminderTime,
              withSound: false,
            );
            scheduled.add({'id': reminderId, 'time': reminderTime});
          }
        }
      }
    }
    return scheduled;
  }

  /// Schedule prayer notifications for [days] days ahead.
  /// Requires a function to compute prayer times for a given date.
  Future<void> scheduleMultipleDays({
    required int days,
    required double latitude,
    required double longitude,
    required CalculationParameters params,
    String Function(Prayer)? prayerName,
    bool preReminderEnabled = true,
  }) async {
    await cancelPrayerNotifications();
    final DateTime now = DateTime.now();
    for (int i = 0; i < days; i++) {
      final DateTime day = DateTime(now.year, now.month, now.day).add(Duration(days: i));
      final coordinates = Coordinates(latitude, longitude);
      final dateComponents = DateComponents.from(day);
      final prayerTimes = PrayerTimes(coordinates, dateComponents, params);

      final Map<Prayer, DateTime> namedTimes = {};
      for (final p in [Prayer.fajr, Prayer.sunrise, Prayer.dhuhr, Prayer.asr, Prayer.maghrib, Prayer.isha]) {
        final t = prayerTimes.timeForPrayer(p);
        if (t != null) namedTimes[p] = t;
      }

      await scheduleForDay(
        prayerTimes: namedTimes,
        day: day,
        preReminderEnabled: preReminderEnabled,
        prayerName: prayerName,
        dayOffset: i,
      );
    }
  }

  Future<void> cancelPrayerNotifications({int maxDays = 30}) async {
    for (int dayOffset = 0; dayOffset < maxDays; dayOffset++) {
      for (int prayerIndex = 0; prayerIndex < prayersPerDay; prayerIndex++) {
        await cancel(notificationId(prayerIndex, dayOffset));
        await cancel(preReminderId(prayerIndex, dayOffset));
      }
    }
  }

  Future<void> cancel(int id) => _plugin.cancel(id);
  Future<void> cancelAll() => _plugin.cancelAll();
}
