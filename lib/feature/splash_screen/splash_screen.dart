import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:islami_app/core/constant/app_image.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/core/router/app_routes.dart';
import 'package:islami_app/core/services/hive_service.dart';
import 'package:islami_app/core/services/setup_service_locator.dart';
import 'package:islami_app/feature/home/data/model/recording_model.dart';
import 'package:islami_app/feature/home/services/notification_service.dart';
import 'package:islami_app/feature/home/services/prayer_times_service.dart';
import 'package:islami_app/feature/notification/data/model/notification_model.dart';
import 'package:islami_app/feature/notification/widget/local_notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:islami_app/feature/notification/widget/messaging_config.dart';
import 'package:islami_app/firebase_options.dart';

// Notifications
import 'package:timezone/data/latest.dart' as tz;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ValueNotifier<bool> isMuted = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _playSplashAudio();

    Future.delayed(const Duration(seconds: 8), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.homeRoute);
    });
  }

  Future<void> _playSplashAudio() async {
    try {
      await _audioPlayer.play(AssetSource('audio/splah-audio.mp3'));
      final provider = SharedPrayerTimesProvider.instance;
      await provider.initialize();
      final notificationService = PrayerNotificationService();

      _initHive();

      await _initLocalNotifications();

      try {
        await _initFirebaseMessaging();
      } catch (e) {
        debugPrint("⚠️ تخطيت Firebase Messaging بسبب: $e");
      }

      await notificationService.init();

      await notificationService.scheduleForDay(
        prayerTimes: provider.namedTimes,
        day: DateTime.now(),
        preReminderEnabled: true,
        prayerName: provider.getPrayerName,
      );
    } catch (e) {
      debugPrint("❌ خطأ أثناء التهيئة: $e");
    }
  }

  void _initHive() {
  
      Hive.registerAdapter(RecordingModelAdapter());

   
      Hive.registerAdapter(NotificationModelAdapter());


    sl<HiveService<RecordingModel>>().init();
    sl<HiveService<NotificationModel>>().init();
  }

  static Future<void> _initFirebaseMessaging() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await FirebaseMessaging.instance.subscribeToTopic('all');
    log("✅ Subscribed to topic: all_users");

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    await MessagingConfig.initFirebaseMessaging();

    final token = await FirebaseMessaging.instance.getToken();
    log("📲 FCM Token: $token");

    final settings = await FirebaseMessaging.instance.requestPermission();
    log("🔔 Notification Permission Status: ${settings.authorizationStatus}");
  }

  /// Local Notifications Init
  static Future<void> _initLocalNotifications() async {
    tz.initializeTimeZones();
    await LocalNotificationService.init();
  }

  void _toggleMute() async {
    if (isMuted.value) {
      await _audioPlayer.resume();
    } else {
      await _audioPlayer.pause();
    }
    isMuted.value = !isMuted.value;
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    isMuted.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 120,
                  backgroundColor: const Color(0xff008000),
                  child: Image.asset(
                    isDark
                        ? AppImage.splashImageDark
                        : AppImage.splashImageLight,
                    width: 300,
                    height: 300,
                  ),
                ),
                const SizedBox(height: 16),
                Text('وَارْتَـقِ', style: context.textTheme.titleLarge),
                const SizedBox(height: 10),
                Text('كل ما يخص المسلم', style: context.textTheme.titleLarge),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            right: 20,
            child: ValueListenableBuilder<bool>(
              valueListenable: isMuted,
              builder: (context, muted, _) {
                return IconButton(
                  onPressed: _toggleMute,
                  icon: Icon(
                    muted ? Icons.volume_off : Icons.volume_up,
                    size: 30,
                    color: Colors.grey[800],
                  ),
                  tooltip: muted ? 'تشغيل الصوت' : 'كتم الصوت',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// لازم تكون معرف handler ل Firebase Messaging
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("📩 رسالة جديدة في الخلفية: ${message.messageId}");
}
