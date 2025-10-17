// import 'dart:convert';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:islami_app/core/constant/app_json.dart';
// import 'package:islami_app/feature/home/ui/view/azkar/data/model/hadith_nawawi_model.dart';

// class HadithNawawiRepo {
//   Future<List<HadithNawawiModel>> fetchNawawiHadiths() async {
//     final data = await rootBundle.loadString(AppJson.hadithNawawiJson);
//     final decoded = jsonDecode(data) as List;
//     return decoded.map((e) => HadithNawawiModel.fromJson(e)).toList();
//   }
// }
