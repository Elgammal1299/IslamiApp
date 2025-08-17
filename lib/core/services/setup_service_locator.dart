import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Services
import 'api/tafsir_service.dart';
import 'api/hadith_service.dart';
import 'api/audio_service.dart';
import 'api/quran_audio_api.dart';
import 'api/surah_db.dart';
import 'hive_service.dart';
import 'radio_service.dart';
import 'bookmark_manager.dart';
import '../../core/helper/audio_manager.dart';

// Repositories
import '../../feature/home/data/repo/radio_repository.dart';
import '../../feature/botton_nav_bar/data/repo/surah_repository.dart';
import '../../feature/botton_nav_bar/data/repo/tafsir_repo.dart';

// Cubits
import '../../feature/home/ui/view_model/theme_cubit/theme_cubit.dart';
import '../../feature/home/ui/view/azkar/view_model/azkar_yawmi_cubit/azkar_yawmi_cubit.dart';
import '../../feature/home/ui/view/azkar/view_model/azkar_random_cubit/azkar_random_cubit.dart';
import '../../feature/home/ui/view/azkar/view_model/azkar_cubit/azkar_cubit.dart';
import '../../feature/home/ui/view_model/quran_with_tafsir_cubit/quran_with_tafsir_cubit.dart';
import '../../feature/home/ui/view_model/radio_cubit/radio_cubit.dart';
import '../../feature/home/ui/view/all_reciters/view_model/reciterCubit/reciter_cubit.dart';
import '../../feature/home/ui/view/all_reciters/view_model/audio_manager_cubit/audio_cubit.dart';
import '../../feature/home/ui/view_model/hadith_cubit/hadith_cubit.dart';
import '../../feature/home/ui/view_model/audio_recording_cubit/audio_recording_cubit.dart';
import '../../feature/botton_nav_bar/ui/view_model/tafsir_cubit/tafsir_cubit.dart';
import '../../feature/botton_nav_bar/ui/view_model/nav_bar_cubit/nav_bar_cubit.dart';
import '../../feature/botton_nav_bar/ui/view_model/surah/surah_cubit.dart';
import '../../feature/botton_nav_bar/ui/view_model/bookmarks/bookmark_cubit.dart';
import '../../feature/botton_nav_bar/ui/view_model/reading_progress_cubit.dart';
import '../../feature/notification/ui/view_model/cubit/notification_cubit.dart';

// Additional repositories needed for cubits
import '../../feature/home/ui/view/azkar/data/repo/azkar_yawmi_repo.dart';
import '../../feature/home/ui/view/azkar/data/repo/azkar_random_repo.dart';
import '../../feature/home/ui/view/azkar/data/repo/azkar_repo.dart';
import '../../feature/home/data/repo/quran_with_tafsir.dart';
import '../../feature/home/data/repo/hadith_repo.dart';
import '../../feature/home/ui/view/all_reciters/data/repo/reciters_repo.dart';

// Models
import '../../feature/home/data/model/recording_model.dart';
import '../../feature/notification/data/model/notification_model.dart';

final sl = GetIt.instance;

