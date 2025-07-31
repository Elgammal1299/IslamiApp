part of 'audio_recording_cubit.dart';

sealed class AudioRecordingState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class AudioRecordingInitial extends AudioRecordingState {}

class AudioRecording extends AudioRecordingState {}

class AudioRecordingStopped extends AudioRecordingState {
  final String path;
  AudioRecordingStopped(this.path);
  @override
  List<Object?> get props => [path];
}

class AudioRecordingError extends AudioRecordingState {
  final String message;
  AudioRecordingError(this.message);
}

class AudioRecorded extends AudioRecordingState {
  final String path;
  AudioRecorded(this.path);
  @override
  List<Object?> get props => [path];
}
