import 'package:flutter/material.dart';
import 'package:islami_app/feature/home/ui/view/widget/counter_botton_widget.dart';
import 'dart:math' as math;

import 'package:islami_app/feature/home/ui/view/widget/reset_botton_widget.dart';

class SebhaPage extends StatefulWidget {
  const SebhaPage({super.key});

  @override
  State<SebhaPage> createState() => _SebhaPageState();
}

class _SebhaPageState extends State<SebhaPage>
    with SingleTickerProviderStateMixin {
  int _counter = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: 0.08,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

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
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
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
          "السبحة",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            // دائرة السبحة الرئيسية
            GestureDetector(
              onTap: _incrementCounter,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _animation.value * 2 * math.pi,
                    child: CounterBottonWidget(counter: _counter),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
            // نص إرشادي
            Text(
              "انقر على الدائرة للتسبيح",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 30),
            // زر إعادة التعيين
            GestureDetector(onTap: _resetCounter, child: const ResetBottonWidget()),
          ],
        ),
      ),
    );
  }
}
