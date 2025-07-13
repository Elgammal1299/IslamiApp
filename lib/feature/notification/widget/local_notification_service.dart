import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:islami_app/feature/notification/data/repo/notification_repo.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// 🔧 تهيئة الإشعارات والـ Timezone
  static Future<void> init() async {
    // 1. تهيئة المنطقة الزمنية
    tz.initializeTimeZones();

    // 2. إعداد الإشعارات
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('Notification clicked with payload: ${response.payload}');
      },
    );

    // 3. طلب صلاحيات Android 13+
    final androidImpl =
        _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    await androidImpl?.requestExactAlarmsPermission();

    // 4. جدولة الإشعارات اليومية
    await _scheduleDailyMorningAndEvening();
  }

  /// ⏰ جدولة إشعارين يوميًا: صباحًا ومساءً
  static Future<void> _scheduleDailyMorningAndEvening() async {
    final now = DateTime.now();

    // 🕣 8:30 صباحًا
    final morningTime = DateTime(now.year, now.month, now.day, 8);
    await scheduleNotification(
      id: 1,
      title: 'صباح الخير 🌅',
      body: 'لا تنس أذكار الصباح اليوم!',
      dateTime:
          morningTime.isBefore(now)
              ? morningTime.add(const Duration(days: 1))
              : morningTime,
      repeat: DateTimeComponents.time,
    );

    // 🌙 8:30 مساءً
    final eveningTime = DateTime(
      now.year,
      now.month,
      now.day,
      20,
    ); // 20 = 8 مساءً
    await scheduleNotification(
      id: 2,
      title: 'مساء الخير 🌙',
      body: 'وقت أذكار المساء ✨',
      dateTime:
          eveningTime.isBefore(now)
              ? eveningTime.add(const Duration(days: 1))
              : eveningTime,
      repeat: DateTimeComponents.time,
    );
  }

  /// 🔁 جدولة إشعار مخصص
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
    DateTimeComponents? repeat,
    String? payload,
  }) async {
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(dateTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'scheduled_channel',
          'Scheduled Notifications',
          channelDescription: 'Notifications that appear at a set time',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: repeat,
      payload: payload ?? 'custom_payload',
    );
    await NotificationRepo().logNotification(
      title: title,
      body: body,
      type: 'scheduled',
    );
  }

  static Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  static Future<List<PendingNotificationRequest>>
  getPendingNotifications() async {
    return await _plugin.pendingNotificationRequests();
  }
}
