part of 'surah_cubit.dart';

sealed class SurahState {}

final class SurahInitial extends SurahState {}

final class SurahLoading extends SurahState {}

final class SurahSuccess extends SurahState {
  final List<SurahModel> surahs;

  SurahSuccess(this.surahs);
}

final class SurahError extends SurahState {
  final String message;

  SurahError(this.message);
}
