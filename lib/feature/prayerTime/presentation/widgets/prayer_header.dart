

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';

class PrayerHeaderWidget extends StatelessWidget {
  final Prayer? currentPrayer;
  final Prayer? nextPrayer;
  final Duration countdown;
  final String Function(Prayer) displayName;

  const PrayerHeaderWidget({
    super.key,
    required this.currentPrayer,
    required this.nextPrayer,
    required this.countdown,
    required this.displayName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String hh = countdown.inHours.toString().padLeft(2, '0');
    final String mm = (countdown.inMinutes % 60).toString().padLeft(2, '0');
    final String ss = (countdown.inSeconds % 60).toString().padLeft(2, '0');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الصلاة الحالية: ${currentPrayer != null ? displayName(currentPrayer!) : '-'}',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              nextPrayer == null
                  ? '—'
                  : 'الصلاة التالية: ${displayName(nextPrayer!)} بعد $hh:$mm:$ss',
              style: theme.textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}