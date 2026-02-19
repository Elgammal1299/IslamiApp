import 'package:equatable/equatable.dart';
import 'package:radio_player/radio_player.dart';

sealed class RadioPlayerState extends Equatable {
  const RadioPlayerState();

  @override
  List<Object?> get props => [];
}

final class RadioPlayerInitial extends RadioPlayerState {}

final class RadioPlayerLoading extends RadioPlayerState {}

final class RadioPlayerPlaying extends RadioPlayerState {
  final bool isPlaying;
  final Metadata? metadata;

  const RadioPlayerPlaying({required this.isPlaying, this.metadata});

  @override
  List<Object?> get props => [isPlaying, metadata];
}

final class RadioPlayerError extends RadioPlayerState {
  final String message;

  const RadioPlayerError(this.message);

  @override
  List<Object?> get props => [message];
}
