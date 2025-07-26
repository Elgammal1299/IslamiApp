// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter/services.dart';
// import 'package:islami_app/core/constant/app_json.dart';
// import 'package:islami_app/feature/home/data/model/hadith.dart';

// class HadithJsonServer {
//   Future<List<HadithModel>> readJsonAbuDaud() async {
//     //انا كده بقرأ الفايل
//     final String jsonString = await rootBundle.loadString(AppJson.abuDaudJson);

//     //كده انا بحول النص الى object
//     final List<dynamic> jsonResponse = json.decode(jsonString);
//     return jsonResponse.map((json) => HadithModel.fromJson(json)).toList();
//   }

//   Future<List<HadithModel>> readJsonAhmed() async {
//     //انا كده بقرأ الفايل
//     final String jsonString = await rootBundle.loadString(AppJson.ahmadJson);

//     //كده انا بحول النص الى object
//     final List<dynamic> jsonResponse = json.decode(jsonString);
//     return jsonResponse.map((json) => HadithModel.fromJson(json)).toList();
//   }

//   Future<List<HadithModel>> readJsonBukhari() async {
//     //انا كده بقرأ الفايل
//     final String jsonString = await rootBundle.loadString(AppJson.bukhariJson);

//     //كده انا بحول النص الى object
//     final List<dynamic> jsonResponse = json.decode(jsonString);
//     return jsonResponse.map((json) => HadithModel.fromMap(json)).toList();
//   }

//   Future<List<HadithModel>> readJsonDarimi() async {
//     //انا كده بقرأ الفايل
//     final String jsonString = await rootBundle.loadString(AppJson.darimiJson);

//     //كده انا بحول النص الى object
//     final List<dynamic> jsonResponse = json.decode(jsonString);
//     return jsonResponse.map((json) => HadithModel.fromMap(json)).toList();
//   }

//   Future<List<HadithModel>> readJsonIbnuMajah() async {
//     //انا كده بقرأ الفايل
//     final String jsonString = await rootBundle.loadString(
//       AppJson.ibnuMajahJson,
//     );

//     //كده انا بحول النص الى object
//     final List<dynamic> jsonResponse = json.decode(jsonString);
//     return jsonResponse.map((json) => HadithModel.fromMap(json)).toList();
//   }

//   Future<List<HadithModel>> readJsonMalik() async {
//     //انا كده بقرأ الفايل
//     final String jsonString = await rootBundle.loadString(AppJson.malikJson);

//     //كده انا بحول النص الى object
//     final List<dynamic> jsonResponse = json.decode(jsonString);
//     return jsonResponse.map((json) => HadithModel.fromMap(json)).toList();
//   }

//   Future<List<HadithModel>> readJsonMuslim() async {
//     //انا كده بقرأ الفايل
//     final String jsonString = await rootBundle.loadString(AppJson.muslimJson);

//     //كده انا بحول النص الى object
//     final List<dynamic> jsonResponse = json.decode(jsonString);
//     return jsonResponse.map((json) => HadithModel.fromMap(json)).toList();
//   }

//   Future<List<HadithModel>> readJsonNasai() async {
//     //انا كده بقرأ الفايل
//     final String jsonString = await rootBundle.loadString(AppJson.nasaiJson);

//     //كده انا بحول النص الى object
//     final List<dynamic> jsonResponse = json.decode(jsonString);
//     return jsonResponse.map((json) => HadithModel.fromMap(json)).toList();
//   }

//   Future<List<HadithModel>> readJsonTirmidzi() async {
//     //انا كده بقرأ الفايل
//     final String jsonString = await rootBundle.loadString(AppJson.tirmidziJson);

//     //كده انا بحول النص الى object
//     final List<dynamic> jsonResponse = json.decode(jsonString);
//     return jsonResponse.map((json) => HadithModel.fromMap(json)).toList();
//   }

//   Future<List<HadithModel>?> readJsonFromFullPath(String fullPath) async {
//     try {
//       final file = File(fullPath);

//       if (await file.exists()) {
//         final contents = await file.readAsString();
//         final List<dynamic> data = jsonDecode(contents);

//         log("✅ تم قراءة الملف من: $fullPath");
//         log('message${data.toString()}');
//         return data.map((e) => HadithModel.fromMap(e)).toList();
//       } else {
//         log('❌ الملف غير موجود: $fullPath');
//       }
//     } catch (e) {
//       log('❌ خطأ في قراءة الملف: $e');
//     }
//     return null;
//   }
// }
