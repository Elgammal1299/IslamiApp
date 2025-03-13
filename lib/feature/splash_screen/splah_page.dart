import 'package:flutter/material.dart';
import 'package:islami_app/feature/home/ui/view/home_screen.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = '/SplashScreen';

  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
    
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: FadeTransition(
                opacity: _animation,
                child: Image.asset(
                  'assets/images/splash.png',
                  width: 200,
                  height: 200,
                ),
              ),
            ),
            Center(child: Text('القرءان الكريم',style: const TextStyle(
                              fontFamily: "arsura",
                              fontSize: 22,
                              color: Colors.black,
                            ),),)
          ],
        ),
      ),
    );
  }
}
