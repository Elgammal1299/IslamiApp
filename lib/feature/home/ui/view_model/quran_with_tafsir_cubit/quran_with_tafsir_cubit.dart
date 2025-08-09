import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/feature/home/data/model/tafsir_model.dart';
import 'package:islami_app/feature/home/data/model/tafsir_quran.dart';
import 'package:islami_app/feature/home/data/repo/quran_with_tafsir.dart';

part 'quran_with_tafsir_state.dart';

class QuranWithTafsirCubit extends Cubit<QuranWithTafsirState> {
  final QuranWithTafsirRepo repository;

  QuranWithTafsirCubit(this.repository) : super(QuranWithTafsirInitial());

  /// 🟢 جلب قائمة التفسيرات
  Future<void> fetchTafsirEditions() async {
    if (!isClosed) emit(QuranWithTafsirLoading());

    final result = await repository.getTafsirEditions();
    if (isClosed) return;

    result.fold(
      (failure) {
        if (!isClosed) emit(QuranWithTafsirError(failure));
      },
      (data) {
        if (!isClosed) emit(TafsirEditionsLoaded(data));
      },
    );
  }

  /// 🟢 جلب القرآن كاملًا مع تفسير معين
  Future<void> fetchQuranWithTafsir(String editionIdentifier) async {
    if (!isClosed) emit(QuranWithTafsirLoading());

    final result = await repository.getQuranWithTafsir(editionIdentifier);
    if (isClosed) return;

    result.fold(
      (failure) {
        if (!isClosed) emit(QuranWithTafsirError(failure));
      },
      (data) {
        if (!isClosed) emit(QuranWithTafsirLoaded(data));
      },
    );
  }
}
