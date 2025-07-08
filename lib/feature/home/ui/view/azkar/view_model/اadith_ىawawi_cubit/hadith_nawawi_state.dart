part of 'hadith_nawawi_cubit.dart';

sealed class HadithNawawiState {}

final class HadithNawawiInitial extends HadithNawawiState {}
class HadithNawawiLoading extends HadithNawawiState {}

class HadithNawawiLoaded extends HadithNawawiState {
  final List<HadithNawawiModel> hadiths;

  HadithNawawiLoaded(this.hadiths);
}

class HadithNawawiError extends HadithNawawiState {
  final String message;

  HadithNawawiError(this.message);
}