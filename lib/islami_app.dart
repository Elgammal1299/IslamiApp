import 'package:flutter/material.dart';
import 'package:islami_app/core/router/app_routes.dart';
import 'package:islami_app/core/router/route.dart';

class IslamiApp extends StatelessWidget {
  const IslamiApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'القرءان الكريم',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          // useMaterial3: true,
        ),
        // home:  HomeScreen(),
        initialRoute: AppRoutes.splasahRouter,
        onGenerateRoute: AppRouter.generateRoute,
      
    );
  }
}