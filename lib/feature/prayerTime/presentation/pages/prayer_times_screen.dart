import 'dart:async';
import 'package:adhan/adhan.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:islami_app/core/services/setup_service_locator.dart';
import 'package:islami_app/feature/home/services/location_service.dart';
import 'package:islami_app/feature/home/services/notification_service.dart';
import 'package:islami_app/feature/home/services/prayer_times_service.dart';
import 'package:islami_app/feature/prayerTime/presentation/widgets/location_card.dart';
import 'package:islami_app/feature/prayerTime/presentation/widgets/prayer_header.dart';
import 'package:islami_app/feature/prayerTime/presentation/widgets/prayer_tile.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  late final PrayerTimesService _prayerService;
  late final LocationService _locationService;
  final PrayerNotificationService _notificationService =
      PrayerNotificationService();

  final ValueNotifier<PrayerTimes?> todayTimes = ValueNotifier(null);
  final ValueNotifier<Map<Prayer, DateTime>> namedTimes = ValueNotifier({});
  final ValueNotifier<Prayer?> currentPrayer = ValueNotifier(null);
  final ValueNotifier<Prayer?> nextPrayer = ValueNotifier(null);
  final ValueNotifier<Duration> countdown = ValueNotifier(Duration.zero);
  final ValueNotifier<bool> preReminderEnabled = ValueNotifier(true);
  final ValueNotifier<Position?> currentLocation = ValueNotifier(null);
  final ValueNotifier<String?> locationName = ValueNotifier(null);
  final ValueNotifier<bool> isUpdatingLocation = ValueNotifier(false);

  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _locationService = sl<LocationService>();
    _prayerService = PrayerTimesService(locationService: _locationService);
    _load();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _ticker = null;
    todayTimes.dispose();
    namedTimes.dispose();
    currentPrayer.dispose();
    nextPrayer.dispose();
    countdown.dispose();
    preReminderEnabled.dispose();
    currentLocation.dispose();
    locationName.dispose();
    isUpdatingLocation.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      await _notificationService.init();
      final PrayerTimes times = await _prayerService.getTodayPrayerTimes();

      final position = _locationService.getStoredLocation();
      if (position != null) currentLocation.value = position;

      final storedLocationName = _locationService.getStoredLocationName();
      if (storedLocationName != null) locationName.value = storedLocationName;

      _setTimes(times);
      await _scheduleTodayAndTomorrow();
      _startTicker();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
      }
    }
  }

  Future<void> _updateLocation() async {
    if (isUpdatingLocation.value) return;
    try {
      isUpdatingLocation.value = true;
      final position = await _locationService.updateLocation();
      currentLocation.value = position;

      final updatedLocationName = _locationService.getStoredLocationName();
      if (updatedLocationName != null) locationName.value = updatedLocationName;

      await _load();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تحديث الموقع بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on StateError catch (e) {
      if (mounted) {
        String errorMessage = 'خطأ في تحديث الموقع';
        if (e.message.contains('disabled')) {
          errorMessage = 'خدمة الموقع غير مفعلة. يرجى تفعيلها من الإعدادات';
        } else if (e.message.contains('denied')) {
          errorMessage = 'لا توجد أذونات للوصول للموقع. يرجى السماح بالوصول';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ غير متوقع: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      isUpdatingLocation.value = false;
    }
  }

  void _setTimes(PrayerTimes times) {
    todayTimes.value = times;
    namedTimes.value = _prayerService.getNamedTimes(times);
    _refreshPrayers();
  }

  void _refreshPrayers() {
    if (!mounted || todayTimes.value == null) return;

    final PrayerTimes t = todayTimes.value!;
    currentPrayer.value = _prayerService.currentPrayer(t);
    nextPrayer.value = _prayerService.nextPrayer(t);

    final DateTime? nextTime =
        nextPrayer.value != null
            ? _prayerService.timeForPrayer(t, nextPrayer.value!)
            : null;

    if (nextTime != null && nextTime.isAfter(DateTime.now())) {
      countdown.value = nextTime.difference(DateTime.now());
    } else {
      countdown.value = Duration.zero;
    }
  }

  Future<void> _scheduleTodayAndTomorrow() async {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime tomorrow = today.add(const Duration(days: 1));

    await _notificationService.scheduleForDay(
      prayerTimes: namedTimes.value,
      day: today,
      preReminderEnabled: preReminderEnabled.value,
      prayerName: _displayName,
    );

    try {
      final pos = await _prayerService.getCurrentPosition();
      final tmrTimes = _prayerService.getPrayerTimesForDate(
        latitude: pos.latitude,
        longitude: pos.longitude,
        date: tomorrow,
      );
      final tmrNamed = _prayerService.getNamedTimes(tmrTimes);
      await _notificationService.scheduleForDay(
        prayerTimes: tmrNamed,
        day: tomorrow,
        preReminderEnabled: preReminderEnabled.value,
        prayerName: _displayName,
      );
    } catch (e) {
      if (kDebugMode) debugPrint("Tomorrow scheduling failed: $e");
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    if (mounted) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) _refreshPrayers();
      });
    }
  }

  String _displayName(Prayer p) {
    switch (p) {
      case Prayer.fajr:
        return 'الفجر';
      case Prayer.sunrise:
        return 'الشروق';
      case Prayer.dhuhr:
        return 'الظهر';
      case Prayer.asr:
        return 'العصر';
      case Prayer.maghrib:
        return 'المغرب';
      case Prayer.isha:
        return 'العشاء';
      case Prayer.none:
        return 'انتهت الصلوات';
    }
  }

  String _format(DateTime dt) => DateFormat('h:mm a', 'ar').format(dt);

  IconData _iconFor(Prayer p) {
    switch (p) {
      case Prayer.fajr:
        return Icons.bedtime;
      case Prayer.sunrise:
        return Icons.wb_sunny_outlined;
      case Prayer.dhuhr:
        return Icons.wb_sunny;
      case Prayer.asr:
        return Icons.cloud_queue;
      case Prayer.maghrib:
        return Icons.wb_twilight;
      case Prayer.isha:
        return Icons.nights_stay;
      case Prayer.none:
        return Icons.more_horiz;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('مواقيت الصلاة')),
      body: ValueListenableBuilder<PrayerTimes?>(
        valueListenable: todayTimes,
        builder: (context, times, _) {
          if (times == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: _load,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                LocationCardWidget(
                  locationName: locationName.value,
                  isUpdating: isUpdatingLocation.value,
                  onUpdate: _updateLocation,
                ),
                const SizedBox(height: 16),
                PrayerHeaderWidget(
                  currentPrayer: currentPrayer.value,
                  nextPrayer: nextPrayer.value,
                  countdown: countdown.value,
                  displayName: _displayName,
                ),
                const SizedBox(height: 16),
                ...namedTimes.value.entries.map((e) {
                  return PrayerTileWidget(
                    prayer: e.key,
                    time: e.value,
                    isCurrent: currentPrayer.value == e.key,
                    displayName: _displayName,
                    format: _format,
                    iconFor: _iconFor,
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}

//
