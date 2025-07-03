import 'package:audio_service/audio_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/helper/audio_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';

part 'audio_state.dart';

class AudioCubit extends Cubit<AudioState> {
  final AudioManager _audioManager;
  late final StreamSubscription _playbackStateSub;
  late final StreamSubscription _currentItemSub;
  late final StreamSubscription _queueSub;
  late final StreamSubscription _positionSub;
  late final StreamSubscription _loopModeSub;
  late final StreamSubscription _shuffleModeSub;
  late final StreamSubscription<Duration?> _durationSub;
  AudioCubit(this._audioManager) : super(const AudioInitial()) {
    _init();
  }

  void _init() {
    // الاشتراك في جميع الـ streams المهمة
    _playbackStateSub = _audioManager.playbackState.listen(
      _handlePlaybackState,
    );
    _currentItemSub = _audioManager.currentMediaItem.listen(_handleCurrentItem);
    _queueSub = _audioManager.queue.listen(_handleQueue);
    _positionSub = _audioManager.position.listen(_handlePosition);
    _loopModeSub = _audioManager.loopModeStream.listen(_handleLoopMode);
    _shuffleModeSub = _audioManager.shuffleModeStream.listen(
      _handleShuffleMode,
    );
    _durationSub = _audioManager.duration.listen((duration) {
      final currentState = state;
      if (currentState is AudioPlaybackState) {
        emit(currentState.copyWith(duration: duration));
      }
    });

    // تحميل الحالة الأولية
    _loadInitialState();
  }

  Future<void> _loadInitialState() async {
    try {
      emit(const AudioLoading());

      await _audioManager.playbackState.firstWhere(
        (state) => state.processingState == AudioProcessingState.ready,
      );

      final queue = await _audioManager.queue.first;
      final currentItem = await _audioManager.currentMediaItem.first;
      final position = await _audioManager.position.first;
      final duration = await _audioManager.duration.first;
      final isPlaying = (await _audioManager.playbackState.first).playing;
      final loopMode = await _audioManager.loopModeStream.first;
      final isShuffled = await _audioManager.shuffleModeStream.first;

      emit(
        AudioPlaybackState(
          playlist: queue,
          currentItem: currentItem,
          isPlaying: isPlaying,
          position: position,
          bufferedPosition: position,
          duration: duration,
          loopMode: loopMode,
          isShuffled: isShuffled,
        ),
      );
    } catch (e) {
      emit(AudioError('Failed to load: ${e.toString()}'));
    }
  }

  void _handlePlaybackState(PlaybackState state) {
    final currentState = this.state;

    if (state.processingState == AudioProcessingState.completed) {
      if (currentState is AudioPlaybackState) {
        emit(AudioPlaybackCompleted(currentState.playlist));
      }
      return;
    }

    if (currentState is AudioPlaybackState) {
      emit(
        currentState.copyWith(
          isPlaying: state.playing,
          bufferedPosition: state.bufferedPosition,
        ),
      );
    }
  }

  void _handleCurrentItem(MediaItem? item) {
    final currentState = state;
    if (currentState is AudioPlaybackState && item != null) {
      emit(currentState.copyWith(currentItem: item));
    }
  }

  void _handleQueue(List<MediaItem> queue) {
    final currentState = state;
    if (currentState is AudioPlaybackState) {
      emit(currentState.copyWith(playlist: queue));
    }
  }

  void _handlePosition(Duration position) {
    final currentState = state;
    if (currentState is AudioPlaybackState) {
      emit(currentState.copyWith(position: position));
    }
  }

  void _handleLoopMode(LoopMode mode) {
    final currentState = state;
    if (currentState is AudioPlaybackState) {
      emit(currentState.copyWith(loopMode: mode));
    }
  }

  void _handleShuffleMode(bool isShuffled) {
    final currentState = state;
    if (currentState is AudioPlaybackState) {
      emit(currentState.copyWith(isShuffled: isShuffled));
    }
  }

  // ========== واجهة التحكم الأساسية ==========
  Future<void> loadPlaylist(List<MediaItem> playlist) async {
    try {
      emit(const AudioLoading());
      await _audioManager.loadPlaylist(playlist);
    } catch (e) {
      emit(AudioError('Failed to load playlist: ${e.toString()}'));
      rethrow;
    }
  }

  Future<void> play() async {
    try {
      await _audioManager.play();
    } catch (e) {
      emit(AudioError('Play failed: ${e.toString()}'));
      rethrow;
    }
  }

  Future<void> pause() async {
    try {
      await _audioManager.pause();
    } catch (e) {
      emit(AudioError('Pause failed: ${e.toString()}'));
      rethrow;
    }
  }

  Future<void> togglePlayPause() async {
    final currentState = state;
    if (currentState is AudioPlaybackState) {
      currentState.isPlaying ? await pause() : await play();
    }
  }

  Future<void> skipToNext() async {
    try {
      await _audioManager.skipToNext();
    } catch (e) {
      emit(AudioError('Skip next failed: ${e.toString()}'));
      rethrow;
    }
  }

  Future<void> skipToPrevious() async {
    try {
      await _audioManager.skipToPrevious();
    } catch (e) {
      emit(AudioError('Skip previous failed: ${e.toString()}'));
      rethrow;
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await _audioManager.seek(position);
    } catch (e) {
      emit(AudioError('Seek failed: ${e.toString()}'));
      rethrow;
    }
  }

  Future<void> setLoopMode(LoopMode mode) async {
    try {
      await _audioManager.setLoopMode(mode);
    } catch (e) {
      emit(AudioError('Loop mode change failed: ${e.toString()}'));
      rethrow;
    }
  }

  Future<void> setShuffle(bool enabled) async {
    try {
      await _audioManager.setShuffle(enabled);
    } catch (e) {
      emit(AudioError('Shuffle mode change failed: ${e.toString()}'));
      rethrow;
    }
  }

  Future<void> skipToIndex(int index) async {
    try {
      await _audioManager.skipToIndex(index);
    } catch (e) {
      emit(AudioError('Skip to index failed: ${e.toString()}'));
      rethrow;
    }
  }

  @override
  Future<void> close() {
    _durationSub.cancel();
    _playbackStateSub.cancel();
    _currentItemSub.cancel();
    _queueSub.cancel();
    _positionSub.cancel();
    _loopModeSub.cancel();
    _shuffleModeSub.cancel();
    return super.close();
  }
}
