import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:islami_app/core/services/setup_service_locator.dart';

import 'package:islami_app/feature/home/ui/view_model/theme_cubit/theme_cubit.dart';

import 'package:islami_app/feature/notification/widget/messaging_config.dart';
import 'package:islami_app/firebase_options.dart';
import 'package:islami_app/islami_app.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log('Handling a background message: ${message.messageId}');
  await MessagingConfig.messageHandler(message);
}

class AppInitializer {
  static Future<void> init() async {
    await Hive.initFlutter();
    WidgetsFlutterBinding.ensureInitialized();

    await setupServiceLocator();
    final themeCubit = sl<ThemeCubit>();
    runApp(
      MultiBlocProvider(
        providers: [BlocProvider.value(value: themeCubit)],
        child: ScreenUtilInit(
          designSize: const Size(402, 874),
          minTextAdapt: true,
          splitScreenMode: true,
          useInheritedMediaQuery: true,
          ensureScreenSize: true,
          enableScaleText: () => true,
          builder: (context, child) => const IslamiApp(),
        ),
      ),
    );

    // Hive
    //   ..registerAdapter(RecordingModelAdapter())
    //   ..registerAdapter(NotificationModelAdapter());
    // //   ..registerAdapter(HadithModelAdapter());

    // await sl<HiveService<RecordingModel>>().init();
    // await sl<HiveService<NotificationModel>>().init();
    // await Hive.openBox<List>('hadiths');
  }
}
