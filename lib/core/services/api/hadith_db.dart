import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/hadith.dart';

class HadithJsonServer {
  Future<List<HadithModel>> readJsonAbuDaud() async {
    //انا كده بقرأ الفايل
    final String jsonString = await rootBundle.loadString(
      "assets/json/abu-daud.json",
    );

    //كده انا بحول النص الى object
    final List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.map((json) => HadithModel.fromMap(json)).toList();
  }

  Future<List<HadithModel>> readJsonAhmed() async {
    //انا كده بقرأ الفايل
    final String jsonString = await rootBundle.loadString(
      "assets/json/ahmad.json",
    );

    //كده انا بحول النص الى object
    final List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.map((json) => HadithModel.fromMap(json)).toList();
  }

  Future<List<HadithModel>> readJsonBukhari() async {
    //انا كده بقرأ الفايل
    final String jsonString = await rootBundle.loadString(
      "assets/json/bukhari.json",
    );

    //كده انا بحول النص الى object
    final List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.map((json) => HadithModel.fromMap(json)).toList();
  }

  Future<List<HadithModel>> readJsonDarimi() async {
    //انا كده بقرأ الفايل
    final String jsonString = await rootBundle.loadString(
      "assets/json/darimi.json",
    );

    //كده انا بحول النص الى object
    final List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.map((json) => HadithModel.fromMap(json)).toList();
  }

  Future<List<HadithModel>> readJsonIbnuMajah() async {
    //انا كده بقرأ الفايل
    final String jsonString = await rootBundle.loadString(
      "assets/json/ibnu-majah.json",
    );

    //كده انا بحول النص الى object
    final List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.map((json) => HadithModel.fromMap(json)).toList();
  }

  Future<List<HadithModel>> readJsonMalik() async {
    //انا كده بقرأ الفايل
    final String jsonString = await rootBundle.loadString(
      "assets/json/malik.json",
    );

    //كده انا بحول النص الى object
    final List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.map((json) => HadithModel.fromMap(json)).toList();
  }

  Future<List<HadithModel>> readJsonMuslim() async {
    //انا كده بقرأ الفايل
    final String jsonString = await rootBundle.loadString(
      "assets/json/muslim.json",
    );

    //كده انا بحول النص الى object
    final List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.map((json) => HadithModel.fromMap(json)).toList();
  }

  Future<List<HadithModel>> readJsonNasai() async {
    //انا كده بقرأ الفايل
    final String jsonString = await rootBundle.loadString(
      "assets/json/nasai.json",
    );

    //كده انا بحول النص الى object
    final List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.map((json) => HadithModel.fromMap(json)).toList();
  }

  Future<List<HadithModel>> readJsonTirmidzi() async {
    //انا كده بقرأ الفايل
    final String jsonString = await rootBundle.loadString(
      "assets/json/tirmidzi.json",
    );

    //كده انا بحول النص الى object
    final List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.map((json) => HadithModel.fromMap(json)).toList();
  }
}
