import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'audio_manager.dart';

class AudioHandlerImpl extends BaseAudioHandler with SeekHandler {
  final AudioManager _manager;
  late final StreamSubscription mediaItemSub;
  late final StreamSubscription playbackStateSub;
  late final StreamSubscription positionSub;
  // AudioHandlerImpl(this._manager);
  AudioHandlerImpl(this._manager) {
    // متابعة تغييرات الأغنية الحالية
    mediaItemSub = _manager.currentMediaItem.listen((item) {
      if (item != null) {
        mediaItem.add(item); // تحديث الإشعار بالأغنية الجديدة
      }
    });

    // متابعة تغييرات حالة التشغيل
    playbackStateSub = _manager.playbackState.listen((state) {
      playbackState.add(state); // تحديث حالة التشغيل
    });

    // متابعة تغييرات الموضع
    positionSub = _manager.position.listen((position) {
      playbackState.add(
        playbackState.value.copyWith(
          updatePosition: position, // تحديث موضع التشغيل
        ),
      );
    });

    // تهيئة الحالة الأولية
    playbackState.add(
      PlaybackState(
        controls: [
          MediaControl.skipToPrevious,
          MediaControl.pause,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        processingState: AudioProcessingState.ready,
      ),
    );
  }

  @override
  Future<void> play() => _manager.play();

  @override
  Future<void> pause() => _manager.pause();

  @override
  Future<void> seek(Duration position) => _manager.seek(position);

  @override
  Future<void> stop() => _manager.stop();

  @override
  Future<void> skipToNext() => _manager.skipToNext();

  @override
  Future<void> skipToPrevious() => _manager.skipToPrevious();

  @override
  Future<void> skipToQueueItem(int index) => _manager.skipToIndex(index);

  Future<void> setLoopMode(LoopMode mode) => _manager.setLoopMode(mode);

  Future<void> setShuffle(bool enabled) => _manager.setShuffle(enabled);
}
