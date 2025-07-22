part of 'hadith_cubit.dart';

sealed class HadithState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class HadithInitial extends HadithState {}

final class HadithLoading extends HadithState {}

final class HadithSuccess extends HadithState {
  final List<HadithModel> hadiths;

  HadithSuccess(this.hadiths);
  @override
  List<Object?> get props => [hadiths];
}

final class HadithError extends HadithState {
  final String message;

  HadithError(this.message);
  @override
  List<Object?> get props => [message];
}
