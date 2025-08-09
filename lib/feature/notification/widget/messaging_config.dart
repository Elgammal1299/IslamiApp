import 'dart:developer';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:islami_app/app_initializer.dart';
import 'package:islami_app/feature/notification/data/repo/notification_repo.dart';
import 'package:islami_app/feature/notification/widget/handle_notification.dart';

class MessagingConfig {
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  /// إنشاء قناة تنبيهات لـ Android
  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'custom_channel',
      'Custom Notifications',
      description: 'This channel plays a custom sound.',
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('notifigation'), // بدون امتداد
      playSound: true,
      enableVibration: true,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  /// تهيئة الإشعارات
  static Future<void> initFirebaseMessaging() async {
    try {
      await _createNotificationChannel();

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      const InitializationSettings initializationSettings =
          InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
          );

      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          log("🔁 Notification clicked with payload: ${response.payload}");
          if (response.payload != null && navigatorKey.currentContext != null) {
            try {
              final Map<String, dynamic> payload = Map<String, dynamic>.from(
                jsonDecode(response.payload!),
              );
              handleNotification(navigatorKey.currentContext!, payload);
            } catch (e) {
              log("❌ Error parsing notification payload: $e");
            }
          }
        },
      );

      // 🔔 التطبيق شغال (foreground)
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        log("📲 Foreground message received: ${message.messageId}");
        await _showNotification(message);
        // Do not auto-navigate in foreground; wait for user click
      });

      // 💤 التطبيق كان مقفول وفتح من إشعار
      FirebaseMessaging.instance.getInitialMessage().then((message) {
        if (message != null) {
          log("📦 Initial message received: ${message.messageId}");
          final data = <String, dynamic>{'source': 'firebase', ...message.data};
          if (navigatorKey.currentContext != null) {
            handleNotification(navigatorKey.currentContext!, data);
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (navigatorKey.currentContext != null) {
                handleNotification(navigatorKey.currentContext!, data);
              }
            });
          }
        }
      });

      // 🔁 المستخدم فتح الإشعار من الخلفية
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        log("➡️ Notification clicked (background): ${message.messageId}");
        final data = <String, dynamic>{'source': 'firebase', ...message.data};
        handleNotification(navigatorKey.currentContext!, data);
      });

      // Set foreground notification presentation options
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
            alert: true,
            badge: true,
            sound: true,
          );
    } catch (e) {
      log("❌ Error initializing Firebase Messaging: $e");
    }
  }

  /// عرض الإشعار في foreground
  static Future<void> _showNotification(RemoteMessage message) async {
    try {
      RemoteNotification? notification = message.notification;
      log("📢 Showing notification: ${message.notification?.title}");

      if (notification != null) {
        log("🔔 Preparing to show notification with sound...");
        await _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'custom_channel',
              'Custom Notifications',
              channelDescription: '...',
              importance: Importance.max,
              priority: Priority.high,
              visibility: NotificationVisibility.public,
              playSound: true,
              largeIcon: const DrawableResourceAndroidBitmap(
                '@mipmap/ic_launcher',
              ),
              icon: '@mipmap/ic_launcher',
              sound: const RawResourceAndroidNotificationSound('notifigation'),

              enableVibration: true,

              enableLights: true,
              styleInformation: BigTextStyleInformation(
                notification.body ?? '',
                htmlFormatBigText: true,
                contentTitle: notification.title,
                htmlFormatContentTitle: true,
              ),
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
              sound:
                  'notifigation.mp3', // تأكد من وجود الملف في مجلد ios/Runner/Resources
            ),
          ),
          payload: jsonEncode({
            'source': 'firebase',
            'title': notification.title,
            'body': notification.body,
            ...message.data,
          }),
        );
        await NotificationRepo().logNotification(
          title: notification.title ?? 'بدون عنوان',
          body: notification.body ?? '',
          type: 'firebase',
        );
      }
    } catch (e) {
      log("❌ Error showing notification: $e");
    }
  }

  /// لمعالجة الرسائل في الخلفية
  @pragma('vm:entry-point')
  static Future<void> messageHandler(RemoteMessage message) async {
    log('📥 Background message received: ${message.messageId}');
    try {
      // Create a local notifications plugin instance for the background isolate
      final FlutterLocalNotificationsPlugin backgroundPlugin =
          FlutterLocalNotificationsPlugin();

      // Ensure the Android channel exists (safe to call multiple times)
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'custom_channel',
        'Custom Notifications',
        description: 'This channel plays a custom sound.',
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound('notifigation'),
        playSound: true,
        enableVibration: true,
      );

      await backgroundPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);

      final RemoteNotification? remote = message.notification;
      final String title =
          remote?.title ?? message.data['title'] ?? 'إشعار جديد';
      final String body = remote?.body ?? message.data['body'] ?? '';

      await backgroundPlugin.show(
        message.hashCode,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'custom_channel',
            'Custom Notifications',
            channelDescription: '...',
            importance: Importance.max,
            priority: Priority.high,
            visibility: NotificationVisibility.public,
            playSound: true,
            icon: '@mipmap/ic_launcher',
            sound: RawResourceAndroidNotificationSound('notifigation'),
            enableVibration: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            sound: 'notifigation.mp3',
          ),
        ),
        payload: jsonEncode({'source': 'firebase', ...message.data}),
      );
    } catch (e) {
      log('❌ Error showing background notification: $e');
    }
  }
}
