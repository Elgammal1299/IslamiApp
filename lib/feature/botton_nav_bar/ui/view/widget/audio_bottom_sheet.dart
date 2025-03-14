
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            color: Colors.grey[200],
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                textDirection: TextDirection.rtl,

                widget.ayah,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
          // زر التشغيل/الإيقاف المؤقت
          IconButton(
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, size: 36),
            onPressed: _togglePlay,
          ),
          // شريط التمرير الذي يعرض حالة التشغيل ويسمح بالتقديم أو التأخير
          Slider(
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
            style: const TextStyle(fontSize: 14),
          ),
        ],
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
