
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/tafsir_by_ayah.dart';
import 'package:islami_app/feature/botton_nav_bar/data/repo/tafsir_repo.dart';


part 'tafsir_state.dart';

class TafsirCubit extends Cubit<TafsirByAyahState> {
  final TafsirByAyahRepository repository;
  TafsirCubit(this.repository) : super(TafsirInitial());

  /// 🟢 جلب تفسير آية معينة
  Future<void> fetchAyahTafsir(String verseId, String editionIdentifier) async {
    emit(TafsirByAyahLoading());

    final result = await repository.getAyahTafsir(verseId, editionIdentifier);

    result.fold(
      (failure) => emit(TafsirByAyahError(failure)),
      (data) => emit(TafsirByAyahLoaded(data)),
    );
  }
}
