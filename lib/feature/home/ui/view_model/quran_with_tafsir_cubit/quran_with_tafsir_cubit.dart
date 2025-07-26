import 'package:bloc/bloc.dart';
import 'package:islami_app/feature/home/data/model/tafsir_model.dart';
import 'package:islami_app/feature/home/data/model/tafsir_quran.dart';
import 'package:islami_app/feature/home/data/repo/quran_with_tafsir.dart';
import 'package:meta/meta.dart';

part 'quran_with_tafsir_state.dart';

class QuranWithTafsirCubit extends Cubit<QuranWithTafsirState> {
  final QuranWithTafsirRepo repository;

  QuranWithTafsirCubit(this.repository) : super(QuranWithTafsirInitial());

  /// 🟢 جلب قائمة التفسيرات
  Future<void> fetchTafsirEditions() async {
    emit(QuranWithTafsirLoading());

    final result = await repository.getTafsirEditions();

    result.fold(
      (failure) => emit(QuranWithTafsirError(failure)),
      (data) => emit(TafsirEditionsLoaded(data)),
    );
  }

  /// 🟢 جلب القرآن كاملًا مع تفسير معين
  Future<void> fetchQuranWithTafsir(String editionIdentifier) async {
    emit(QuranWithTafsirLoading());

    final result = await repository.getQuranWithTafsir(editionIdentifier);

    result.fold(
      (failure) => emit(QuranWithTafsirError(failure)),
      (data) => emit(QuranWithTafsirLoaded(data)),
    );
  }
}
