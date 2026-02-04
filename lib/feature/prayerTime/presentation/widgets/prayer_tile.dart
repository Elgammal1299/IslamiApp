import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';

class PrayerTileWidget extends StatelessWidget {
  final Prayer prayer;
  final DateTime time;
  final bool isCurrent;
  final String Function(Prayer) displayName;
  final String Function(DateTime) format;
  final IconData Function(Prayer) iconFor;

  const PrayerTileWidget({
    super.key,
    required this.prayer,
    required this.time,
    required this.isCurrent,
    required this.displayName,
    required this.format,
    required this.iconFor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: isCurrent ? 8 : 6),
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: isCurrent ? 16 : 12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isCurrent
                  ? Colors.white.withValues(alpha: 0.8)
                  : Colors.white.withValues(alpha: 0.2),
          width: isCurrent ? 2 : 1.5,
        ),
        color:
            isCurrent
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.transparent,

        boxShadow:
            isCurrent
                ? [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
                : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // اسم الصلاة
          Expanded(
            flex: 2,
            child: Text(
              displayName(prayer),
              style: TextStyle(
                fontSize: isCurrent ? 18 : 16,
                fontWeight:
                    isCurrent ? FontWeight.bold : FontWeight.w400, // bold
                color:
                    isCurrent
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.7),
                letterSpacing: 0.5,
              ),
            ),
          ),

          // الوقت المتبقي
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'متبقي : ',
                  style: TextStyle(
                    fontSize: isCurrent ? 15 : 14,
                    color:
                        isCurrent
                            ? Colors.white.withValues(alpha: 0.9)
                            : Colors.white.withValues(alpha: 0.5),
                  ),
                ),
                Text(
                  _getTimeLeft(time),
                  style: TextStyle(
                    fontSize: isCurrent ? 15 : 14,
                    fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
                    color:
                        isCurrent
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),

          // أيقونة الجرس
          Icon(
            Icons.notifications_outlined,
            size: isCurrent ? 24 : 20,
            color:
                isCurrent ? Colors.white : Colors.white.withValues(alpha: 0.4),
          ),
        ],
      ),
    );
  }

  String _getTimeLeft(DateTime prayerTime) {
    final now = DateTime.now();
    Duration diff = prayerTime.difference(now);

    if (diff.isNegative) {
      // يعني الوقت فات
      return 'تم الأذان';
    }

    final hours = diff.inHours;
    final minutes = diff.inMinutes.remainder(60);

    if (hours == 0 && minutes == 0) {
      return 'الآن';
    } else if (hours == 0) {
      return '$minutes دقيقة';
    } else if (minutes == 0) {
      return '$hours ساعة';
    } else {
      return '$hours ساعة و $minutes دقيقة';
    }
  }
}
