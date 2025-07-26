import 'package:dartz/dartz.dart';
import 'package:islami_app/core/services/api/tafsir_service.dart';
import 'package:islami_app/feature/botton_nav_bar/data/repo/tafsir_repo.dart';
import 'package:islami_app/feature/home/data/model/tafsir_model.dart';
import 'package:islami_app/feature/home/data/model/tafsir_quran.dart';

class QuranWithTafsirRepo {
  final TafsirService apiService;

  QuranWithTafsirRepo(this.apiService);

  /// 🟢  جلب القرآن كاملًا مع تفسير معين
  Future<Either<String, TafsirQuran>> getQuranWithTafsir(
    String editionIdentifier,
  ) async {
    try {
      final response = await apiService.getQuranWithTafsir(editionIdentifier);
      return Right(response);
    } catch (e) {
      return Left(handleError(e));
    }
  }

  /// 🟢  جلب قائمة التفسيرات
  Future<Either<String, TafsirModel>> getTafsirEditions() async {
    try {
      final response = await apiService.getTafsirEditions();
      return Right(response);
    } catch (e) {
      return Left(handleError(e));
    }
  }
}
