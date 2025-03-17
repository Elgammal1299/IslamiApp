part of 'reciter_cubit.dart';

@immutable
sealed class ReciterState {}

final class ReciterInitial extends ReciterState {}
class ReciterLoading extends ReciterState {}
class ReciterLoaded extends ReciterState {
  final List<Reciters> reciters;
  ReciterLoaded(this.reciters);
}
class ReciterError extends ReciterState {
  final String message;
  ReciterError(this.message);
}