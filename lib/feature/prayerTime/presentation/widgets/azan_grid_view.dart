import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:islami_app/feature/prayerTime/presentation/widgets/azan_item.dart';

class AzanGrid extends StatelessWidget {
  const AzanGrid({super.key, required this.todayTimes});

  final PrayerTimes todayTimes;

  @override
  Widget build(BuildContext context) {
    final prayers = [
      {'name': 'الفجر', 'time': todayTimes.fajr},
      {'name': 'الشروق', 'time': todayTimes.sunrise},
      {'name': 'الظهر', 'time': todayTimes.dhuhr},
      {'name': 'العصر', 'time': todayTimes.asr},
      {'name': 'المغرب', 'time': todayTimes.maghrib},
      {'name': 'العشاء', 'time': todayTimes.isha},
    ];

    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: prayers
          .map(
            (p) => AzanItem(
              name: p['name'] as String,
              time: p['time'] as DateTime,
            ),
          )
          .toList(),
    );
  }
}
