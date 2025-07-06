part of 'azkar_cubit.dart';

sealed class AzkarState {}

final class AzkarInitial extends AzkarState {}

class AzkarLoading extends AzkarState {}

class AzkarLoaded extends AzkarState {
  final List<SectionModel> sections;
  AzkarLoaded(this.sections);
}

class AzkarError extends AzkarState {
  final String message;
  AzkarError(this.message);
}
