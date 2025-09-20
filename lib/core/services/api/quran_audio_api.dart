import 'package:dio/dio.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/data/model/reciters_model.dart';
import 'package:retrofit/http.dart';

part 'quran_audio_api.g.dart';

@RestApi(baseUrl: "https://www.mp3quran.net/api/v3/")
abstract class QuranAudioService {
  factory QuranAudioService(Dio dio, {String baseUrl}) = _QuranAudioService;

  @GET("reciters?language=ar")
  Future<RecitersModel> fetchReciters();
}
