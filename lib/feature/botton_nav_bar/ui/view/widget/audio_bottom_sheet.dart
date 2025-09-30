import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/core/extension/theme_text.dart';

class AudioBottomSheet extends StatefulWidget {
  final String audioUrl;
  final String ayah;

  const AudioBottomSheet({
    super.key,
    required this.audioUrl,
    required this.ayah,
  });

  @override
  State<AudioBottomSheet> createState() => _AudioBottomSheetState();
}

class _AudioBottomSheetState extends State<AudioBottomSheet> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    // مدة الملف
    _audioPlayer.onDurationChanged.listen((newDuration) {
      if (!mounted) return;
      setState(() => _duration = newDuration);
    });

    // موقع التشغيل الحالي
    _audioPlayer.onPositionChanged.listen((newPosition) {
      if (!mounted) return;
      setState(() => _position = newPosition);
    });

    // عند انتهاء الملف
    _audioPlayer.onPlayerComplete.listen((_) {
      if (!mounted) return;
      setState(() {
        _isPlaying = false;
        _position = Duration.zero;
      });
    });

    // متابعة حالة التشغيل
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      try {
        await _audioPlayer.play(UrlSource(widget.audioUrl));
      } catch (e) {
        debugPrint("❌ Audio error: $e");
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("تعذر تشغيل الملف الصوتي")),
        );
      }
    }
  }

  void _seekTo(double seconds) {
    final newPosition = Duration(seconds: seconds.toInt());
    _audioPlayer.seek(newPosition);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // الآية
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  widget.ayah,
                  textDirection: TextDirection.rtl,
                  style: context.textTheme.titleLarge,
                  textAlign: TextAlign.justify,
                ),
              ),

              // زر التشغيل
              IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 40,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: _togglePlay,
              ),

              // شريط التقدم
              Slider(
                activeColor: AppColors.primary,
                inactiveColor: AppColors.secondary,
                min: 0,
                max:
                    _duration.inSeconds > 0
                        ? _duration.inSeconds.toDouble()
                        : 1,
                value:
                    _position.inSeconds
                        .clamp(0, _duration.inSeconds)
                        .toDouble(),
                onChanged: (value) => _seekTo(value),
              ),

              // الوقت الحالي / الكلي
              Text(
                "${_formatDuration(_position)} / ${_formatDuration(_duration)}",
                style: context.textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return hours > 0
        ? "${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}"
        : "${twoDigits(minutes)}:${twoDigits(seconds)}";
  }
}
