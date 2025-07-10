import 'package:flutter/material.dart';
import 'package:islami_app/core/constant/app_theme.dart';
import 'package:islami_app/core/router/app_routes.dart';
import 'package:islami_app/core/router/route.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class IslamiApp extends StatelessWidget {
  const IslamiApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'القرءان الكريم',
      locale: const Locale('ar'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('ar')],
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.splasahRouter,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
