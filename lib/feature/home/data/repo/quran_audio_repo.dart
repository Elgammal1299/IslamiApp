
import 'package:dartz/dartz.dart';
import 'package:islami_app/core/services/api/quran_audio_api.dart';
import 'package:islami_app/feature/home/data/model/quran_audio_model.dart';

class ReciterRepository {
  final QuranAudioService apiService;

  ReciterRepository(this.apiService);

  Future<Either<String, List<Reciters>>> getReciters() async {
    try {
      final response = await apiService.fetchReciters();
      return Right(response.reciters ?? []);
    } catch (e) {
      return Left("Failed to fetch reciters");
    }
  }
}