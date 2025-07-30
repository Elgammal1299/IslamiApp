part of 'hadith_nawawi_cubit.dart';

sealed class HadithNawawiState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class HadithNawawiInitial extends HadithNawawiState {}

class HadithNawawiLoading extends HadithNawawiState {}

class HadithNawawiLoaded extends HadithNawawiState {
  final List<HadithNawawiModel> hadiths;

  HadithNawawiLoaded(this.hadiths);
  @override
  List<Object?> get props => [hadiths];
}

class HadithNawawiError extends HadithNawawiState {
  final String message;

  HadithNawawiError(this.message);
  @override
  List<Object?> get props => [message];
}
