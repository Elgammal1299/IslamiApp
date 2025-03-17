import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/router/app_routes.dart';
import 'package:islami_app/core/router/route.dart';
import 'package:islami_app/core/services/api/tafsir_service.dart';
import 'package:islami_app/core/services/radio_service.dart';
import 'package:islami_app/feature/botton_nav_bar/data/repo/tafsir_repo.dart';
import 'package:islami_app/feature/home/data/repo/quran_with_tafsir.dart';
import 'package:islami_app/feature/home/data/repo/radio_repository.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/tafsir_cubit/tafsir_cubit.dart';
import 'package:islami_app/feature/home/ui/view_model/radio_cubit/radio_cubit.dart';
import 'package:islami_app/feature/home/ui/view_model/quran_with_tafsir_cubit/quran_with_tafsir_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // مهم جداً
  await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  TafsirCubit(TafsirByAyahRepository(TafsirService(Dio()))),
        ),

        BlocProvider(
          create:
              (context) => QuranWithTafsirCubit(
                QuranWithTafsirRepo(TafsirService(Dio())),
              ),
        ),
        // BlocProvider(
        //   create: (context) => RadioCubit(RadioRepository(RadioService(Dio()))),
        // ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'القرءان الكريم',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          // useMaterial3: true,
        ),
        // home:  HomeScreen(),
        initialRoute: AppRoutes.splasahRouter,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
