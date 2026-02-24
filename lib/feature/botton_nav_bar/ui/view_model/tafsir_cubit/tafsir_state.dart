part of 'tafsir_cubit.dart';

@immutable
sealed class TafsirByAyahState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class TafsirInitial extends TafsirByAyahState {}

// ===== States قائمة التفاسير المتاحة =====

class TafsirEditionsLoading extends TafsirByAyahState {}

class TafsirEditionsLoaded extends TafsirByAyahState {
  final List<TafsirEditionData> editions;
  TafsirEditionsLoaded(this.editions);
  @override
  List<Object?> get props => [editions];
}

class TafsirEditionsError extends TafsirByAyahState {
  final String message;
  TafsirEditionsError(this.message);
  @override
  List<Object?> get props => [message];
}

// ===== States تفسير صفحة كاملة =====

class TafsirPageLoading extends TafsirByAyahState {}

class TafsirPageLoaded extends TafsirByAyahState {
  final List<TafsirAyahItem> ayahs;
  TafsirPageLoaded(this.ayahs);
  @override
  List<Object?> get props => [ayahs];
}

class TafsirPageError extends TafsirByAyahState {
  final String message;
  TafsirPageError(this.message);
  @override
  List<Object?> get props => [message];
}

// ===== States تفسير آية منفردة (محتفظ بيها للتوافق) =====

class TafsirByAyahLoading extends TafsirByAyahState {}

class TafsirByAyahLoaded extends TafsirByAyahState {
  final TafsirByAyah tafsirByAyah;
  TafsirByAyahLoaded(this.tafsirByAyah);
  @override
  List<Object?> get props => [tafsirByAyah];
}

class TafsirByAyahError extends TafsirByAyahState {
  final String message;
  TafsirByAyahError(this.message);
  @override
  List<Object?> get props => [message];
}
