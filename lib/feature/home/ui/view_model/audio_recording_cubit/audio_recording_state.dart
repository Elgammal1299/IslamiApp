part of 'audio_recording_cubit.dart';

sealed class AudioRecordingState {}

final class AudioRecordingInitial extends AudioRecordingState {}

class AudioRecording extends AudioRecordingState {}

class AudioRecordingStopped extends AudioRecordingState {
  final String path;
  AudioRecordingStopped(this.path);
}

class AudioRecordingError extends AudioRecordingState {
  final String message;
  AudioRecordingError(this.message);
}

class AudioRecorded extends AudioRecordingState {
  final String path;
  AudioRecorded(this.path);
}
