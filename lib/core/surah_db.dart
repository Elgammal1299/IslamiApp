import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:islami_app/feature/home/data/model/sura.dart';

class SurahJsonServer {
  // Function to read JSON data from assets
  Future<List<SurahModel>> readJson() async {
    //انا كده بقرأ الفايل
    final String jsonString = await rootBundle.loadString("assets/json/surahs.json");

    //كده انا بحول النص الى object
    final List< dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.map((json) => SurahModel.fromJson(json)).toList();
  }
}
