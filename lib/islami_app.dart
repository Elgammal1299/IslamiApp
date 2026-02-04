import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/constant/app_theme.dart';
import 'package:islami_app/core/router/app_routes.dart';
import 'package:islami_app/core/router/route.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:islami_app/feature/home/ui/view_model/theme_cubit/theme_cubit.dart';
import 'package:islami_app/app_initializer.dart';

class IslamiApp extends StatelessWidget {
  const IslamiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final isDark = state is ThemeChanged ? state.isDark : false;
        return MaterialApp(
          themeAnimationCurve: Curves.easeInOutSine,
          themeAnimationDuration: const Duration(seconds: 2),
          debugShowCheckedModeBanner: false,
          title: 'وَارْتَـقِ',
          navigatorKey: navigatorKey,
          locale: const Locale('ar'),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [const Locale('ar')],
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          initialRoute: AppRoutes.homeRoute,
          onGenerateRoute: AppRouter.generateRoute,
        );
      },
    );
  }
}
