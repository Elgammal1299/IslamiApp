import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/helper/audio_manager.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view/widget/custom_mini_player_widget.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view/widget/play_list_screen.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view_model/audio_manager_cubit/audio_cubit.dart';

class AudioAppWrapper extends StatefulWidget {
  final AudioManager audioManager;

  const AudioAppWrapper({super.key, required this.audioManager});

  @override
  _AudioAppWrapperState createState() => _AudioAppWrapperState();
}

class _AudioAppWrapperState extends State<AudioAppWrapper> {
  bool _showMiniPlayer = false;
  final bool _isUserDragging = false;
  double _miniPlayerProgress = 0.0;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  final double _dragStartPosition = 0.0;
  final Duration _dragStartDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _setupAudioListeners();
  }

  void _setupAudioListeners() {
    widget.audioManager.playbackState.listen((state) {
      if (mounted) {
        setState(() {
          _showMiniPlayer =
              state.processingState == AudioProcessingState.ready ||
              state.processingState == AudioProcessingState.buffering;
        });
      }
    });

    widget.audioManager.position.listen((position) {
      if (mounted && !_isUserDragging) {
        setState(() => _position = position);
        _updateMiniPlayerProgress();
      }
    });

    widget.audioManager.duration.listen((duration) {
      if (mounted) {
        setState(() => _duration = duration ?? Duration.zero);
        _updateMiniPlayerProgress();
      }
    });
  }

  void _updateMiniPlayerProgress() {
    if (_duration.inMilliseconds > 0) {
      setState(() {
        _miniPlayerProgress = (_position.inMilliseconds /
                _duration.inMilliseconds)
            .clamp(0.0, 1.0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioCubit, AudioState>(
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              PlaylistScreen(audioManager: widget.audioManager),
              if (_showMiniPlayer)
                CustomMiniPlayerWidget(
                  showMiniPlayer: _showMiniPlayer,
                  dragStartDuration: _dragStartDuration,
                  dragStartPosition: _dragStartPosition,
                  duration: _duration,
                  isUserDragging: _isUserDragging,
                  miniPlayerProgress: _miniPlayerProgress,
                  position: _position,
                  audioManager: widget.audioManager,
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
