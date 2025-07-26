part of 'radio_cubit.dart';

@immutable
sealed class RadioState {}

final class RadioInitial extends RadioState {}

class RadioLoading extends RadioState {}

class RadioLoaded extends RadioState {
  final List<RadioModel> stations;

  RadioLoaded(this.stations);
}

class RadioError extends RadioState {
  final String message;

  RadioError(this.message);
}

class RadioPlaying extends RadioState {
  final bool isPlaying;
  final String currentUrl;
  RadioPlaying(this.isPlaying, this.currentUrl);
}

class RadioStopped extends RadioState {}

class RadioPaused extends RadioState {}
