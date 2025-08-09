import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:islami_app/core/services/hive_service.dart';
import 'package:islami_app/core/services/setup_service_locator.dart';
import 'package:islami_app/feature/home/data/model/hadith_model.dart';
import 'package:islami_app/feature/home/data/model/recording_model.dart';
import 'package:islami_app/feature/home/ui/view_model/theme_cubit/theme_cubit.dart';
import 'package:islami_app/feature/notification/data/model/notification_model.dart';
import 'package:islami_app/feature/notification/widget/local_notification_service.dart';
import 'package:islami_app/feature/notification/widget/messaging_config.dart';
import 'package:islami_app/firebase_options.dart';
import 'package:islami_app/islami_app.dart';
import 'package:timezone/data/latest_all.dart' as tz;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log('Handling a background message: ${message.messageId}');
  await MessagingConfig.messageHandler(message);
}

class AppInitializer {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await setupServiceLocator();
    final themeCubit = sl<ThemeCubit>();

    await Hive.initFlutter();

    Hive
      ..registerAdapter(RecordingModelAdapter())
      ..registerAdapter(NotificationModelAdapter())
      ..registerAdapter(HadithModelAdapter());

    await sl<HiveService<RecordingModel>>().init();
    await sl<HiveService<NotificationModel>>().init();
    await Hive.openBox<List>('hadiths');

    await Future.wait([_initFirebaseMessaging(), _initLocalNotifications()]);

  
    runApp(
      MultiBlocProvider(
        providers: [BlocProvider.value(value: themeCubit)],
        child: ScreenUtilInit(
          designSize: const Size(402, 874),
          minTextAdapt: true,
          splitScreenMode: true,
          useInheritedMediaQuery: true,
          ensureScreenSize: true,
          enableScaleText: () => true,
          builder: (context, child) => const IslamiApp(),
        ),
      ),
    );
  }

  /// Firebase & Messaging Init
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
}
