import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:islami_app/core/constant/app_image.dart';
import 'package:islami_app/core/router/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isMuted = false;

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
      print("خطأ أثناء تشغيل الصوت: $e");
    }
  }

  void _toggleMute() {
    if (isMuted) {
      _audioPlayer.resume();
    } else {
      _audioPlayer.pause();
    }
    setState(() {
      isMuted = !isMuted;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // المحتوى الأساسي في المنتصف
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
                      Theme.of(context).brightness == Brightness.dark
                          ? AppImage.splashImageDark
                          : AppImage.splashImageLight,

                      width: 300,
                      height: 300,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'وَارْتَـقِ',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  'كل ما يخص المسلم',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),

          // زر كتم الصوت في الأسفل
          Positioned(
            bottom: 30,
            right: 20,
            child: IconButton(
              onPressed: _toggleMute,
              icon: Icon(
                isMuted ? Icons.volume_off : Icons.volume_up,
                size: 30,
                color: Colors.grey[800],
              ),
              tooltip: isMuted ? 'تشغيل الصوت' : 'كتم الصوت',
            ),
          ),
        ],
      ),
    );
  }
}
