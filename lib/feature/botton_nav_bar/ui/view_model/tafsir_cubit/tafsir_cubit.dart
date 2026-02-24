import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/tafsir_by_ayah.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/tafsir_page_model.dart';
import 'package:islami_app/feature/botton_nav_bar/data/repo/tafsir_repo.dart';

part 'tafsir_state.dart';

/// Model مبسط لبيانات التفسير (identifier + اسم عربي)
class TafsirEditionData extends Equatable {
  final String identifier;
  final String name;
  final String englishName;

  const TafsirEditionData({
    required this.identifier,
    required this.name,
    required this.englishName,
  });

  @override
  List<Object?> get props => [identifier, name, englishName];
}

class TafsirCubit extends Cubit<TafsirByAyahState> {
  final TafsirByAyahRepository repository;
  TafsirCubit(this.repository) : super(TafsirInitial());

  /// 🟢 جلب قائمة جميع التفاسير المتاحة
  Future<void> fetchTafsirEditions() async {
    if (!isClosed) emit(TafsirEditionsLoading());

    final result = await repository.getTafsirEditions();
    if (isClosed) return;

    result.fold(
      (failure) {
        if (!isClosed) emit(TafsirEditionsError(failure));
      },
      (data) {
        final editions =
            (data.data ?? [])
                .where((e) => e.identifier != null && e.name != null)
                .map(
                  (e) => TafsirEditionData(
                    identifier: e.identifier!,
                    name: e.name!,
                    englishName: e.englishName ?? e.identifier!,
                  ),
                )
                .toList();

        if (!isClosed) emit(TafsirEditionsLoaded(editions));
      },
    );
  }

  /// 🟢 جلب تفاسير صفحة كاملة
  Future<void> fetchPageTafsir(
    String pageNumber,
    String editionIdentifier,
  ) async {
    if (!isClosed) emit(TafsirPageLoading());

    final result = await repository.getTafsirPage(
      pageNumber,
      editionIdentifier,
    );
    if (isClosed) return;

    result.fold(
      (failure) {
        if (!isClosed) emit(TafsirPageError(failure));
      },
      (data) {
        final ayahs = data.data?.ayahs ?? [];
        if (!isClosed) emit(TafsirPageLoaded(ayahs));
      },
    );
  }

  /// 🟢 جلب تفسير آية معينة (محتفظ بها للتوافق)
  Future<void> fetchAyahTafsir(String verseId, String editionIdentifier) async {
    if (!isClosed) emit(TafsirByAyahLoading());

    final result = await repository.getAyahTafsir(verseId, editionIdentifier);
    if (isClosed) return;

    result.fold(
      (failure) {
        if (!isClosed) emit(TafsirByAyahError(failure));
      },
      (data) {
        if (!isClosed) emit(TafsirByAyahLoaded(data));
      },
    );
  }
}
