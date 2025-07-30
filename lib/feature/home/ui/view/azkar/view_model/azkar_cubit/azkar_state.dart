part of 'azkar_cubit.dart';

sealed class AzkarState extends Equatable  {
  @override
  List<Object?> get props => [];
}

final class AzkarInitial extends AzkarState {}

class AzkarLoading extends AzkarState {}

class AzkarLoaded extends AzkarState {
  final List<SectionModel> sections;
  AzkarLoaded(this.sections);
  @override
  List<Object?> get props => [sections];
}

class AzkarError extends AzkarState {
  final String message;
  AzkarError(this.message);
  @override
  List<Object?> get props => [message];
}
