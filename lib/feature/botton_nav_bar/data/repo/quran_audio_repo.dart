import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:islami_app/core/services/api/alquran_cloud_service.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/ayah_audio.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/reciter_edition.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/surah_audio.dart';

class QuranAudioRepository {
  final AlQuranCloudService apiService;

  QuranAudioRepository(this.apiService);

  /// 🎙️ جلب قائمة القراء المتاحين
  Future<Either<String, ReciterEditionResponse>> getAudioReciters() async {
    try {
      final response = await apiService.fetchAudioReciters();
      return Right(response);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  /// 🎵 جلب آية واحدة مع الصوت
  Future<Either<String, AyahAudioResponse>> getAyahAudio(
    int ayahNumber,
    String identifier,
  ) async {
    try {
      final response = await apiService.fetchAyahAudio(ayahNumber, identifier);
      return Right(response);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  /// 📖 جلب سورة كاملة مع الصوت
  Future<Either<String, SurahAudioResponse>> getSurahAudio(
    int surahNumber,
    String identifier,
  ) async {
    try {
      final response = await apiService.fetchSurahAudio(
        surahNumber,
        identifier,
      );
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
