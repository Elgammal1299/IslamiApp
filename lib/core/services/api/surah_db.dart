import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:islami_app/core/constant/app_json.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/sura.dart';

class SurahJsonServer {
  // Function to read JSON data from assets
  Future<List<SurahModel>> readJson() async {
    //انا كده بقرأ الفايل
    final String jsonString = await rootBundle.loadString(AppJson.surahsJson);

    //كده انا بحول النص الى object
    final List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.map((json) => SurahModel.fromJson(json)).toList();
  }
}
