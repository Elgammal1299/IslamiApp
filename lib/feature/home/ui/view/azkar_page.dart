import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:islami_app/feature/home/ui/view/widget/counter_botton_widget.dart';
import 'package:islami_app/feature/home/ui/view/widget/reset_botton_widget.dart';

class AzkarPage extends StatefulWidget {
  static String routeName = "/azkarScreen";
  const AzkarPage({super.key});

  @override
  State<AzkarPage> createState() => _AzkarPageState();
}

class _AzkarPageState extends State<AzkarPage>
    with SingleTickerProviderStateMixin {
  int _counter = 0;
  late AnimationController _controller;
  late Animation<double> _animation;
  String _currentDhikr = "سبحان الله";
  int _dhikrIndex = 0;

  final List<String> _dhikrList = [
    "سبحان الله",
    "الحمد لله",
    "الله أكبر",
    "لا إله إلا الله",
    "أستغفر الله",
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      _controller.forward(from: 0.0);

      // تغيير الذكر كل 33 مرة
      if (_counter % 33 == 0) {
        _dhikrIndex = (_dhikrIndex + 1) % _dhikrList.length;
        _currentDhikr = _dhikrList[_dhikrIndex];
        _counter=0;
      }
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
      _dhikrIndex = 0;
      _currentDhikr = _dhikrList[0];
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
      appBar: AppBar(
        title: const Text(
          " الاذكار",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade100,
              Colors.white,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // عرض الذكر الحالي
            Container(
              width: double.infinity,
              height: 150,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _currentDhikr,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 40),
            // عرض العداد
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.shade300,
                        Colors.blue.shade600,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _animation.value * 2 * math.pi,
                      child: GestureDetector(
                  onTap: _incrementCounter,
                        
                        child: CounterBottonWidget(counter: _counter,)),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: _resetCounter,
              
              child: ResetBottonWidget()),
            
          ],
        ),
      ),
    );
  }
}
