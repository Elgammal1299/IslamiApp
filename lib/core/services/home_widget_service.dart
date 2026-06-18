import 'package:adhan/adhan.dart';
import 'package:home_widget/home_widget.dart';
import 'package:islami_app/feature/home/services/prayer_times_service.dart';


class HomeWidgetService {
  static const String _groupId = 'group.com.islamic.wartaqi.app'; // Optional for Android, required for iOS
  static const String _androidWidgetName = 'widget.PrayerGlanceReceiver';

  static Future<void> updatePrayerTimesWidget({
    required PrayerTimes prayerTimes,
    required Prayer currentPrayer,
    required Prayer nextPrayer,
    required Duration countdown,
  }) async {
    final Map<String, dynamic> data = {
      'fajr': _formatTime(prayerTimes.fajr),
      'sunrise': _formatTime(prayerTimes.sunrise),
      'dhuhr': _formatTime(prayerTimes.dhuhr),
      'asr': _formatTime(prayerTimes.asr),
      'maghrib': _formatTime(prayerTimes.maghrib),
      'isha': _formatTime(prayerTimes.isha),
      'current_prayer_name': PrayerTimesService.getPrayerName(currentPrayer),
      'current_prayer_time': _formatTime(prayerTimes.timeForPrayer(currentPrayer)),
      'next_prayer_name': PrayerTimesService.getPrayerName(nextPrayer),
      'next_prayer_time': _formatTime(prayerTimes.timeForPrayer(nextPrayer)),
      'countdown': _formatDuration(countdown),
      'next_prayer_timestamp': (nextPrayer != Prayer.none 
          ? prayerTimes.timeForPrayer(nextPrayer)?.millisecondsSinceEpoch 
          : DateTime.now().add(countdown).millisecondsSinceEpoch) ?? 0,
    };

    for (var entry in data.entries) {
      await HomeWidget.saveWidgetData<String>(entry.key, entry.value.toString());
    }

    try {
      await HomeWidget.setAppGroupId(_groupId);
    } catch (_) {}

    await HomeWidget.updateWidget(
      name: _androidWidgetName,
      iOSName: 'PrayerWidget',
    );
  }

  static String _formatTime(DateTime? time) {
    if (time == null) return '--:--';
    // Convert to local time explicitly to match the app's formatTime method
    final local = time.isUtc ? time.toLocal() : time;
    final hour   = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
