import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:islami_app/feature/home/ui/view/azkar/data/model/azkar_random_model.dart';

class AzkarRandomRepo {
  Future<List<AzkarRandomModel>> loadAdhkarFromAssets() async {
    final String jsonStr = await rootBundle.loadString(
      'assets/json/tsabih.json',
    );
    final List<dynamic> jsonList = json.decode(jsonStr);
    return jsonList.map((e) => AzkarRandomModel.fromJson(e)).toList();
  }
}
