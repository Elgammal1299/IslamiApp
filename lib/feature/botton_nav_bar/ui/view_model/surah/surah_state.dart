part of 'surah_cubit.dart';

sealed class SurahState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class SurahInitial extends SurahState {}

final class SurahLoading extends SurahState {}

final class SurahSuccess extends SurahState {
  final List<SurahModel> surahs;

  SurahSuccess(this.surahs);
  @override
  List<Object?> get props => [surahs];
}

final class SurahError extends SurahState {
  final String message;

  SurahError(this.message);
  @override
  List<Object?> get props => [message];
}
