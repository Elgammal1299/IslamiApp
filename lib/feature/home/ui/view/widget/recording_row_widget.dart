import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/feature/home/data/model/recording_model.dart';

class RecordingRowWidget extends StatefulWidget {
  final RecordingModel recording;
  final VoidCallback onDelete;
  final String? currentlyPlayingKey;
  final void Function(String key) onPlayRequest;
  final void Function(String key) onStopRequest;
  const RecordingRowWidget({
    super.key,
    required this.recording,
    required this.onDelete,
    required this.currentlyPlayingKey,
    required this.onPlayRequest,
    required this.onStopRequest,
  });

  @override
  State<RecordingRowWidget> createState() => _RecordingRowWidgetState();
}

class _RecordingRowWidgetState extends State<RecordingRowWidget> {
  late final PlayerController _playerController;
  bool _isPlaying = false;
  StreamSubscription<PlayerState>? _playerSubscription;
  bool _waveformError = false;

  @override
  void initState() {
    super.initState();
    _playerController = PlayerController();
    _playerSubscription = _playerController.onPlayerStateChanged.listen((
      state,
    ) async {
      if (state == PlayerState.stopped) {
        setState(() {
          _isPlaying = false;
        });
        widget.onStopRequest(widget.recording.key);
      } else if (state == PlayerState.playing) {
        setState(() {
          _isPlaying = true;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant RecordingRowWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If another row started playing, stop this one
    if (widget.currentlyPlayingKey != widget.recording.key && _isPlaying) {
      _playerController.stopPlayer();
    }
  }

  @override
  void dispose() {
    _playerSubscription?.cancel();
    _playerController.dispose();
    super.dispose();
  }

  Future<void> _playOrStop() async {
    if (_isPlaying) {
      await _playerController.stopPlayer();
      widget.onStopRequest(widget.recording.key);
    } else {
      try {
        setState(() => _waveformError = false);
        widget.onPlayRequest(widget.recording.key);
        await _playerController.preparePlayer(path: widget.recording.filePath);
        await _playerController.startPlayer();
      } catch (e) {
        setState(() => _waveformError = true);
      }
    }
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    if (d.inHours > 0) {
      return "${d.inHours}:${twoDigits(d.inMinutes % 60)}:${twoDigits(d.inSeconds % 60)}";
    } else {
      return "${d.inMinutes}:${twoDigits(d.inSeconds % 60)}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final rec = widget.recording;
    final isActive = widget.currentlyPlayingKey == rec.key;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColorDark,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Play/Stop button
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor, // WhatsApp blue
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      isActive && _isPlaying ? Icons.stop : Icons.play_arrow,
                      color: AppColors.white,
                      size: 20,
                    ),
                    tooltip: isActive && _isPlaying ? "إيقاف" : "تشغيل",
                    onPressed: _playOrStop,
                  ),
                ),
                const SizedBox(width: 8),
                // Blue dot
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                // Waveform or fallback line
                Expanded(
                  child:
                      isActive && _isPlaying && !_waveformError
                          ? AudioFileWaveforms(
                            size: const Size(double.infinity, 36),
                            playerController: _playerController,
                            waveformType: WaveformType.long,
                            continuousWaveform: true,
                            animationDuration: const Duration(milliseconds: 10),
                            playerWaveStyle: PlayerWaveStyle(
                              fixedWaveColor:
                                  Theme.of(context).secondaryHeaderColor,
                              liveWaveColor: Theme.of(context).primaryColor,
                              spacing: 6,
                              showSeekLine: false,
                            ),
                            enableSeekGesture: false,
                          )
                          : Container(
                            height: 36,
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: 4,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                ),
                // Delete button
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppColors.red),
                  tooltip: "حذف التسجيل",
                  onPressed: widget.onDelete,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                // Duration (left)
                Text(
                  _formatDuration(Duration(milliseconds: rec.duration ?? 0)),
                  style: context.textTheme.bodyMedium,
                ),
                const Spacer(),
                // Time (right)
                Text(
                  DateFormat('hh:mm a').format(rec.createdAt),
                  style: context.textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
