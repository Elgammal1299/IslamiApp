// lib/feature/radio/data/repo/radio_repository.dart
import 'package:islami_app/core/services/radio_service.dart';

import '../model/radio_model.dart';

class RadioRepository {
  final RadioService radioService;

  RadioRepository(this.radioService);

  Future<List<RadioModel>> getRadioStations({String language = 'ar'}) async {
    try {
      final response = await radioService.getRadioStations(language: language);
      final List<dynamic> radios = response.data['radios'];
      return radios.map((radio) => RadioModel.fromJson(radio)).toList();
    } catch (e) {
      throw Exception('Failed to load radio stations');
    }
  }
}
