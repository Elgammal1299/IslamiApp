part of 'radio_cubit.dart';

@immutable
sealed class RadioState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class RadioInitial extends RadioState {}

class RadioLoading extends RadioState {}

class RadioLoaded extends RadioState {
  final List<RadioModel> stations;

  RadioLoaded(this.stations);
  @override
  List<Object?> get props => [stations];
}

class RadioError extends RadioState {
  final String message;

  RadioError(this.message);
  @override
  List<Object?> get props => [message];
}

class RadioPlaying extends RadioState {
  final bool isPlaying;
  final String currentUrl;
  RadioPlaying(this.isPlaying, this.currentUrl);
  @override
  List<Object?> get props => [isPlaying, currentUrl];
}

class RadioStopped extends RadioState {}

class RadioPaused extends RadioState {}
