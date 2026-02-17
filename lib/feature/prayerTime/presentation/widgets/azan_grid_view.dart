import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:islami_app/feature/prayerTime/presentation/widgets/azan_item.dart';

class AzanGrid extends StatefulWidget {
  const AzanGrid({super.key, required this.todayTimes});

  final PrayerTimes todayTimes;

  @override
  State<AzanGrid> createState() => _AzanGridState();
}

class _AzanGridState extends State<AzanGrid> {
  late List<Map<String, Object>> prayers;

  @override
  void initState() {
    prayers = [
      {'name': 'الفجر', 'time': widget.todayTimes.fajr, 'prayer': Prayer.fajr},
      {
        'name': 'الشروق',
        'time': widget.todayTimes.sunrise,
        'prayer': Prayer.sunrise,
      },
      {
        'name': 'الظهر',
        'time': widget.todayTimes.dhuhr,
        'prayer': Prayer.dhuhr,
      },
      {'name': 'العصر', 'time': widget.todayTimes.asr, 'prayer': Prayer.asr},
      {
        'name': 'المغرب',
        'time': widget.todayTimes.maghrib,
        'prayer': Prayer.maghrib,
      },
      {'name': 'العشاء', 'time': widget.todayTimes.isha, 'prayer': Prayer.isha},
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children:
          prayers
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
