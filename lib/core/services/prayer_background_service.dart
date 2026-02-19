import 'dart:developer';

import 'package:adhan/adhan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:islami_app/feature/home/services/notification_service.dart';
import 'package:islami_app/feature/home/services/prayer_times_service.dart';

const String prayerRescheduleTask = 'com.islamiapp.prayerReschedule';
const int scheduleDaysAhead = 7;

/// Top-level callback for WorkManager. Must be a top-level or static function.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      if (taskName == prayerRescheduleTask || taskName == Workmanager.iOSBackgroundTask) {
        await _rescheduleNotifications();
      }
      return true;
    } catch (e) {
      log('WorkManager task failed: $e');
      return false;
    }
  });
}

/// Reschedule prayer notifications for the next [scheduleDaysAhead] days.
/// Works independently of the app UI - reads location from SharedPreferences.
Future<void> _rescheduleNotifications() async {
  final prefs = await SharedPreferences.getInstance();
  final latitude = prefs.getDouble('location_latitude');
  final longitude = prefs.getDouble('location_longitude');

  if (latitude == null || longitude == null) {
    log('No stored location, skipping prayer notification reschedule');
    return;
  }

  final calcMethod = PrayerSettings.loadMethod(prefs);
  final madhab = PrayerSettings.loadMadhab(prefs);
  final params = calcMethod.getParameters()..madhab = madhab;

  final notificationService = PrayerNotificationService();
  await notificationService.init();
  await notificationService.scheduleMultipleDays(
    days: scheduleDaysAhead,
    latitude: latitude,
    longitude: longitude,
    params: params,
    prayerName: PrayerTimesService.getPrayerName,
  );

  log('Prayer notifications rescheduled for $scheduleDaysAhead days');
}

/// Initialize WorkManager and register the periodic background task.
Future<void> initPrayerBackgroundService() async {
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

  // Register a periodic task that runs approximately every 12 hours.
  // This ensures notifications are always scheduled even if user doesn't open the app.
  await Workmanager().registerPeriodicTask(
    prayerRescheduleTask,
    prayerRescheduleTask,
    frequency: const Duration(hours: 12),
    constraints: Constraints(
      networkType: NetworkType.notRequired,
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresDeviceIdle: false,
      requiresStorageNotLow: false,
    ),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
    backoffPolicy: BackoffPolicy.linear,
    backoffPolicyDelay: const Duration(minutes: 15),
  );
}
