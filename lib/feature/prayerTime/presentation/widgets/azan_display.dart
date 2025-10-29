import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';

import 'package:islami_app/feature/prayerTime/presentation/widgets/azan_grid_view.dart';
import 'package:islami_app/feature/prayerTime/presentation/widgets/prayer_image.dart';

class AzanDisplay extends StatelessWidget {
  final PrayerTimes times;
  final Prayer? currentPrayer;

  const AzanDisplay({
    super.key,
    required this.times,
    required this.currentPrayer,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (currentPrayer == Prayer.maghrib)
          Positioned(
            top: -25,
            child: Opacity(
              opacity: .5,
              child: Image.asset(
                "assets/images/m3rep.png",
                color: Colors.white.withValues(alpha: .2),
                fit: BoxFit.contain,
              ),
            ),
          ),

        PrayerImage(currentPrayer: currentPrayer),
        Padding(
          padding: const EdgeInsets.all(16),
          child: AzanGrid(todayTimes: times),
        ),
      ],
    );
  }
}
