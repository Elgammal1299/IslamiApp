import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:islami_app/core/helper/audio_handler_impl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class AudioManager {
  // Singleton instance
  static final AudioManager _instance = AudioManager._internal();

  factory AudioManager() => _instance;

  AudioManager._internal();

  final _player = AudioPlayer();
  late final AudioHandlerImpl _audioHandler;

  final List<MediaItem> _playlist = [];
  int? _currentIndex;

  bool _initialized = false;

  // Streams للتعرض للحالة
  final BehaviorSubject<PlaybackState> _playbackState =
      BehaviorSubject<PlaybackState>();
  final BehaviorSubject<MediaItem?> _currentMediaItem =
      BehaviorSubject<MediaItem?>();
  final BehaviorSubject<List<MediaItem>> _queue =
      BehaviorSubject<List<MediaItem>>();
  final BehaviorSubject<Duration> _position = BehaviorSubject<Duration>();
  final BehaviorSubject<Duration?> _duration = BehaviorSubject<Duration?>();

  Stream<LoopMode> get loopModeStream => _player.loopModeStream;
  Stream<bool> get shuffleModeStream => _player.shuffleModeEnabledStream;

  Future<void> _init() async {
    if (_initialized) return;

    _audioHandler = await AudioService.init(
      builder: () => AudioHandlerImpl(this),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.your.app.audio',
        androidNotificationChannelName: 'تطبيق اسلامي',
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
      ),
    );

    _initialized = true;

    _player.playbackEventStream.listen((event) {
      _audioHandler.playbackState.add(_transformEvent(event));
    });

    _player.positionStream.listen((position) {
      _position.add(position);
      if (_player.duration != null) {
        _duration.add(_player.duration!);
      }
    });

    _player.playbackEventStream.map(_transformEvent).pipe(_playbackState);

    _player.durationStream.listen((duration) {
      _duration.add(duration);
    });

    _player.currentIndexStream.listen((index) {
      _currentIndex = index;
      if (index != null && index < _playlist.length) {
        _currentMediaItem.add(_playlist[index]);
      }
    });
  }

  Future<void> loadPlaylist(List<MediaItem> playlist) async {
    await _init();

    _playlist.clear();
    _playlist.addAll(playlist);
    _queue.add(List.from(_playlist));

    await _player.setAudioSource(
      ConcatenatingAudioSource(
        children: _playlist.map((item) => _createAudioSource(item)).toList(),
      ),
      initialIndex: 0,
    );

    _player.currentIndexStream.listen((index) async {
      if (index != null && index < _playlist.length) {
        // final currentItem = _playlist[index];
        final duration = _player.duration;
        _duration.add(duration ?? Duration.zero);
      }
    });

    _player.durationStream.listen((duration) {
      if (_currentIndex != null && _currentIndex! < _playlist.length) {
        final currentItem = _playlist[_currentIndex!];
        if (currentItem.duration == null || currentItem.duration != duration) {
          _playlist[_currentIndex!] = currentItem.copyWith(duration: duration);
          _queue.add(List.from(_playlist));
        }
      }
      _duration.add(duration);
    });
  }

  AudioSource _createAudioSource(MediaItem item) {
    if (item.id.startsWith('asset://')) {
      return AudioSource.asset(item.id.replaceFirst('asset:///', ''));
    } else {
      return AudioSource.uri(Uri.parse(item.id));
    }
  }

  Future<void> play() => _player.play();
  Future<void> pause() => _player.pause();
  Future<void> stop() => _player.stop();
  Future<void> seek(Duration position) => _player.seek(position);
  Future<void> skipToNext() => _player.seekToNext();
  Future<void> skipToPrevious() => _player.seekToPrevious();

  Future<void> skipToIndex(int index) async {
    if (index >= 0 && index < _playlist.length) {
      await _player.seek(Duration.zero, index: index);
      _currentIndex = index;
      _currentMediaItem.add(_playlist[index]);
    }
  }

  Future<void> setLoopMode(LoopMode mode) => _player.setLoopMode(mode);
  Future<void> setShuffle(bool enabled) =>
      _player.setShuffleModeEnabled(enabled);

  Stream<PlaybackState> get playbackState => _playbackState.stream;
  Stream<MediaItem?> get currentMediaItem => _currentMediaItem.stream;
  Stream<List<MediaItem>> get queue => _queue.stream;
  Stream<Duration> get position => _position.stream;
  Stream<Duration?> get duration => _duration.stream;

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        _player.playing ? MediaControl.pause : MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState:
          const {
            ProcessingState.idle: AudioProcessingState.idle,
            ProcessingState.loading: AudioProcessingState.loading,
            ProcessingState.buffering: AudioProcessingState.buffering,
            ProcessingState.ready: AudioProcessingState.ready,
            ProcessingState.completed: AudioProcessingState.completed,
          }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }
}
