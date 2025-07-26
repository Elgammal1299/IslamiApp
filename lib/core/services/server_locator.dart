import 'package:get_it/get_it.dart';

import 'package:shared_preferences/shared_preferences.dart';


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
