import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class AudioPlayerPage extends StatefulWidget {
  const AudioPlayerPage({super.key});

  @override
  _AudioPlayerPageState createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage>
    with SingleTickerProviderStateMixin {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  List<String> audioUrls = [];
  int currentAudioIndex = 0;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  
  late AnimationController _animationController;
  final int numberOfBars = 30;
  final double maxBarHeight = 40.0;

  @override
  void initState() {
    super.initState();
    loadAudioUrls();
    setupAudioPlayer();
    
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
  }

  Future<void> loadAudioUrls() async {
    try {
      String content = await rootBundle.loadString('assets/audio/audio.txt');
      setState(() {
        audioUrls = content.split(',').map((url) => url.trim()).toList();
      });
    } catch (e) {
      debugPrint('Error loading audio URLs: $e');
    }
  }

  void setupAudioPlayer() {
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });

    audioPlayer.onPlayerComplete.listen((event) {
      playNext();
    });
  }

  Future<void> playNext() async {
    if (currentAudioIndex < audioUrls.length - 1) {
      currentAudioIndex++;
      await playAudio();
    } else {
      stopAudio();
    }
  }

  Future<void> playAudio() async {
    if (audioUrls.isNotEmpty) {
      try {
        await audioPlayer.play(UrlSource(audioUrls[currentAudioIndex]));
        setState(() {
          isPlaying = true;
        });
        _animationController.repeat(reverse: true);
      } catch (e) {
        debugPrint('Error playing audio: $e');
      }
    }
  }

  Future<void> pauseAudio() async {
    await audioPlayer.pause();
    setState(() {
      isPlaying = false;
    });
    _animationController.stop();
  }

  void stopAudio() async {
    await audioPlayer.stop();
    setState(() {
      isPlaying = false;
      position = Duration.zero;
    });
    _animationController.stop();
  }

  Future<void> togglePlay() async {
    if (isPlaying) {
      await pauseAudio();
    } else {
      await playAudio();
    }
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple.shade900,
              Colors.blue.shade900,
              Colors.black,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  if (isPlaying)
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return SizedBox(
                          width: 300,
                          height: 300,
                          child: CustomPaint(
                            painter: WaveformPainter(
                              numberOfBars: numberOfBars,
                              maxHeight: maxBarHeight,
                              animation: _animationController,
                            ),
                          ),
                        );
                      },
                    ),
                  
                  GestureDetector(
                    onTap: togglePlay,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              
              // Slider للتحكم في موضع التشغيل
              Container(
                width: 300,
                child: Column(
                  children: [
                    Slider(
                      value: position.inSeconds.toDouble(),
                      min: 0,
                      max: duration.inSeconds.toDouble(),
                      onChanged: (value) async {
                        final position = Duration(seconds: value.toInt());
                        await audioPlayer.seek(position);
                      },
                      activeColor: Colors.white,
                      inactiveColor: Colors.white.withOpacity(0.3),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatTime(position),
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            formatTime(duration),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }
}

class WaveformPainter extends CustomPainter {
  final int numberOfBars;
  final double maxHeight;
  final Animation<double> animation;

  WaveformPainter({
    required this.numberOfBars,
    required this.maxHeight,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.3;

    for (int i = 0; i < numberOfBars; i++) {
      final angle = (i * 2 * pi) / numberOfBars;
      final barHeight = maxHeight * (0.3 + 0.7 * (sin(animation.value * pi + i) + 1) / 2);
      
      // إنشاء تدرج لوني للموجات
      final paint = Paint()
        ..shader = LinearGradient(
          colors: [
            Colors.purple.shade400,
            Colors.blue.shade400,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius + maxHeight))
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;
      
      final startPoint = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      
      final endPoint = Offset(
        center.dx + (radius + barHeight) * cos(angle),
        center.dy + (radius + barHeight) * sin(angle),
      );

      canvas.drawLine(startPoint, endPoint, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
