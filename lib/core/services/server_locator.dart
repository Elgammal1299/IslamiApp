import 'package:get_it/get_it.dart';
import 'package:islami_app/core/init/firebase_messaging_service.dart';

import 'package:islami_app/core/services/hive_service_initializer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../init/notification_initializer.dart';
import '../init/theme_initializer.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  sl.registerSingleton<SharedPreferences>(
    await SharedPreferences.getInstance(),
  );
  // sl.registerLazySingleton(() => FirebaseInitializer());
  // sl.registerLazySingleton(() => HiveInitializer());
  // sl.registerLazySingleton(() => NotificationInitializer());
  // sl.registerLazySingleton(() => ThemeInitializer());
}
