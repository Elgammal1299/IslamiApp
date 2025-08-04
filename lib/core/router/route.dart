import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/router/app_routes.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/bookmarks/bookmark_cubit.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/nav_bar_cubit.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/bottom_navbar_page.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/quran_page.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/tafsir_details_page.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/surah/surah_cubit.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/tafsir_cubit/tafsir_cubit.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view_model/audio_manager_cubit/audio_cubit.dart';
import 'package:islami_app/feature/home/ui/view/audio_recording_screen.dart';
import 'package:islami_app/feature/home/ui/view/azkar/view/azkar_screen.dart';
import 'package:islami_app/feature/home/ui/view/azkar/view/azkar_yawmi_screen.dart';
import 'package:islami_app/feature/home/ui/view/azkar/view_model/azkar_cubit/azkar_cubit.dart';
import 'package:islami_app/feature/home/ui/view/azkar/view_model/azkar_yawmi_cubit/azkar_yawmi_cubit.dart';
import 'package:islami_app/feature/home/ui/view/hadith_details_page.dart';
import 'package:islami_app/feature/home/ui/view/hadith_page.dart';
import 'package:islami_app/feature/home/ui/view/home_screen.dart';
import 'package:islami_app/feature/home/ui/view/qiblah_screen.dart';
import 'package:islami_app/feature/home/ui/view/radio_page.dart';
import 'package:islami_app/feature/home/ui/view/radio_player_page.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view/reciters_screen.dart';
import 'package:islami_app/feature/home/ui/view/sebha_page.dart';
import 'package:islami_app/feature/home/ui/view/tafsir_page.dart';
import 'package:islami_app/feature/home/ui/view_model/audio_recording_cubit/audio_recording_cubit.dart';
import 'package:islami_app/feature/home/ui/view_model/hadith_cubit/hadith_cubit.dart';
import 'package:islami_app/feature/home/ui/view_model/quran_with_tafsir_cubit/quran_with_tafsir_cubit.dart';
import 'package:islami_app/feature/home/ui/view_model/radio_cubit/radio_cubit.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view_model/reciterCubit/reciter_cubit.dart';
import 'package:islami_app/feature/notification/ui/view/notification_screen.dart';
import 'package:islami_app/feature/notification/ui/view/notification_view.dart';
import 'package:islami_app/feature/notification/ui/view_model/cubit/notification_cubit.dart';
import 'package:islami_app/feature/splash_screen/splash_page.dart';
import 'package:islami_app/core/services/setup_service_locator.dart';

class AppRouter {
  static Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splasahRouter:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.notificationViewRouter:
        return MaterialPageRoute(builder: (_) => const NotificationView());
      case AppRoutes.notificationScreenRouter:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (_) => sl<NotificationCubit>()..init(),
                child: const NotificationScreen(),
              ),
        );

      case AppRoutes.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppRoutes.audioRecordingRouter:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (context) => sl<AudioRecordingCubit>(),
                child: const AudioRecordingScreen(),
              ),
        );

      case AppRoutes.sebhaPageRouter:
        return MaterialPageRoute(builder: (_) => const SebhaPage());

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
                  BlocProvider(create: (context) => sl<NavBarCubit>()),
                  BlocProvider(
                    create: (context) => sl<BookmarkCubit>()..loadBookmarks(),
                  ),
                ],
                child: const BottomNavbarPage(),
              ),
        );

      case AppRoutes.quranViewRouter:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder:
              (_) => QuranViewPage(
                jsonData: args?['jsonData'],
                pageNumber: args?['pageNumber'],
              ),
        );

      case AppRoutes.tafsirDetailsByAyahRouter:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (context) => sl<TafsirCubit>(),
                child: TafsirDetailsPage(
                  tafsirIdentifier: args?['tafsirIdentifier'],
                  verse: args?['verse'],
                  text: args?['text'],
                ),
              ),
        );

      case AppRoutes.hadithDetailsRouter:
        final hadithCubit = settings.arguments as HadithCubit;
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider.value(
                value: hadithCubit,
                child: const HadithDetailsPage(),
              ),
        );

      case AppRoutes.hadithRouter:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(

                create: (context) => sl<HadithCubit>(),

                child: const HadithPage(),
              ),
        );

      case AppRoutes.radioPageRouter:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (context) => sl<RadioCubit>(),
                child: const RadioPage(),
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
              child: RadioPlayerPage(station: station),
            );
          },
        );

      case AppRoutes.tafsirByQuranPageRouter:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (context) => sl<QuranWithTafsirCubit>(),
                child: const TafsirPage(),
              ),
        );

      case AppRoutes.tafsirByQuranContentRouter:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder:
              (_) => TafsirContentView(
                identifier: args?['identifier'] ?? "ar.muyassar",
              ),
        );
      case AppRoutes.recitersPageRouter:
        return MaterialPageRoute(
          builder:
              (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => sl<ReciterCubit>()..fetchReciters(),
                  ),
                  BlocProvider(create: (context) => sl<AudioCubit>()),
                ],
                child: const RecitersScreen(),
              ),
        );

      default:
        return null;
    }
  }
}
