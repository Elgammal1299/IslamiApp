import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';

class PrayerHeaderWidget extends StatefulWidget {
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
  State<PrayerHeaderWidget> createState() => _PrayerHeaderWidgetState();
}

class _PrayerHeaderWidgetState extends State<PrayerHeaderWidget> {
  late String hh, mm, ss;

  @override
  void initState() {
    hh = widget.countdown.inHours.toString().padLeft(2, '0');
    mm = (widget.countdown.inMinutes % 60).toString().padLeft(2, '0');
    ss = (widget.countdown.inSeconds % 60).toString().padLeft(2, '0');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الصلاة الحالية: ${widget.currentPrayer != null ? widget.displayName(widget.currentPrayer!) : '-'}',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              widget.nextPrayer == null
                  ? '—'
                  : 'الصلاة التالية: ${widget.displayName(widget.nextPrayer!)} بعد $hh:$mm:$ss',
              style: theme.textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}
