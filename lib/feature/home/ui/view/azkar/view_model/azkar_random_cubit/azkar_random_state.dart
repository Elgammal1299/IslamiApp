part of 'azkar_random_cubit.dart';

sealed class AzkarRandomState {}

final class AzkarRandomInitial extends AzkarRandomState {}
class DikrLoading extends AzkarRandomState {}

class AzkarRandomLoaded extends AzkarRandomState {
  final AzkarRandomModel dikr;
  AzkarRandomLoaded(this.dikr);
}

class AzkarRandomError extends AzkarRandomState {
  final String message;
  AzkarRandomError(this.message);
}
