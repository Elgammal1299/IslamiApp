import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

class AzanPlayer {
  AzanPlayer._();
  static final AudioPlayer _player = AudioPlayer();
  static bool _isPlaying = false;

  static Future<void> play() async {
    // Prevent multiple simultaneous plays
    if (_isPlaying) return;

    try {
      _isPlaying = true;
      await _player.stop();
      await _player.setReleaseMode(ReleaseMode.stop);
      await _player.play(AssetSource('assets/audio/azan.mp3'));

      // Reset playing flag after a delay to prevent immediate re-triggering
      Timer(const Duration(seconds: 30), () {
        _isPlaying = false;
      });
    } catch (_) {
      _isPlaying = false;
      // Silently ignore playback errors
    }
  }

  static Future<void> stop() async {
    _isPlaying = false;
    await _player.stop();
  }
}
