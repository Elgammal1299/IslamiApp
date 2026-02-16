import 'package:flutter/material.dart';
import 'dart:math' as math;

class SebhaCounterWidget extends StatelessWidget {
  final int counter;
  final Animation<double> animation;
  final VoidCallback onTap;

  const SebhaCounterWidget({
    super.key,
    required this.counter,
    required this.animation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const double sebhaSize = 200;

          return Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: animation.value * 2 * math.pi,
                        child: Image.asset(
                          "assets/images/sebha.png",
                          width: sebhaSize,
                          height: sebhaSize,
                          color: Theme.of(context).primaryColorDark,
                        ),
                      );
                    },
                  ),
                  Image.asset(
                    "assets/images/sebha2.png",
                    width: sebhaSize * 0.5,
                    height: sebhaSize * 0.5,
                          color: Theme.of(context).primaryColorDark,

                  ),
                ],
              ),

              // الرقم في نصف الدائرة بدقة وعلى كل الأجهزة
              Positioned(
                top: sebhaSize * 0.33,
                child: Text(
                  counter.toString(),
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark,
                        fontSize: sebhaSize * 0.25,
                      ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
