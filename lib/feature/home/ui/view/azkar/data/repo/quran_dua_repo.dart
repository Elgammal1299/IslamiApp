import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:islami_app/core/constant/app_json.dart';
import 'package:islami_app/feature/home/ui/view/azkar/data/model/quran_dua_model.dart';

class QuranDuaRepository {
  Future<List<QuranDuaModel>> loadDuases() async {
    final jsonString =
        await rootBundle.loadString(AppJson.quranVersesJson);

    final List data = json.decode(jsonString);

    return data.map((e) => QuranDuaModel.fromJson(e)).toList();
  }
}
