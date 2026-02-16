part of 'quran_audio_cubit.dart';

@immutable
sealed class QuranAudioState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class QuranAudioInitial extends QuranAudioState {}

// 🔄 حالات التحميل
class RecitersLoading extends QuranAudioState {}

class AyahAudioLoading extends QuranAudioState {}

class SurahAudioLoading extends QuranAudioState {}

// ✅ حالات النجاح
class RecitersLoaded extends QuranAudioState {
  final List<ReciterEdition> reciters;
  RecitersLoaded(this.reciters);

  @override
  List<Object?> get props => [reciters];
}

class AyahAudioLoaded extends QuranAudioState {
  final AyahAudioData ayahAudio;
  AyahAudioLoaded(this.ayahAudio);

  @override
  List<Object?> get props => [ayahAudio];
}

class SurahAudioLoaded extends QuranAudioState {
  final SurahAudioData surahAudio;
  SurahAudioLoaded(this.surahAudio);

  @override
  List<Object?> get props => [surahAudio];
}

// ❌ حالة الفشل
class QuranAudioError extends QuranAudioState {
  final String message;
  QuranAudioError(this.message);

  @override
  List<Object?> get props => [message];
}
