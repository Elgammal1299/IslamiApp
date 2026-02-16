import 'package:dio/dio.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/ayah_audio.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/reciter_edition.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/surah_audio.dart';
import 'package:retrofit/http.dart';

part 'alquran_cloud_service.g.dart';

@RestApi(baseUrl: "https://api.alquran.cloud/v1")
abstract class AlQuranCloudService {
  factory AlQuranCloudService(Dio dio, {String baseUrl}) = _AlQuranCloudService;

  /// 🎙️ جلب قائمة القراء المتاحين
  @GET("/edition?format=audio&language=ar")
  Future<ReciterEditionResponse> fetchAudioReciters();

  /// 🎵 جلب آية واحدة مع الصوت بقارئ معين
  @GET("/ayah/{ayahNumber}/{identifier}")
  Future<AyahAudioResponse> fetchAyahAudio(
    @Path("ayahNumber") int ayahNumber,
    @Path("identifier") String identifier,
  );

  /// 📖 جلب سورة كاملة مع الصوت بقارئ معين
  @GET("/surah/{surahNumber}/{identifier}")
  Future<SurahAudioResponse> fetchSurahAudio(
    @Path("surahNumber") int surahNumber,
    @Path("identifier") String identifier,
  );
}
