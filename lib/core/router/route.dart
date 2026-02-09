import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/helper/audio_manager.dart';
import 'package:islami_app/core/router/app_routes.dart';
import 'package:islami_app/core/router/router_transitions.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/quran_surah_screen.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/search_screen.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/nav_bar_cubit/nav_bar_cubit.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/quran_screen.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/tafsir_details_screen.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/surah/surah_cubit.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/tafsir_cubit/tafsir_cubit.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/reading_progress_cubit.dart';
import 'package:islami_app/feature/home/ui/view/about_app_screen.dart';
import 'package:islami_app/feature/home/ui/view/about_us_Screen.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view/now_playing_screen.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view/widget/reciters_surah_list.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view_model/audio_manager_cubit/audio_cubit.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/data/model/reciters_model.dart';
import 'package:islami_app/feature/home/ui/view/azkar/view/azkar_screen.dart';
import 'package:islami_app/feature/home/ui/view/azkar/view/azkar_yawmi_screen.dart';
import 'package:islami_app/feature/home/ui/view/azkar/view_model/azkar_cubit/azkar_cubit.dart';
import 'package:islami_app/feature/home/ui/view/azkar/view_model/azkar_yawmi_cubit/azkar_yawmi_cubit.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view_model/cubit/download_cubit.dart';
import 'package:islami_app/feature/home/ui/view/downloads_screen.dart';
import 'package:islami_app/feature/home/ui/view/hadith_details_screen.dart';
import 'package:islami_app/feature/home/ui/view/hadith_screen.dart';
import 'package:islami_app/feature/home/ui/view/home_screen.dart';
import 'package:islami_app/feature/khatmah/view/ui/khatmah_details_screen.dart';
import 'package:islami_app/feature/khatmah/view/ui/khatmah_screen.dart';
import 'package:islami_app/feature/khatmah/view/widget/khatmah_list_screen.dart';
import 'package:islami_app/feature/khatmah/view_model/khatmah_cubit.dart';
import 'package:islami_app/feature/prayerTime/presentation/pages/prayer_times_screen.dart';
import 'package:islami_app/feature/home/ui/view/qiblah_screen.dart';
import 'package:islami_app/feature/home/ui/view/radio_screen.dart';
import 'package:islami_app/feature/home/ui/view/radio_player_screen.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view/reciters_screen.dart';
import 'package:islami_app/feature/home/ui/view/sebha_screen.dart';
import 'package:islami_app/feature/home/ui/view_model/hadith_cubit/hadith_cubit.dart';
import 'package:islami_app/feature/home/ui/view_model/radio_cubit/radio_cubit.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view_model/reciterCubit/reciter_cubit.dart';
import 'package:islami_app/feature/notification/ui/view/notification_screen.dart';
import 'package:islami_app/feature/notification/ui/view/notification_view.dart';
import 'package:islami_app/feature/notification/ui/view_model/cubit/notification_cubit.dart';
import 'package:islami_app/core/services/setup_service_locator.dart';

