import 'package:dio/dio.dart';
import 'package:islami_app/feature/home/data/model/quran_audio_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'quran_audio_api.g.dart';

@RestApi(baseUrl: "https://www.mp3quran.net/api/v3/")
abstract class QuranAudioService {
  factory QuranAudioService(Dio dio, {String baseUrl}) = _ApiService;

  @GET("reciters?language=ar")
  Future<QuranAudioModel> fetchReciters();
}