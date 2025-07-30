part of 'azkar_yawmi_cubit.dart';

sealed class AzkarYawmiState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SupplicationInitial extends AzkarYawmiState {}

class SupplicationLoading extends AzkarYawmiState {}

class SupplicationLoaded extends AzkarYawmiState {
  final Map<String, List<AzkarYawmiModel>> data;
  SupplicationLoaded(this.data);
  @override
  List<Object?> get props => [data];
}

class SupplicationError extends AzkarYawmiState {
  final String message;
  SupplicationError(this.message);
  @override
  List<Object?> get props => [message];
}
