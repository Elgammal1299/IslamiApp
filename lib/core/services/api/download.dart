import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:islami_app/feature/home/data/model/hadith.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetData {
  static final String url =
      "https://raw.githubusercontent.com/Elgammal1299/hadith/refs/heads/main/abu-daud.json";

  static final Dio dio = Dio();

  static Future<List<HadithModel>> getData() async {
    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final data = response.data;
        // log("📂 Data fetched successfully from ==== $data");

        if (data is List) {
          return data.map((item) => HadithModel.fromMap(item)).toList();
        } else {
          log("❌ Unexpected JSON format");
          return [];
        }
      } else {
        log("❌ Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      log("❌ Error fetching data: $e");
      return [];
    }
  }
}

class GetHadithData {
  final String url =
      "https://raw.githubusercontent.com/Elgammal1299/hadith/refs/heads/main/abu-daud.json";
  final Dio dio = Dio();

  Future<List<HadithModel>> getDataAndStoreInHive() async {
    try {
      final response = await dio.get(url);
      final data = response.data as List;

      final List<HadithModel> hadithList =
          data.map((item) => HadithModel.fromMap(item)).toList();

      final box = await Hive.openBox<HadithModel>('hadithBox');
      // await box.clear(); // لو عاوز تحدث البيانات كل مرة
      await box.addAll(hadithList);
      return hadithList;
    } catch (error) {
      log('❌ Error fetching or storing data: $error');
      return [];
    }
  }
}
