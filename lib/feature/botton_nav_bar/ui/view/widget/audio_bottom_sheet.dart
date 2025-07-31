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
  _AudioBottomSheetState createState() => _AudioBottomSheetState();
}

class _AudioBottomSheetState extends State<AudioBottomSheet> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    // الاستماع لتغير مدة التشغيل الكلية
    _audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        _duration = newDuration;
      });
    });

    // الاستماع لتغير مدة التشغيل الحالية
    _audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        _position = newPosition;
      });
    });

    // يمكنك الاستماع لإنهاء التشغيل إذا أردت
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying = false;
        _position = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlay() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(widget.audioUrl));
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _seekTo(double seconds) {
    final newPosition = Duration(seconds: seconds.toInt());
    _audioPlayer.seek(newPosition);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                textDirection: TextDirection.rtl,

                widget.ayah,
                style: context.textTheme.titleLarge,
                textAlign: TextAlign.justify,
              ),
            ),
            // زر التشغيل/الإيقاف المؤقت
            IconButton(
              icon: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                size: 40,
                color: Theme.of(context).primaryColorDark,
              ),
              onPressed: _togglePlay,
            ),
            // شريط التمرير الذي يعرض حالة التشغيل ويسمح بالتقديم أو التأخير
            Slider(
              activeColor: AppColors.primary,
              inactiveColor: AppColors.secondary,
              min: 0,
              max: _duration.inSeconds.toDouble(),
              value: _position.inSeconds.toDouble().clamp(
                0,
                _duration.inSeconds.toDouble(),
              ),
              onChanged: (value) {
                _seekTo(value);
              },
            ),
            // عرض الوقت الحالي والمدى الكلي
            Text(
              "${_formatDuration(_position)} / ${_formatDuration(_duration)}",
              style: context.textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }

  // دالة لتنسيق مدة التشغيل في شكل hh:mm:ss
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
