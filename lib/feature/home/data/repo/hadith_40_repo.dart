import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:islami_app/feature/home/data/model/hadith_40_model.dart';

class Hadith40Repo {
  Future<List<Hadith40Model>> getHadith40() async {
    final String response = await rootBundle.loadString(
      'assets/json/40-hadith-nawawi.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Hadith40Model.fromJson(json)).toList();
  }
}
