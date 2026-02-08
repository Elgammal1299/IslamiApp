
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:islami_app/core/services/setup_service_locator.dart';
import 'package:islami_app/core/services/hive_service.dart';
import 'package:islami_app/feature/home/services/location_service.dart';
import 'package:islami_app/feature/home/services/notification_service.dart';
import 'package:islami_app/feature/home/services/prayer_times_service.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/data/model/download_model.dart';
import 'package:islami_app/feature/home/ui/view_model/theme_cubit/theme_cubit.dart';
import 'package:islami_app/feature/notification/data/model/notification_model.dart';
import 'package:islami_app/feature/notification/widget/local_notification_service.dart';
import 'package:islami_app/feature/notification/widget/messaging_config.dart';
import 'package:islami_app/firebase_options.dart';
import 'package:islami_app/islami_app.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Check if device has internet connectivity
Future<bool> _hasInternetConnection() async {
  try {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi);
  } catch (e) {
    log('❌ Error checking connectivity: $e');
    return false;
  }
}

/// Initialize Firebase messaging features (non-blocking)
Future<void> _initializeFirebaseMessagingFeatures() async {
  try {
    // Check connectivity first
    final hasConnection = await _hasInternetConnection();
    if (!hasConnection) {
      log('📱 No internet connection - skipping Firebase messaging features');
      return;
    }

    // ✅ Subscribe to topic
    await FirebaseMessaging.instance.subscribeToTopic('all');
    log('✅ Subscribed to topic: all');

    // ✅ Get and log token
    final token = await FirebaseMessaging.instance.getToken();
    log('📲 FCM Token: $token');
  } catch (e) {
    log('❌ Error initializing Firebase messaging features: $e');
  }
}

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

    // ✅ 2. Initialize Firebase (non-blocking)
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      log('✅ Firebase initialized successfully');

      // ✅ 3. Setup background message handler
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      // ✅ 4. Request permissions (this is local, doesn't need network)
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      log('🔔 Notification Permission Status: ${settings.authorizationStatus}');

      // ✅ 5. Initialize messaging config (local setup)
      await MessagingConfig.initFirebaseMessaging();

      // ✅ 6. Initialize network-dependent features in background (non-blocking)
      _initializeFirebaseMessagingFeatures();
    } catch (e) {
      log('❌ Firebase initialization error: $e');
      // Don't throw - let app continue without Firebase
    }

    // ✅ 7. Initialize Hive
    await Hive.initFlutter();
    // Register Hive adapters
    try {
      if (!Hive.isAdapterRegistered(31)) {
        Hive.registerAdapter(DownloadModelAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(NotificationModelAdapter());
      }
      
    } catch (_) {}

    // ✅ 8. Setup service locator
    await setupServiceLocator();
    final themeCubit = sl<ThemeCubit>();

    // ✅ 9. Initialize Hive services
    try {
      await sl<HiveService<DownloadModel>>().init();
      await sl<HiveService<NotificationModel>>().init();
    } catch (_) {}

    // ✅ 10. Initialize additional services in background (non-blocking)
    _initializeAppServices();

    // ✅ 11. Set orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // ✅ 12. Run app
    runApp(
      MultiBlocProvider(
        providers: [BlocProvider.value(value: themeCubit)],
        child: ScreenUtilInit(
          designSize: const Size(360, 780),
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

  /// Initialize additional app services in background (non-blocking)
  static void _initializeAppServices() async {
    try {
      // ✅ Initialize local notifications
      await _initLocalNotifications();

      // ✅ Initialize prayer times provider with LocationService
      final provider = SharedPrayerTimesProvider.instance;
      final locationService = sl<LocationService>();
      provider.setLocationService(locationService);
      await provider.initialize();

      // ✅ Setup prayer notifications
      final notificationService = PrayerNotificationService();
      await notificationService.init();
      await notificationService.scheduleForDay(
        prayerTimes: provider.namedTimes,
        day: DateTime.now(),
        preReminderEnabled: true,
        prayerName: provider.getPrayerName,
      );


      log('✅ App services initialized successfully');
    } catch (e) {
      log('❌ Error initializing app services: $e');
    }
  }

  /// Initialize local notifications
  static Future<void> _initLocalNotifications() async {
    try {
      tz.initializeTimeZones();
      await LocalNotificationService.init();
    } catch (e) {
      log('❌ Error initializing local notifications: $e');
    }
  }

}
