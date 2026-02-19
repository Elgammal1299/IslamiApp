import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_player/radio_player.dart';
import 'radio_player_state.dart';

class RadioPlayerCubit extends Cubit<RadioPlayerState> {
  bool _isInitialized = false;
  String? _currentUrl;
  String? _currentName;

  RadioPlayerCubit() : super(RadioPlayerInitial()) {
    _setupListeners();
  }

  void _setupListeners() {
    RadioPlayer.playbackStateStream.listen((state) {
      final isPlaying = state == PlaybackState.playing;
      if (this.state is RadioPlayerPlaying) {
        emit(
          RadioPlayerPlaying(
            isPlaying: isPlaying,
            metadata: (this.state as RadioPlayerPlaying).metadata,
          ),
        );
      } else {
        emit(RadioPlayerPlaying(isPlaying: isPlaying));
      }
    });

    RadioPlayer.metadataStream.listen((metadata) {
      if (state is RadioPlayerPlaying) {
        emit(
          RadioPlayerPlaying(
            isPlaying: (state as RadioPlayerPlaying).isPlaying,
            metadata: metadata,
          ),
        );
      } else {
        emit(RadioPlayerPlaying(isPlaying: false, metadata: metadata));
      }
    });

    // Listen to remote commands (Next/Previous buttons from background)
    RadioPlayer.remoteCommandStream.listen((command) {
      if (command == RemoteCommand.nextTrack) {
        // Use Next button for REFRESH
        if (_currentUrl != null) {
          refreshRadio(
            _currentUrl!,
            name: _currentName ?? 'إذاعة القرآن الكريم',
          );
        }
      } else if (command == RemoteCommand.previousTrack) {
        // Use Previous button for STOP/END
        stopRadio();
      }
    });
  }

  Future<void> playRadio(
    String url, {
    String name = 'إذاعة القرآن الكريم',
  }) async {
    try {
      _currentUrl = url;
      _currentName = name;
      emit(RadioPlayerLoading());

      if (!_isInitialized) {
        await RadioPlayer.setStation(
          title: name,
          url: url,
          logoAssetPath: 'assets/images/radio.png',
        );
        // Enable next/previous buttons in notification
        await RadioPlayer.setNavigationControls(
          showNextButton: true,
          showPreviousButton: true,
        );
        _isInitialized = true;
      }

      await RadioPlayer.play();
    } catch (e) {
      emit(const RadioPlayerError('تعذر تشغيل الراديو'));
    }
  }

  Future<void> refreshRadio(
    String url, {
    String name = 'إذاعة القرآن الكريم',
  }) async {
    try {
      _currentUrl = url;
      _currentName = name;
      emit(RadioPlayerLoading());
      await RadioPlayer.pause();

      await RadioPlayer.setStation(
        title: name,
        url: url,
        logoAssetPath: 'assets/images/radio.png',
      );
      await RadioPlayer.play();
    } catch (e) {
      emit(const RadioPlayerError('تعذر تحديث الراديو'));
    }
  }

  Future<void> stopRadio() async {
    await RadioPlayer.reset();
    emit(RadioPlayerInitial());
  }

  Future<void> togglePlay() async {
    if (state is RadioPlayerPlaying &&
        (state as RadioPlayerPlaying).isPlaying) {
      await RadioPlayer.pause();
    } else {
      await RadioPlayer.play();
    }
  }

  @override
  Future<void> close() async {
    await RadioPlayer.reset();
    return super.close();
  }
}
