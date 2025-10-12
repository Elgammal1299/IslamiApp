import 'dart:convert';
import 'dart:developer';
import 'package:islami_app/core/services/setup_service_locator.dart';
import 'package:islami_app/feature/home/data/model/hadith_model.dart';
import 'package:dio/dio.dart';

class HadithService {
  static const String _baseUrl =
      "https://raw.githubusercontent.com/Elgammal1299/hadith/main/";

  static Future<List<HadithModel>> fetchHadith(String endpoint) async {
    final String url = '$_baseUrl$endpoint.json';
    try {
      final response = await sl<Dio>().get(url);
      if (response.statusCode == 200) {
        final decoded = json.decode(response.data);

        if (decoded is List) {
          return decoded.map((item) => HadithModel.fromJson(item)).toList();
        } else {}
      } else {}
    } catch (e, stack) {
      log("❌ Exception during fetch: $e", stackTrace: stack);
    }

    return [];
  }
}
