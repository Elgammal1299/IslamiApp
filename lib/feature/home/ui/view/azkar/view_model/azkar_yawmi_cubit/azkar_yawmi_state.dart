part of 'azkar_yawmi_cubit.dart';

sealed class AzkarYawmiState {}

class SupplicationInitial extends AzkarYawmiState {}

class SupplicationLoading extends AzkarYawmiState {}

class SupplicationLoaded extends AzkarYawmiState {
  final Map<String, List<AzkarYawmiModel>> data;
  SupplicationLoaded(this.data);
}

class SupplicationError extends AzkarYawmiState {
  final String message;
  SupplicationError(this.message);
}
