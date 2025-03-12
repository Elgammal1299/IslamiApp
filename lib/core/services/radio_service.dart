// lib/core/services/api/radio_service.dart
import 'package:dio/dio.dart';

class RadioService {
  final Dio dio;

  RadioService(this.dio);

  Future<Response> getRadioStations({String language = 'ar'}) async {
    try {
      final response = await dio.get(
        'https://mp3quran.net/api/v3/radios',
        queryParameters: {'language': language},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
