import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:islami_app/core/constant/app_image.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/core/router/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ValueNotifier<bool> isMuted = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    _playSplashAudio();

    Future.delayed(const Duration(seconds: 7), () {
      Navigator.pushReplacementNamed(context, AppRoutes.homeRoute);
    });
  }

  Future<void> _playSplashAudio() async {
    try {
      await _audioPlayer.play(AssetSource('audio/splah-audio.mp3'));
    } catch (e) {
      debugPrint("خطأ أثناء تشغيل الصوت: $e");
    }
  }

  void _toggleMute() async {
    if (isMuted.value) {
      await _audioPlayer.resume();
    } else {
      await _audioPlayer.pause();
    }
    isMuted.value = !isMuted.value;
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    isMuted.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeTransition(
                  opacity: _animation,
                  child: CircleAvatar(
                    radius: 120,
                    backgroundColor: Colors.green,
                    child: Image.asset(
                      isDark
                          ? AppImage.splashImageDark
                          : AppImage.splashImageLight,
                      width: 300,
                      height: 300,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('وَارْتَـقِ', style: context.textTheme.titleLarge),
                const SizedBox(height: 10),
                Text('كل ما يخص المسلم', style: context.textTheme.titleLarge),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            right: 20,
            child: ValueListenableBuilder<bool>(
              valueListenable: isMuted,
              builder: (context, muted, _) {
                return IconButton(
                  onPressed: _toggleMute,
                  icon: Icon(
                    muted ? Icons.volume_off : Icons.volume_up,
                    size: 30,
                    color: Colors.grey[800],
                  ),
                  tooltip: muted ? 'تشغيل الصوت' : 'كتم الصوت',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
