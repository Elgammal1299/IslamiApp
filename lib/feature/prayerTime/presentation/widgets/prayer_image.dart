import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';

class PrayerImage extends StatelessWidget {
  final Prayer? currentPrayer;

  const PrayerImage({super.key, required this.currentPrayer});

  _PrayerImageData _getImageForPrayerPosition(Prayer? prayer) {
    switch (prayer) {
      case Prayer.fajr:
        return const _PrayerImageData(asset: "assets/images/stars.png", top: 0);
      case Prayer.sunrise:
        return const _PrayerImageData(
          asset: "assets/images/Sun.png",
          bottom: -150,
          left: 5,
        );
      case Prayer.dhuhr:
        return const _PrayerImageData(
          asset: "assets/images/Sun.png",
          top: -23,
          right: 140,
        );
      case Prayer.asr:
        return const _PrayerImageData(
          asset: "assets/images/Sun.png",
          bottom: -60,
          right: 5,
        );
      case Prayer.maghrib:
        return const _PrayerImageData(
          asset: "assets/images/Sun.png",
          bottom: -180,
          right: 5,
        );
      case Prayer.isha:
        return const _PrayerImageData(
          asset: "assets/images/moon.png",
          bottom: -160,
        );
      default:
        return const _PrayerImageData(
          asset: "assets/images/stars.png",
          top: -10,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageData = _getImageForPrayerPosition(currentPrayer);

    return Positioned(
      top: imageData.top,
      bottom: imageData.bottom,
      left: imageData.left,
      right: imageData.right,
      child: Opacity(
        opacity: .5,
        child: Image.asset(imageData.asset, fit: BoxFit.contain),
      ),
    );
  }
}

class _PrayerImageData {
  final String asset;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  const _PrayerImageData({
    required this.asset,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });
}
