import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/ayah_audio.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/reciter_edition.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/surah_audio.dart';
import 'package:islami_app/feature/botton_nav_bar/data/repo/quran_audio_repo.dart';

part 'quran_audio_state.dart';

class QuranAudioCubit extends Cubit<QuranAudioState> {
  final QuranAudioRepository repository;

  QuranAudioCubit(this.repository) : super(QuranAudioInitial());

  /// 🎙️ جلب قائمة القراء
  Future<void> fetchReciters() async {
    if (!isClosed) emit(RecitersLoading());

    final result = await repository.getAudioReciters();
    if (isClosed) return;

    result.fold(
      (failure) {
        if (!isClosed) emit(QuranAudioError(failure));
      },
      (data) {
        if (!isClosed) emit(RecitersLoaded(data.data));
      },
    );
  }

  /// 🎵 جلب آية واحدة مع الصوت
  Future<void> fetchAyahAudio(int ayahNumber, String identifier) async {
    if (!isClosed) emit(AyahAudioLoading());

    final result = await repository.getAyahAudio(ayahNumber, identifier);
    if (isClosed) return;

    result.fold(
      (failure) {
        if (!isClosed) emit(QuranAudioError(failure));
      },
      (data) {
        if (!isClosed) emit(AyahAudioLoaded(data.data));
      },
    );
  }

  /// 📖 جلب سورة كاملة مع الصوت
  Future<void> fetchSurahAudio(int surahNumber, String identifier) async {
    if (!isClosed) emit(SurahAudioLoading());

    final result = await repository.getSurahAudio(surahNumber, identifier);
    if (isClosed) return;

    result.fold(
      (failure) {
        if (!isClosed) emit(QuranAudioError(failure));
      },
      (data) {
        if (!isClosed) emit(SurahAudioLoaded(data.data));
      },
    );
  }
}