class AppRouter {
  static Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.downloadsRouter:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider.value(
                value: sl<DownloadCubit>(),
                child: const DownloadsScreen(),
              ),
        );
      case AppRoutes.khatmahListRouter:
        return RouterTransitions.buildHorizontal(
          BlocProvider(
            create: (_) => sl<KhatmahCubit>(),
            child: const KhatmahListScreen(),
          ),
        );

      case AppRoutes.createKhatmahRouter:
        return RouterTransitions.buildHorizontal(
          BlocProvider.value(
            value: sl<KhatmahCubit>(),
            child: const CreateKhatmahScreen(),
          ),
        );

      case AppRoutes.khatmahDetailsRouter:
        final args = settings.arguments as Map<String, dynamic>?;
        final khatmahId = args?['khatmahId'] as String?;

        if (khatmahId == null) {
          throw ArgumentError('khatmahId is required');
        }

        return RouterTransitions.buildHorizontal(
          BlocProvider.value(
            value: sl<KhatmahCubit>(),
            child: KhatmahDetailsScreen(khatmahId: khatmahId),
          ),
        );
      case AppRoutes.prayertimesRouter:
        return RouterTransitions.buildHorizontal(const PrayerTimesScreen());
      case AppRoutes.aboutAppRouter:
        return RouterTransitions.buildHorizontal(const AboutAppScreen());
      case AppRoutes.aboutUsRouter:
        return RouterTransitions.buildHorizontal(const AboutUsScreen());
      case AppRoutes.notificationViewRouter:
        final args = settings.arguments as Map<String, dynamic>?;

        final title = args?['title'] ?? '';
        final body = args?['body'] ?? '';
        return RouterTransitions.buildHorizontal(
          NotificationView(title: title, body: body),
        );
      case AppRoutes.notificationScreenRouter:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (_) => sl<NotificationCubit>()..init(),
                child: const NotificationScreen(),
              ),
        );

      case AppRoutes.homeRoute:
        return MaterialPageRoute(
          builder:
              (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(create: (context) => sl<NavBarCubit>()),
                  BlocProvider.value(value: sl<SurahCubit>()),
                  BlocProvider.value(value: sl<ReadingProgressCubit>()),
                ],
                child: const HomeScreen(),
              ),
        );
    

      case AppRoutes.sebhaPageRouter:
        return MaterialPageRoute(builder: (_) => const SebhaScreen());

      case AppRoutes.azkarPageRouter:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (context) => sl<AzkarCubit>()..loadAzkar(),
                child: const AzkarScreen(),
              ),
        );
      case AppRoutes.azkarYawmiScreen:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (context) => sl<AzkarYawmiCubit>()..loadSupplications(),
                child: const AzkarYawmiScreen(),
              ),
        );
      case AppRoutes.qiblahRouter:
        return MaterialPageRoute(builder: (_) => const QiblahScreen());

      case AppRoutes.navBarRoute:
        return MaterialPageRoute(
          builder:
              (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => sl<SurahCubit>()..getSurahs(),
                  ),
                 
                ],
                child: const QuranSurahScreen(),
              ),
        );

      case AppRoutes.quranViewRouter:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider.value(
                value: sl<ReadingProgressCubit>(),
                child: QuranViewScreen(pageNumber: args?['pageNumber']),
              ),
        );

      case AppRoutes.tafsirDetailsByAyahRouter:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (context) => sl<TafsirCubit>(),
                child: TafsirDetailsScreen(
                  tafsirIdentifier: args?['tafsirIdentifier'],
                  verse: args?['verse'],
                  text: args?['text'],
                ),
              ),
        );

      case AppRoutes.searchRouter:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (context) => sl<SurahCubit>()..getSurahs(),
                child: const SearchScreen(),
              ),
        );
      case AppRoutes.hadithDetailsRouter:
        final hadithCubit = settings.arguments as HadithCubit;
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider.value(
                value: hadithCubit,
                child: const HadithDetailsScreen(),
              ),
        );

      case AppRoutes.hadithRouter:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (context) => sl<HadithCubit>(),

                child: const HadithScreen(),
              ),
        );

      case AppRoutes.radioPageRouter:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider.value(
                value: sl<RadioCubit>(),
                child: const RadioScreen(),
              ),
        );

      case AppRoutes.radioPlayerRouter:
        final args = settings.arguments as Map<String, dynamic>?;
        final radioCubit = args?['radioCubit'] as RadioCubit?;
        final station = args?['station'];

        return MaterialPageRoute(
          builder: (context) {
            if (radioCubit == null) {
              throw ArgumentError('radioCubit cannot be null');
            }
            return BlocProvider.value(
              value: radioCubit,
              child: RadioPlayerScreen(station: station),
            );
          },
        );

      case AppRoutes.recitersPageRouter:
        return MaterialPageRoute(
          builder:
              (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => sl<ReciterCubit>()..fetchReciters(),
                  ),
                  BlocProvider.value(value: sl<AudioCubit>()),
                ],
                child: const RecitersScreen(),
              ),
        );
      case AppRoutes.recitersSurahListRouter:
        final args = settings.arguments as Map<String, dynamic>?;
        final moshaf = args?['moshaf'] as Moshaf?;
        final name = args?['name'] as String?;

        if (moshaf == null || name == null) {
          throw ArgumentError('moshaf and name are required');
        }

        return MaterialPageRoute(
          builder:
              (_) => BlocProvider.value(
                value: sl<AudioCubit>(),
                child: RecitersSurahList(moshaf: moshaf, name: name),
              ),
        );

      case AppRoutes.nowPlayingScreenRouter:
        final audioManager = settings.arguments as AudioManager;
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider.value(
                value: sl<AudioCubit>(),
                child: NowPlayingScreen(audioManager: audioManager),
              ),
        );

      default:
        return null;
    }
  }
}
