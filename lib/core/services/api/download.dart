import 'dart:convert';
import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:islami_app/feature/home/data/model/hadith.dart';
import 'package:dio/dio.dart';

class GetData {
  final String endpoint;

  static final Dio dio = Dio();

  GetData(this.endpoint);

  static Future<List<HadithModel>> getData({required String endpoint}) async {
    final String url =
        "https://raw.githubusercontent.com/Elgammal1299/hadith/refs/heads/main/$endpoint.json";

    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.data);

        if (data is List) {
          log("📂 Data fetched successfully from $url");
          return data.map((item) => HadithModel.fromMap(item)).toList();
        } else {
          log("❌ Unexpected JSON format: not a List");
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

      log("📂 Data fetched successfully from ==== ");
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
