import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:islami_app/core/constant/app_json.dart';
import 'package:islami_app/feature/home/ui/view/azkar/data/model/azkar_yawmi_model.dart';

class AzkarYawmiRepo {
  Future<List<AzkarCategoryModel>> loadSupplications() async {
    final jsonString = await rootBundle.loadString(AppJson.azkarYawmiJson);
    final List<dynamic> data = json.decode(jsonString);

    return data
        .map((e) => AzkarCategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
