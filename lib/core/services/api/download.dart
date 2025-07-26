import 'dart:convert';
import 'dart:developer';
import 'package:islami_app/feature/home/data/model/hadith.dart';
import 'package:dio/dio.dart';

class HadithService {
  static final Dio _dio = Dio();
  static const String _baseUrl =
      'https://raw.githubusercontent.com/Elgammal1299/hadith/refs/heads/main/';

  static Future<List<HadithModel>> fetchHadiths(String endpoint) async {
    final String url = '$_baseUrl$endpoint.json';

    try {
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.data);

        if (decoded is List) {
          log("📂 Data fetched successfully from $url");
          return decoded.map((item) => HadithModel.fromMap(item)).toList();
        } else {
          log(
            "❌ Unexpected format: Expected List but got ${decoded.runtimeType}",
          );
        }
      } else {
        log("❌ Request failed: Status code ${response.statusCode}");
      }
    } catch (e, stack) {
      log("❌ Exception during fetch: $e", stackTrace: stack);
    }

    return [];
  }
}

// class GetHadithData {
//   final String url =
//       "https://raw.githubusercontent.com/Elgammal1299/hadith/refs/heads/main/abu-daud.json";
//   final Dio dio = Dio();

//   Future<List<HadithModel>> getDataAndStoreInHive() async {
//     try {
//       final response = await dio.get(url);
//       final data = response.data as List;

//       log("📂 Data fetched successfully from ==== ");
//       final List<HadithModel> hadithList =
//           data.map((item) => HadithModel.fromMap(item)).toList();

//       final box = await Hive.openBox<HadithModel>('hadithBox');
//       // await box.clear(); // لو عاوز تحدث البيانات كل مرة
//       await box.addAll(hadithList);
//       return hadithList;
//     } catch (error) {
//       log('❌ Error fetching or storing data: $error');
//       return [];
//     }
//   }
// }
