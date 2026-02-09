import 'dart:developer';
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
import 'package:islami_app/feature/home/data/model/hadith_model.dart';
import 'package:islami_app/feature/khatmah/data/model/khatmah_model.dart';
import 'package:islami_app/feature/khatmah/utils/khatmah_constants.dart';
import 'package:islami_app/feature/notification/widget/local_notification_service.dart';
import 'package:islami_app/islami_app.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppInitializer {
  static Future<void> init() async {
    // ✅ 1. Initialize Flutter binding FIRST
    WidgetsFlutterBinding.ensureInitialized();

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
      if (!Hive.isAdapterRegistered(2) && !Hive.isAdapterRegistered(103)) {
        // Check both old and new
        Hive.registerAdapter(HadithModelAdapter());
      }
      // Khatmah Adapters - يجب تسجيلها بالترتيب الصحيح
      if (!Hive.isAdapterRegistered(KhatmahConstants.juzProgressTypeId)) {
        Hive.registerAdapter(JuzProgressAdapter());
      }
      if (!Hive.isAdapterRegistered(KhatmahConstants.dailyProgressTypeId)) {
        Hive.registerAdapter(DailyProgressAdapter());
      }
      if (!Hive.isAdapterRegistered(KhatmahConstants.khatmahModelTypeId)) {
        Hive.registerAdapter(KhatmahModelAdapter());
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

    // Initialize Khatmah service
    // NUCLEAR CLEANUP: Delete all potentially corrupted or conflicting boxes
    try {
      final boxesToClear = [
        'khatmahs',
        'khatmahs_v2',
        'khatmahs_v3',
        'hadiths',
        'hadiths_v2',
        'hadiths_v3',
      ];

      for (final box in boxesToClear) {
        try {
          if (Hive.isBoxOpen(box)) {
            await Hive.box(box).close();
          }
          await Hive.deleteBoxFromDisk(box);
        } catch (_) {}
      }
    } catch (_) {}

    try {
      await sl<HiveService<KhatmahModel>>().init();
    } catch (e) {
      log(
        '⚠️ Error initializing khatmah box (${KhatmahConstants.khatmahBoxName}): $e',
      );
    }

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
