part of 'hadith_cubit.dart';

sealed class HadithState {}

final class HadithInitial extends HadithState {}

final class HadithLoading extends HadithState {}

final class HadithSuccess extends HadithState {
  final List<HadithModel> hadiths;

  HadithSuccess(this.hadiths);
}

final class HadithError extends HadithState {
  final String message;

  HadithError(this.message);
}
