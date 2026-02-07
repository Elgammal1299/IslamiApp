import 'package:flutter_bloc/flutter_bloc.dart';

class VerseSelectionCubit extends Cubit<String?> {
  VerseSelectionCubit() : super(null);

  void selectVerse(int surah, int verse) {
    final verseId = "$surah:$verse";
    if (state == verseId) {
      emit(null);
    } else {
      emit(verseId);
    }
  }

  void clearSelection() {
    emit(null);
  }

  bool isSelected(int surah, int verse) {
    return state == "$surah:$verse";
  }
}
