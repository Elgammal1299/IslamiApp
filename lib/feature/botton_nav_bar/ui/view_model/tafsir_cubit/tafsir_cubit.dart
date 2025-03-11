import 'package:bloc/bloc.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/tafsir_by_ayah.dart';
import 'package:islami_app/feature/home/data/model/tafsir_model.dart';
import 'package:islami_app/feature/home/data/model/tafsir_quran.dart';
import 'package:islami_app/feature/botton_nav_bar/data/repo/tafsir_repo.dart';
import 'package:meta/meta.dart';

part 'tafsir_state.dart';

class TafsirCubit extends Cubit<TafsirState> {
  final QuranRepository repository;
  TafsirCubit(this.repository) : super(TafsirInitial());

   /// 🟢 جلب قائمة التفسيرات
  Future<void> fetchTafsirEditions() async {
    emit(TafsirLoading());

    final result = await repository.getTafsirEditions();

    result.fold(
      (failure) => emit(TafsirError(failure)),
      (data) => emit(TafsirEditionsLoaded(data)),
    );
  }

   /// 🟢 جلب تفسير آية معينة
  Future<void> fetchAyahTafsir(String verseId, String editionIdentifier) async {
    emit(TafsirLoading());

    final result = await repository.getAyahTafsir(verseId, editionIdentifier);

    result.fold(
      (failure) => emit(TafsirError(failure)),
      (data) => emit(AyahTafsirLoaded(data)),
    );
  }

  /// 🟢 جلب القرآن كاملًا مع تفسير معين
  Future<void> fetchQuranWithTafsir(String editionIdentifier) async {
    emit(TafsirLoading());

    final result = await repository.getQuranWithTafsir(editionIdentifier);

    result.fold(
      (failure) => emit(TafsirError(failure)),
      (data) => emit(QuranWithTafsirLoaded(data)),
    );
  }
}
