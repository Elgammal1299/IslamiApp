import 'package:dio/dio.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/tafsir_by_ayah.dart';
import 'package:islami_app/feature/home/data/model/tafsir_model.dart';
import 'package:islami_app/feature/home/data/model/tafsir_quran.dart';
import 'package:retrofit/retrofit.dart';

part 'tafsir_service.g.dart';

@RestApi(baseUrl: "http://api.alquran.cloud/v1")
abstract class TafsirService {
  factory TafsirService(Dio dio, {String baseUrl}) = _TafsirService;

  // // 1️⃣ الحصول على جميع الإصدارات المتاحة (نصوص وترجمات وتفسيرات وصوتيات)
  // @GET("/edition")
  // Future<HttpResponse<dynamic>> getEditions();

  // 2️⃣ الحصول على قائمة الإصدارات الخاصة بالتفسير فقط
  @GET("/edition/type/tafsir")
  Future<TafsirModel> getTafsirEditions();

  // 3️⃣ جلب تفسير آية معينة باستخدام `identifier`
  // زى كده ar.muyassar وده ممكن نجيبه من getTafsirEditions
  @GET("/ayah/{verseId}/{editionIdentifier}")
  Future<TafsirByAyah> getAyahTafsir(
    @Path("verseId") String verseId,
    @Path("editionIdentifier") String editionIdentifier,
  );

  // 4️⃣ جلب القرآن كاملًا مع تفسير معين
  @GET("/quran/{editionIdentifier}")
  Future<TafsirQuran> getQuranWithTafsir(
    @Path("editionIdentifier") String editionIdentifier,
  );
}
