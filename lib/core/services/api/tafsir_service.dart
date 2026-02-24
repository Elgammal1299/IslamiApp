import 'package:dio/dio.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/tafsir_by_ayah.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/tafsir_page_model.dart';
import 'package:islami_app/feature/home/data/model/tafsir_model.dart';
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

  // // 4️⃣ جلب القرآن كاملًا مع تفسير معين
  // @GET("/quran/{editionIdentifier}")
  // Future<TafsirQuran> getQuranWithTafsir(
  //   @Path("editionIdentifier") String editionIdentifier,
  // );
}

/// Extension يضيف دالة جلب تفاسير صفحة كاملة يدوياً (بدون retrofit code generation)
/// GET /page/{pageNumber}/{editionIdentifier}
extension TafsirServiceExtension on TafsirService {
  Future<TafsirPageModel> getPageTafsir(
    String pageNumber,
    String editionIdentifier,
  ) async {
    // نحتاج الـ Dio — نستخدمه من خلال helper static
    final dio = Dio();
    dio.options.baseUrl = 'http://api.alquran.cloud/v1';
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);

    final response = await dio.get<Map<String, dynamic>>(
      '/page/$pageNumber/$editionIdentifier',
    );
    return TafsirPageModel.fromJson(response.data!);
  }
}
