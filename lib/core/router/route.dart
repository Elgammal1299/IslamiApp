import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/helper/audio_manager.dart';
import 'package:islami_app/core/router/app_routes.dart';
import 'package:islami_app/core/services/api/hadith_db.dart';
import 'package:islami_app/core/services/api/quran_audio_api.dart';
import 'package:islami_app/core/services/api/surah_db.dart';
import 'package:islami_app/core/services/api/tafsir_service.dart';
import 'package:islami_app/core/services/radio_service.dart';
import 'package:islami_app/feature/home/data/repo/hadith_repo.dart';
import 'package:islami_app/feature/botton_nav_bar/data/repo/surah_repository.dart';
import 'package:islami_app/feature/botton_nav_bar/data/repo/tafsir_repo.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/bottom_navbar_page.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/quran_page.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/tafsir_details_page.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/surah/surah_cubit.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/tafsir_cubit/tafsir_cubit.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/data/repo/reciters_repo.dart';
import 'package:islami_app/feature/home/data/repo/quran_with_tafsir.dart';
import 'package:islami_app/feature/home/data/repo/radio_repository.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view_model/audio_manager_cubit/audio_cubit.dart';
import 'package:islami_app/feature/home/ui/view/audio_player_page.dart';
import 'package:islami_app/feature/home/ui/view/azkar_page.dart';
import 'package:islami_app/feature/home/ui/view/hadith_details_page.dart';
import 'package:islami_app/feature/home/ui/view/hadith_page.dart';
import 'package:islami_app/feature/home/ui/view/home_screen.dart';
import 'package:islami_app/feature/home/ui/view/qiblah_screen.dart';
import 'package:islami_app/feature/home/ui/view/quran_audio_surah_list.dart';
import 'package:islami_app/feature/home/ui/view/radio_page.dart';
import 'package:islami_app/feature/home/ui/view/radio_player_page.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view/reciters_screen.dart';
import 'package:islami_app/feature/home/ui/view/sebha_page.dart';
import 'package:islami_app/feature/home/ui/view/tafsir_page.dart';
import 'package:islami_app/feature/home/ui/view_model/hadith_cubit/hadith_cubit.dart';
import 'package:islami_app/feature/home/ui/view_model/quran_with_tafsir_cubit/quran_with_tafsir_cubit.dart';
import 'package:islami_app/feature/home/ui/view_model/radio_cubit/radio_cubit.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view_model/reciterCubit/reciter_cubit.dart';
import 'package:islami_app/feature/splash_screen/splah_page.dart';

class AppRouter {
  static Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splasahRouter:
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case AppRoutes.homeRoute:
        return MaterialPageRoute(builder: (_) => HomeScreen());

      case AppRoutes.sebhaPageRouter:
        return MaterialPageRoute(builder: (_) => SebhaPage());

      case AppRoutes.azkarPageRouter:
        return MaterialPageRoute(builder: (_) => AzkarPage());
      case AppRoutes.qiblahRouter:
        return MaterialPageRoute(builder: (_) => QiblahScreen());

      case AppRoutes.navBarRoute:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create:
                    (context) =>
                        SurahCubit(JsonRepository(SurahJsonServer()))
                          ..getSurahs(),
                child: BottomNavbarPage(),
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
                create:
                    (context) => TafsirCubit(
                      TafsirByAyahRepository(TafsirService(Dio())),
                    ),
                child: TafsirDetailsPage(
                  tafsirIdentifier: args?['tafsirIdentifier'],
                  verse: args?['verse'],
                  text: args?['text'],
                ),
              ),
        );

      case AppRoutes.quranAudioSurahListRouter:
        return MaterialPageRoute(builder: (_) => QuranAudioSurahList());

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
                create:
                    (context) => HadithCubit(HadithRepo(HadithJsonServer())),
                child: HadithPage(),
              ),
        );

      case AppRoutes.audioPlayerPageRouter:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder:
              (_) => AudioPlayerPage(
                surahIndex: args?['surahIndex'],
                surahName: args?['surahName'],
              ),
        );

      case AppRoutes.radioPageRouter:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create:
                    (context) =>
                        RadioCubit(RadioRepository(RadioService(Dio()))),
                child: RadioPage(),
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
                create:
                    (context) => QuranWithTafsirCubit(
                      QuranWithTafsirRepo(TafsirService(Dio())),
                    ),
                child: TafsirPage(),
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
                    create:
                        (context) =>
                            ReciterCubit(ReciterRepo(QuranAudioService(Dio())))
                              ..fetchReciters(),
                  ),
                  BlocProvider(create: (context) => AudioCubit(AudioManager())),
                ],
                child: RecitersScreen(),
              ),
        );

      default:
        return null;
    }
  }
}
