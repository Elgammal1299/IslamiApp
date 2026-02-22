import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:islami_app/app_initializer.dart';
import 'package:islami_app/feature/notification/data/repo/notification_repo.dart';
import 'package:islami_app/feature/notification/widget/handle_notification.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static AndroidScheduleMode _androidScheduleMode =
      AndroidScheduleMode.exactAllowWhileIdle;

  /// 🔧 تهيئة الإشعارات والـ Timezone
  static Future<void> init() async {
    // 1. تهيئة المنطقة الزمنية
    tz.initializeTimeZones();
    try {
      final String currentTimeZone =
          (await FlutterTimezone.getLocalTimezone()).identifier;
      tz.setLocalLocation(tz.getLocation(currentTimeZone));
    } catch (_) {
      // Fallback to UTC if timezone detection fails
    }

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
        try {
          if (navigatorKey.currentContext != null) {
            handleNotification(navigatorKey.currentContext!, {
              'source': 'local',
            });
          }
        } catch (_) {}
      },
    );

    // Handle app launched by tapping a local notification (terminated state)
    final launchDetails = await _plugin.getNotificationAppLaunchDetails();
    if ((launchDetails?.didNotificationLaunchApp ?? false) &&
        navigatorKey.currentContext != null) {
      handleNotification(navigatorKey.currentContext!, {'source': 'local'});
    }

    // 3. طلب صلاحيات Android 13+
    final androidImpl =
        _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    await androidImpl?.requestNotificationsPermission();
    await androidImpl?.requestExactAlarmsPermission();

    // Check if we can schedule exact notifications
    try {
      final canScheduleExact =
          await androidImpl?.canScheduleExactNotifications() ?? false;
      _androidScheduleMode =
          canScheduleExact
              ? AndroidScheduleMode.exactAllowWhileIdle
              : AndroidScheduleMode.inexactAllowWhileIdle;
    } catch (_) {
      _androidScheduleMode = AndroidScheduleMode.inexactAllowWhileIdle;
    }

    final iosImpl =
        _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();
    await iosImpl?.requestPermissions(alert: true, badge: true, sound: true);

    // 4. جدولة الإشعارات اليومية
    await _scheduleDailyMorningAndEvening();
  }

  /// ⏰ جدولة إشعارين يوميًا: صباحًا ومساءً
  static Future<void> _scheduleDailyMorningAndEvening() async {
    final now = DateTime.now();

    // 🕣 8:00 صباحًا
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

    // 🌙 8:00 مساءً
    final eveningTime = DateTime(now.year, now.month, now.day, 20);
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

    int daysUntilFriday = DateTime.friday - now.weekday;
    if (daysUntilFriday < 0) daysUntilFriday += 7;

    final fridayTime = DateTime(
      now.year,
      now.month,
      now.day,
      15,
    ).add(Duration(days: daysUntilFriday));

    await scheduleNotification(
      id: 3,
      title: 'جمعة مباركة 🌸',
      body: 'لا تنس قرءاة سورة الكهف ❤️',
      dateTime: fridayTime,
      repeat: DateTimeComponents.dayOfWeekAndTime, // تكرار أسبوعي
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
          visibility: NotificationVisibility.public,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: _androidScheduleMode,
      matchDateTimeComponents: repeat,
      payload: payload ?? '{"source":"local"}',
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

  /// 📅 جدولة إشعار خاص بالخاتمة
  static Future<void> scheduleKhatmahNotification({
    required String khatmahId,
    required String khatmahName,
    required DateTime notificationTime,
  }) async {
    final int notificationId = _getKhatmahNotificationId(khatmahId);
    final now = DateTime.now();

    // تأكد من أن الوقت غداً إذا كان قد مر وقت اليوم
    DateTime scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      notificationTime.hour,
      notificationTime.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await scheduleNotification(
      id: notificationId,
      title: 'وقت الخاتمة 📖',
      body: 'حان موعد وردك اليومي في خاتمة: $khatmahName',
      dateTime: scheduledDate,
      repeat: DateTimeComponents.time,
      payload: '{"source":"khatmah", "khatmahId":"$khatmahId"}',
    );
  }

  /// تحويل معرف الخاتمة (String) إلى معرف إشعار (int) فريد
  static int _getKhatmahNotificationId(String khatmahId) {
    return khatmahId.hashCode.abs() % 2147483647;
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  static Future<List<PendingNotificationRequest>>
  getPendingNotifications() async {
    return await _plugin.pendingNotificationRequests();
  }
}
