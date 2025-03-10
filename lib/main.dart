import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/services/api/api_service.dart';
import 'package:islami_app/core/surah_db.dart';
import 'package:islami_app/feature/home/data/repo/surah_repository.dart';
import 'package:islami_app/feature/home/data/repo/tafsir_repo.dart';
import 'package:islami_app/feature/home/ui/view/home_screen.dart';
import 'package:islami_app/feature/home/ui/view_model/surah/surah_cubit.dart';
import 'package:islami_app/feature/home/ui/view_model/tafsir_cubit/tafsir_cubit.dart';
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
              (context) => TafsirCubit(QuranRepository(QuranApiService(Dio()))),
        ),
        BlocProvider(
          create:
              (context) =>
                  SurahCubit(JsonRepository(SurahJsonServer()))..getSurahs(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:islami_app/core/services/api/api_service.dart';
// import 'package:islami_app/feature/home/data/repo/tafsir_repo.dart';

// import 'package:dio/dio.dart';
// import 'package:islami_app/feature/home/ui/view/test_tafasir.dart';
// import 'package:islami_app/feature/home/ui/view_model/tafsir_cubit/tafsir_cubit.dart';

// void main() {
//   final dio = Dio(); // إنشاء كائن Dio
//   final apiService = QuranApiService(dio); // تمرير Dio إلى API Service
//   final repository = QuranRepository(apiService); // تمرير API Service إلى Repository

//   runApp(MyApp(repository: repository));
// }

// class MyApp extends StatelessWidget {
//   final QuranRepository repository;

//   const MyApp({super.key, required this.repository});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => TafsirCubit(repository),
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'تطبيق القرآن الكريم',
//         theme: ThemeData(
//           primarySwatch: Colors.green,
//           fontFamily: 'Tajawal',
//         ),
//         home: QuranScreen(),
//       ),
//     );
//   }
// }
