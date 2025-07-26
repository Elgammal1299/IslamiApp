import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:islami_app/core/constant/app_constant.dart';

import 'package:islami_app/core/helper/audio_manager.dart';
import 'package:islami_app/core/init/firebase_messaging_service.dart';

import 'package:islami_app/core/init/notification_initializer.dart';
import 'package:islami_app/core/init/theme_initializer.dart';
import 'package:islami_app/core/services/hive_service.dart';
import 'package:islami_app/core/services/hive_service_initializer.dart';
import 'package:islami_app/core/services/server_locator.dart';
import 'package:islami_app/feature/home/data/model/recording_model.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view_model/audio_manager_cubit/audio_cubit.dart';
import 'package:islami_app/feature/home/ui/view_model/theme_cubit/theme_cubit.dart';
import 'package:islami_app/feature/notification/data/model/notification_model.dart';
import 'package:islami_app/feature/notification/widget/local_notification_service.dart';
import 'package:islami_app/feature/notification/widget/messaging_config.dart';
import 'package:islami_app/firebase_options.dart';
import 'package:islami_app/islami_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    final themeCubit = ThemeCubit();
    await themeCubit.loadTheme();

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
    String? token = await FirebaseMessaging.instance.getToken();
    log("📲 FCM Token: $token");

    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission();
    log("🔔 Notification Permission Status: ${settings.authorizationStatus}");

    // await SharedPreferences.getInstance();
    await Hive.initFlutter();

    Hive.registerAdapter(RecordingModelAdapter());
    Hive.registerAdapter(NotificationModelAdapter());

    final audioBox = HiveService.instanceFor<RecordingModel>(
      boxName: AppConstant.hiveAudio,
    );
    await audioBox.init();

    final notificationsBox = HiveService.instanceFor<NotificationModel>(
      boxName: AppConstant.hivenotifications,
    );
    await notificationsBox.init();

    tz.initializeTimeZones();
    await LocalNotificationService.init();

    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AudioCubit(AudioManager())),
          BlocProvider.value(value: themeCubit),
        ],
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
}

// class AppInitializer {
//   static Future<void> init() async {
//     WidgetsFlutterBinding.ensureInitialized();

//     await setupServiceLocator();
//     await Future.wait([
//       sl<FirebaseInitializer>().init(),
//       sl<HiveInitializer>().init(),
//       sl<NotificationInitializer>().init(),
//       sl<ThemeInitializer>().init(),
//     ]);

//     final themeCubit = sl<ThemeInitializer>().themeCubit;

//     runApp(
//       MultiBlocProvider(
//         providers: [
//           BlocProvider(create: (context) => AudioCubit(AudioManager())),
//           BlocProvider.value(value: themeCubit),
//         ],
//         child: ScreenUtilInit(
//           designSize: const Size(402, 874),
//           minTextAdapt: true,
//           splitScreenMode: true,
//           useInheritedMediaQuery: true,
//           ensureScreenSize: true,
//           enableScaleText: () => true,
//           builder: (context, child) => const IslamiApp(),
//         ),
//       ),
//     );
//   }
// }
