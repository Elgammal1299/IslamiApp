import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:islami_app/core/services/api/tafsir_service.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/tafsir_by_ayah.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/tafsir_page_model.dart';
import 'package:islami_app/feature/home/data/model/tafsir_model.dart';

class TafsirByAyahRepository {
  final TafsirService apiService;

  TafsirByAyahRepository(this.apiService);

  /// 🟢 جلب قائمة جميع التفاسير المتاحة
  Future<Either<String, TafsirModel>> getTafsirEditions() async {
    try {
      final response = await apiService.getTafsirEditions();
      return Right(response);
    } catch (e) {
      return Left(handleError(e));
    }
  }

  /// 🟢 جلب تفاسير صفحة كاملة
  Future<Either<String, TafsirPageModel>> getTafsirPage(
    String pageNumber,
    String editionIdentifier,
  ) async {
    try {
      final response = await apiService.getPageTafsir(
        pageNumber,
        editionIdentifier,
      );
      return Right(response);
    } catch (e) {
      return Left(handleError(e));
    }
  }

  /// 🟢 جلب تفسير آية معينة
  Future<Either<String, TafsirByAyah>> getAyahTafsir(
    String verseId,
    String editionIdentifier,
  ) async {
    try {
      final response = await apiService.getAyahTafsir(
        verseId,
        editionIdentifier,
      );
      return Right(response);
    } catch (e) {
      return Left(handleError(e));
    }
  }
}

/// 🛑 دالة خاصة للتعامل مع الأخطاء
String handleError(dynamic error) {
  if (error is DioException) {
    return "❌ خطأ في الاتصال: ${error.message}";
  } else {
    return "❌ خطأ غير متوقع: $error";
  }
}
