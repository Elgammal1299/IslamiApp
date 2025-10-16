// import 'dart:developer';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// import 'package:islami_app/core/services/setup_service_locator.dart';

// import 'package:islami_app/feature/home/ui/view_model/theme_cubit/theme_cubit.dart';

// import 'package:islami_app/feature/notification/widget/messaging_config.dart';
// import 'package:islami_app/firebase_options.dart';
// import 'package:islami_app/islami_app.dart';

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   log('Handling a background message: ${message.messageId}');
//   await MessagingConfig.messageHandler(message);
// }

// class AppInitializer {
//   static Future<void> init() async {
//     await Hive.initFlutter();
//     WidgetsFlutterBinding.ensureInitialized();

//     await setupServiceLocator();
//     final themeCubit = sl<ThemeCubit>();
//     await SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     runApp(
//       MultiBlocProvider(
//         providers: [BlocProvider.value(value: themeCubit)],
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

//     // Hive
//     //   ..registerAdapter(RecordingModelAdapter())
//     //   ..registerAdapter(NotificationModelAdapter());
//     // //   ..registerAdapter(HadithModelAdapter());

//     // await sl<HiveService<RecordingModel>>().init();
//     // await sl<HiveService<NotificationModel>>().init();
//     // await Hive.openBox<List>('hadiths');
//   }
// }
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:islami_app/core/services/setup_service_locator.dart';
import 'package:islami_app/core/services/hive_service.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/data/model/download_model.dart';
import 'package:islami_app/feature/home/ui/view_model/theme_cubit/theme_cubit.dart';
import 'package:islami_app/feature/notification/widget/messaging_config.dart';
import 'package:islami_app/firebase_options.dart';
import 'package:islami_app/islami_app.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log('Handling a background message: ${message.messageId}');
  await MessagingConfig.messageHandler(message);
}

class AppInitializer {
  static Future<void> init() async {
    // ✅ 1. Initialize Flutter binding FIRST
    WidgetsFlutterBinding.ensureInitialized();

    // ✅ 2. Initialize Firebase EARLY (before anything else)
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      log('✅ Firebase initialized successfully');

      // ✅ 3. Setup background message handler
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      // ✅ 4. Subscribe to topic immediately
      await FirebaseMessaging.instance.subscribeToTopic('all');
      log('✅ Subscribed to topic: all');

      // ✅ 5. Request permissions
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      log('🔔 Notification Permission Status: ${settings.authorizationStatus}');

      // ✅ 6. Get and log token
      final token = await FirebaseMessaging.instance.getToken();
      log('📲 FCM Token: $token');

      // ✅ 7. Initialize messaging config
      await MessagingConfig.initFirebaseMessaging();
    } catch (e) {
      log('❌ Firebase initialization error: $e');
      // Don't throw - let app continue without Firebase
    }

    // ✅ 8. Initialize Hive
    await Hive.initFlutter();
    // Register Hive adapters
    try {
      if (!Hive.isAdapterRegistered(31)) {
        Hive.registerAdapter(DownloadModelAdapter());
      }
    } catch (_) {}

    // ✅ 9. Setup service locator
    await setupServiceLocator();
    final themeCubit = sl<ThemeCubit>();
    // Ensure the downloads Hive box is opened before creating DownloadCubit
    try {
      await sl<HiveService<DownloadModel>>().init();
    } catch (_) {}

    // ✅ 10. Set orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // ✅ 11. Run app
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
}