/// Setup global dependency injection using get_it
/// This function registers all services, repositories, and cubits
Future<void> setupServiceLocator() async {
  // ===== CORE SERVICES =====

  // SharedPreferences
  sl.registerSingleton<SharedPreferences>(
    await SharedPreferences.getInstance(),
  );

  // Dio for HTTP requests
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);

    return dio;
  });

  // ===== API SERVICES =====

  // TafsirService
  sl.registerLazySingleton<TafsirService>(() {
    return TafsirService(sl<Dio>());
  });

  // HadithService
  sl.registerLazySingleton<HadithService>(() {
    return HadithService();
  });

  // AudioService
  sl.registerLazySingleton<AudioService>(() {
    return AudioService();
  });

  // QuranAudioService
  sl.registerLazySingleton<QuranAudioService>(() {
    return QuranAudioService(sl<Dio>());
  });

  // SurahJsonServer
  sl.registerLazySingleton<SurahJsonServer>(() {
    return SurahJsonServer();
  });

  // RadioService
  sl.registerLazySingleton<RadioService>(() {
    return RadioService(sl<Dio>());
  });

  // AudioManager
  sl.registerLazySingleton<AudioManager>(() {
    return AudioManager();
  });

  // ===== STORAGE SERVICES =====

  // HiveService instances for different data types
  sl.registerLazySingleton<HiveService<dynamic>>(() {
    return HiveService.instanceFor<dynamic>(
      boxName: 'app_data',
      enableLogging: true,
    );
  });

  sl.registerLazySingleton<HiveService<String>>(() {
    return HiveService.instanceFor<String>(
      boxName: 'settings',
      enableLogging: true,
    );
  });

  sl.registerLazySingleton<HiveService<Map>>(() {
    return HiveService.instanceFor<Map>(
      boxName: 'user_data',
      enableLogging: true,
    );
  });

  sl.registerLazySingleton<HiveService<RecordingModel>>(() {
    return HiveService.instanceFor<RecordingModel>(
      boxName: 'audio_recordings',
      enableLogging: true,
    );
  });

  sl.registerLazySingleton<HiveService<NotificationModel>>(() {
    return HiveService.instanceFor<NotificationModel>(
      boxName: 'notifications',
      enableLogging: true,
    );
  });

  // BookmarkManager
  sl.registerLazySingleton<BookmarkManager>(() {
    return BookmarkManager(sl<SharedPreferences>());
  });

  // ===== REPOSITORIES =====

  // RadioRepository
  sl.registerLazySingleton<RadioRepository>(() {
    return RadioRepository(sl<RadioService>());
  });

  // Additional repositories needed for cubits
  sl.registerLazySingleton<AzkarYawmiRepo>(() {
    return AzkarYawmiRepo();
  });

  sl.registerLazySingleton<AzkarRandomRepo>(() {
    return AzkarRandomRepo();
  });

  sl.registerLazySingleton<AzkarRepo>(() {
    return AzkarRepo();
  });

  sl.registerLazySingleton<QuranWithTafsirRepo>(() {
    return QuranWithTafsirRepo(sl<TafsirService>());
  });

  sl.registerLazySingleton<HadithRepo>(() {
    return HadithRepo();
  });

  sl.registerLazySingleton<ReciterRepo>(() {
    return ReciterRepo(sl<QuranAudioService>());
  });

  // SurahRepository
  sl.registerLazySingleton<JsonRepository>(() {
    return JsonRepository(sl<SurahJsonServer>());
  });

  // TafsirRepository
  sl.registerLazySingleton<TafsirByAyahRepository>(() {
    return TafsirByAyahRepository(sl<TafsirService>());
  });

  // ===== CUBITS =====

  // ThemeCubit
  sl.registerLazySingleton<ThemeCubit>(() {
    return ThemeCubit();
  });

  // AzkarCubits
  sl.registerLazySingleton<AzkarYawmiCubit>(() {
    return AzkarYawmiCubit(sl<AzkarYawmiRepo>());
  });

  sl.registerLazySingleton<AzkarRandomCubit>(() {
    return AzkarRandomCubit(sl<AzkarRandomRepo>());
  });

  sl.registerLazySingleton<AzkarCubit>(() {
    return AzkarCubit(sl<AzkarRepo>());
  });

  // Quran and Tafsir Cubits
  sl.registerLazySingleton<QuranWithTafsirCubit>(() {
    return QuranWithTafsirCubit(sl<QuranWithTafsirRepo>());
  });

  sl.registerLazySingleton<TafsirCubit>(() {
    return TafsirCubit(sl<TafsirByAyahRepository>());
  });

  // Radio and Audio Cubits
  sl.registerLazySingleton<RadioCubit>(() {
    return RadioCubit(sl<RadioRepository>());
  });

  sl.registerLazySingleton<AudioCubit>(() {
    return AudioCubit(sl<AudioManager>());
  });

  sl.registerLazySingleton<AudioRecordingCubit>(() {
    return AudioRecordingCubit();
  });

  sl.registerLazySingleton<HadithCubit>(() {
    return HadithCubit(sl<HadithRepo>());
  });

  sl.registerLazySingleton<ReciterCubit>(() {
    return ReciterCubit(sl<ReciterRepo>());
  });

  // Navigation and UI Cubits
  sl.registerLazySingleton<NavBarCubit>(() {
    return NavBarCubit();
  });

  sl.registerLazySingleton<SurahCubit>(() {
    return SurahCubit(sl<JsonRepository>());
  });

  sl.registerLazySingleton<BookmarkCubit>(() {
    return BookmarkCubit(sl<BookmarkManager>());
  });

  // Notification Cubit
  sl.registerLazySingleton<NotificationCubit>(() {
    return NotificationCubit();
  });

  // Reading Progress Cubit
  sl.registerLazySingleton<ReadingProgressCubit>(() {
    return ReadingProgressCubit();
  });

  // ===== NOTE: Services will be initialized lazily when first accessed =====
  // No eager initialization - this improves app startup time significantly
}

/// Helper extension to make service locator usage more convenient
extension ServiceLocatorExtension on GetIt {
  T get<T extends Object>() => this<T>();
}
