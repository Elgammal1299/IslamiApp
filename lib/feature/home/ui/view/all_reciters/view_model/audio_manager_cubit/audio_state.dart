part of 'audio_cubit.dart';

sealed class AudioState  {
  const AudioState();
}

// الحالات الأساسية
class AudioInitial extends AudioState {
  const AudioInitial();
}

class AudioLoading extends AudioState {
  const AudioLoading();
}

class AudioError extends AudioState {
  final String message;
  const AudioError(this.message);
}

// الحالة الرئيسية التي تحمل جميع بيانات التشغيل
class AudioPlaybackState extends AudioState {
  final List<MediaItem> playlist;
  final MediaItem? currentItem;
  final bool isPlaying;
  final Duration position;
  final Duration bufferedPosition;
  final Duration? duration;
  final LoopMode loopMode;
  final bool isShuffled;
  final String? currentImageUrl;

  const AudioPlaybackState({
    required this.playlist,
    required this.currentItem,
    required this.isPlaying,
    required this.position,
    required this.bufferedPosition,
    required this.duration,
    required this.loopMode,
    required this.isShuffled,
    this.currentImageUrl,
  });

  // دالة مساعدة لإنشاء نسخة معدلة من الحالة
  AudioPlaybackState copyWith({
    List<MediaItem>? playlist,
    MediaItem? currentItem,
    bool? isPlaying,
    Duration? position,
    Duration? bufferedPosition,
    Duration? duration,
    LoopMode? loopMode,
    bool? isShuffled,
    String? currentImageUrl,
  }) {
    return AudioPlaybackState(
      playlist: playlist ?? this.playlist,
      currentItem: currentItem ?? this.currentItem,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      bufferedPosition: bufferedPosition ?? this.bufferedPosition,
      duration: duration ?? this.duration,
      loopMode: loopMode ?? this.loopMode,
      isShuffled: isShuffled ?? this.isShuffled,
      currentImageUrl: currentImageUrl ?? this.currentImageUrl,
    );
  }
}

// حالة خاصة عند اكتمال التشغيل
class AudioPlaybackCompleted extends AudioState {
  final List<MediaItem> playlist;
  const AudioPlaybackCompleted(this.playlist);
}
