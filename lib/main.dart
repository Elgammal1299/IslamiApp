import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:islami_app/core/helper/audio_manager.dart';
import 'package:islami_app/core/services/hive_service.dart';
import 'package:islami_app/feature/home/data/model/recording_model.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view_model/audio_manager_cubit/audio_cubit.dart';
import 'package:islami_app/feature/home/ui/view_model/theme_cubit/theme_cubit.dart';
import 'package:islami_app/feature/notification/data/model/notification_model.dart';
import 'package:islami_app/feature/notification/widget/local_notification_service.dart';
import 'package:islami_app/feature/notification/widget/messaging_config.dart';
import 'package:islami_app/firebase_options.dart';
import 'package:islami_app/islami_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Firebase is initialized
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log('Handling a background message: ${message.messageId}');
  await MessagingConfig.messageHandler(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await MessagingConfig.initFirebaseMessaging();
  String? token = await FirebaseMessaging.instance.getToken();
  log("📲 FCM Token: $token");
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission();

  log("🔔 Notification Permission Status: ${settings.authorizationStatus}");

  await SharedPreferences.getInstance();
  await Hive.initFlutter();
  
  Hive.registerAdapter(RecordingModelAdapter());
  Hive.registerAdapter(NotificationModelAdapter());
  final audioBox = HiveService.instanceFor<RecordingModel>(boxName: "audioBox");
  await audioBox.init();
  final notificationsBox = HiveService.instanceFor<NotificationModel>(
    boxName: 'notifications',
  );
  await notificationsBox.init();
  tz.initializeTimeZones();
  await LocalNotificationService.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AudioCubit(AudioManager())),
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      child: const IslamiApp(),
    ),
  );
}
