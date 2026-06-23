import 'package:adhan/adhan.dart';
import 'package:home_widget/home_widget.dart';
import 'package:islami_app/feature/home/services/prayer_times_service.dart';

/// Service مسؤول عن تحديث الـ Home Screen Widget ببيانات مواقيت الصلاة.
///
/// ## التصميم الجديد (بعد الإصلاح):
/// بدلاً من إرسال countdown string جاهز (يتوقف لما Flutter يقفل)،
/// نُرسل `next_prayer_timestamp` كـ epoch milliseconds،
/// والـ PrayerWidget.kt يحسب الـ countdown نفسه بـ Kotlin — بدون Flutter.
///
/// الـ AlarmManager في Kotlin يُحدِّث الـ widget كل دقيقة تلقائياً.
class HomeWidgetService {
  static const String _groupId =
      'group.com.islamic.wartaqi.app'; // iOS فقط
  static const String _androidWidgetName = 'widget.PrayerGlanceReceiver';

  /// يُحدِّث بيانات الـ widget.
  /// يُستدعى من:
  ///   - PrayerTimesCubit عند تغيير الصلاة الحالية/القادمة
  ///   - عند فتح التطبيق أو الرجوع من الخلفية
  static Future<void> updatePrayerTimesWidget({
    required PrayerTimes prayerTimes,
    required Prayer currentPrayer,
    required Prayer nextPrayer,
    required Duration countdown,
  }) async {
    // ── حساب timestamp الصلاة التالية ────────────────────────────────────
    // هذا هو جوهر الإصلاح: Kotlin يحسب الـ countdown من هذا الـ timestamp
    final DateTime? nextPrayerDateTime = nextPrayer != Prayer.none
        ? prayerTimes.timeForPrayer(nextPrayer)
        : DateTime.now().add(countdown);

    final int nextPrayerTimestampMs =
        nextPrayerDateTime?.millisecondsSinceEpoch ?? 0;

    // ── البيانات المرسلة للـ widget ───────────────────────────────────────
    final Map<String, dynamic> data = {
      // أوقات الصلوات (ثابتة طوال اليوم)
      'fajr': _formatTime(prayerTimes.fajr),
      'sunrise': _formatTime(prayerTimes.sunrise),
      'dhuhr': _formatTime(prayerTimes.dhuhr),
      'asr': _formatTime(prayerTimes.asr),
      'maghrib': _formatTime(prayerTimes.maghrib),
      'isha': _formatTime(prayerTimes.isha),

      // الصلاة الحالية
      'current_prayer_name':
          PrayerTimesService.getPrayerName(currentPrayer),
      'current_prayer_time':
          _formatTime(prayerTimes.timeForPrayer(currentPrayer)),

      // الصلاة التالية
      'next_prayer_name': PrayerTimesService.getPrayerName(nextPrayer),
      'next_prayer_time':
          _formatTime(prayerTimes.timeForPrayer(nextPrayer)),

      // ─── الإصلاح الجوهري ───────────────────────────────────────────────
      // نُرسل الـ timestamp بدلاً من countdown string
      // الـ PrayerWidget.kt يحسب الـ countdown من هذا الـ timestamp
      // ويتحدث كل دقيقة عبر AlarmManager بدون الحاجة لـ Flutter
      'next_prayer_timestamp': nextPrayerTimestampMs,

      // نبقي countdown string كـ fallback للعرض الأول قبل أول alarm
      'countdown': _formatDuration(countdown),
    };

    // ── حفظ البيانات في SharedPreferences (مشتركة مع الـ native widget) ──
    for (final entry in data.entries) {
      await HomeWidget.saveWidgetData<String>(
        entry.key,
        entry.value.toString(),
      );
    }

    // ── إعداد الـ App Group (iOS) ─────────────────────────────────────────
    try {
      await HomeWidget.setAppGroupId(_groupId);
    } catch (_) {
      // Android لا يحتاج App Group، نتجاهل الخطأ
    }

    // ── إطلاق تحديث فوري للـ widget ──────────────────────────────────────
    await HomeWidget.updateWidget(
      name: _androidWidgetName,
      iOSName: 'PrayerWidget',
    );
  }

  // ── Helper: تنسيق الوقت ────────────────────────────────────────────────
  static String _formatTime(DateTime? time) {
    if (time == null) return '--:--';
    final local = time.isUtc ? time.toLocal() : time;
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // ── Helper: تنسيق المدة (backup للعرض الأول) ──────────────────────────
  static String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(duration.inHours)}'
        ':${twoDigits(duration.inMinutes.remainder(60))}'
        ':${twoDigits(duration.inSeconds.remainder(60))}';
  }
}