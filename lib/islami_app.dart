import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/constant/app_theme.dart';
import 'package:islami_app/core/router/app_routes.dart';
import 'package:islami_app/core/router/route.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:islami_app/feature/home/ui/view_model/theme_cubit/theme_cubit.dart';


class IslamiApp extends StatelessWidget {
  const IslamiApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final isDark = state is DarkThemeState;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'وَارْتَـقِ',
          locale: const Locale('ar'),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [Locale('ar')],
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          initialRoute: AppRoutes.splasahRouter,
          onGenerateRoute: AppRouter.generateRoute,
        );
      },
    );
  }
}
