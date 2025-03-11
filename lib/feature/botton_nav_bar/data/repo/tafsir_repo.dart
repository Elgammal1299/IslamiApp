import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:islami_app/core/services/api/tafsir_service.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/tafsir_by_ayah.dart';
import 'package:islami_app/feature/home/data/model/tafsir_model.dart';
import 'package:islami_app/feature/home/data/model/tafsir_quran.dart';

class QuranRepository {
  final TafsirService apiService;

  QuranRepository(this.apiService);

  /// 🟢 1️⃣ جلب قائمة التفسيرات
  Future<Either<String, TafsirModel>> getTafsirEditions() async {
    try {
      final response = await apiService.getTafsirEditions();
      return Right(response);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  /// 🟢 2️⃣ جلب تفسير آية معينة
  Future<Either<String, TafsirByAyah>> getAyahTafsir(String verseId, String editionIdentifier) async {
    try {
      final response = await apiService.getAyahTafsir(verseId, editionIdentifier);
      return Right(response);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  /// 🟢 3️⃣ جلب القرآن كاملًا مع تفسير معين
  Future<Either<String, TafsirQuran>> getQuranWithTafsir(String editionIdentifier) async {
    try {
      final response = await apiService.getQuranWithTafsir(editionIdentifier);
      return Right(response);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  /// 🛑 دالة خاصة للتعامل مع الأخطاء
  String _handleError(dynamic error) {
    if (error is DioException) {
      return "❌ خطأ في الاتصال: ${error.message}";
    } else {
      return "❌ خطأ غير متوقع: $error";
    }
  }
}
