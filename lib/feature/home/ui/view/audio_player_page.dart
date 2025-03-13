import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:islami_app/feature/home/ui/view/widget/waveform_painter.dart';

class AudioPlayerPage extends StatefulWidget {
  static String routeName = '/AudioPlayerPage';

  const AudioPlayerPage({super.key});

  @override
  _AudioPlayerPageState createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage>
    with SingleTickerProviderStateMixin {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  List<String> audioUrls = [];
 late int currentAudioIndex ;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  String? surahName;
  
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      currentAudioIndex = args['surahIndex'] as int;
      surahName = args['surahName'] as String;
    }
  }

  Future<void> loadAudioUrls() async {
    try {
      String content = await rootBundle.loadString('assets/audio/audio.txt');
      setState(() {
        audioUrls = content.split(',').map((url) => url.trim()).toList();
      });
        await playAudio();
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

  Future<void> playPrevious() async {
    if (currentAudioIndex > 0) {
      currentAudioIndex--;
      await playAudio();
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          surahName ?? 'تلاوة القرآن',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
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
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Text(
                ' ',
                // 'الآية ${currentAudioIndex + 1} من ${audioUrls.length}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.skip_previous, color: Colors.white, size: 40),
                        onPressed: playPrevious,
                      ),
                      SizedBox(width: 50),
                      GestureDetector(
                        onTap: togglePlay,
                        child: Container(
                          width: 150,
                          height: 150,
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
                      SizedBox(width: 50),
                      IconButton(
                        icon: Icon(Icons.skip_next, color: Colors.white, size: 40),
                        onPressed: playNext,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 110),
              Container(
                width: 370,
                child: Column(
                  children: [
                    SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 4,
                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                        overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
                      ),
                      child: Slider(
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
              Spacer(),
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
