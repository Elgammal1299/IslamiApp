part of 'reciter_cubit.dart';

sealed class ReciterState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class ReciterInitial extends ReciterState {}

class ReciterLoading extends ReciterState {}

class ReciterLoaded extends ReciterState {
  final List<Reciters> reciters;
  ReciterLoaded(this.reciters);
  @override
  List<Object?> get props => [reciters];
}

class ReciterError extends ReciterState {
  final String message;
  ReciterError(this.message);
  @override
  List<Object?> get props => [message];
}
