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
import 'package:islami_app/core/widget/location_permission_gate.dart';
import 'package:islami_app/feature/prayerTime/presentation/widgets/azan_display.dart';
import 'package:islami_app/feature/prayerTime/presentation/widgets/location_card.dart';
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
  final ValueNotifier<bool> needsLocationSetup = ValueNotifier(false);

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
    needsLocationSetup.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      await _notificationService.init();
      final PrayerTimes times = await _prayerService.getTodayPrayerTimes();

      needsLocationSetup.value = false;

      final position = _locationService.getStoredLocation();
      if (position != null) currentLocation.value = position;

      final storedLocationName = _locationService.getStoredLocationName();
      if (storedLocationName != null) locationName.value = storedLocationName;

      _setTimes(times);
      await _scheduleTodayAndTomorrow();
      _startTicker();
    } catch (e) {
      // If no stored location, show first-time permission gate
      if (!_locationService.hasStoredLocation()) {
        needsLocationSetup.value = true;
      } else if (mounted) {
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
    try {
      final pos = await _prayerService.getCurrentPosition();
      final params = CalculationMethod.muslim_world_league.getParameters()
        ..madhab = Madhab.shafi;
      await _notificationService.scheduleMultipleDays(
        days: 7,
        latitude: pos.latitude,
        longitude: pos.longitude,
        params: params,
        prayerName: _displayName,
      );
    } catch (e) {
      if (kDebugMode) debugPrint("Multi-day scheduling failed: $e");
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

  // Function ترجع الـ gradient حسب الصلاة
  LinearGradient _getGradientForPrayer(Prayer? prayer) {
    if (prayer == null || prayer == Prayer.none) {
      // Default - بنفسجي غامق
      return const LinearGradient(
        begin: Alignment(0.50, 0.00),
        end: Alignment(0.50, 1.00),
        colors: [Color(0xFF22166D), Color(0xFF22166D), Color(0xCE22166D)],
      );
    }

    switch (prayer) {
      case Prayer.fajr: // الفجر
      case Prayer.isha: // العشاء
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF23176D),
            const Color(0xFF23176D),
            const Color(0xFF23176D).withValues(alpha: 0.81),
          ],
          stops: [0.0, 0.85, 1.0],
        );
      case Prayer.sunrise: // الشروق
      case Prayer.dhuhr: // الظهر
      case Prayer.asr: // العصر
        return const LinearGradient(
          begin: Alignment(0.50, 0.00),
          end: Alignment(0.50, 1.00),
          colors: [Color(0xFF0694D5), Colors.white],
        );

      case Prayer.maghrib: // المغرب
        return const LinearGradient(
          begin: Alignment(0.50, 0.00),
          end: Alignment(0.50, 1.00),
          colors: [
            Color(0xFF8B0E61),
            Color(0xFF8B0D4A),
            Color(0xF7C64888),
            Color(0xE5DF6299),
            Color(0xCE8B0E61),
          ],
        );

      case Prayer.none:
        return const LinearGradient(
          begin: Alignment(0.50, 0.00),
          end: Alignment(0.50, 1.00),
          colors: [Color(0xFF22166D), Color(0xFF22166D), Color(0xCE22166D)],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<bool>(
        valueListenable: needsLocationSetup,
        builder: (context, needsSetup, _) {
          if (needsSetup) {
            // First time only – no stored location yet
            return LocationPermissionGate(
              onGrantedOnce: () async {
                try {
                  await _locationService.updateLocation();
                  await _load();
                } catch (_) {}
              },
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          return ValueListenableBuilder<PrayerTimes?>(
            valueListenable: todayTimes,
            builder: (context, times, _) {
              if (times == null) {
                return const Center(child: CircularProgressIndicator());
              }
              return RefreshIndicator(
                onRefresh: _load,
                child: ValueListenableBuilder<Prayer?>(
                  valueListenable: currentPrayer,
                  builder: (context, current, _) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: double.infinity,
                      height: double.infinity,
                      decoration: ShapeDecoration(
                        gradient: _getGradientForPrayer(current),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: ListView(
                        children: [
                          LocationCardWidget(
                            locationName: locationName.value,
                            isUpdating: isUpdatingLocation.value,
                            onUpdate: _updateLocation,
                          ),

                          AzanDisplay(times: times, currentPrayer: current),

                          Image.asset(
                            "assets/images/Vector.png",
                            width: double.infinity,
                            fit: BoxFit.cover,
                            color: const Color(0xff0C222B),
                          ),

                          ColoredBox(
                            color: const Color(0xff0C222B),
                            child: ListView(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: () {
                                final entries =
                                    namedTimes.value.entries.toList();

                                entries.sort((a, b) {
                                  if (a.key == currentPrayer.value) return -1;
                                  if (b.key == currentPrayer.value) return 1;
                                  return 0;
                                });
                                final current = entries.firstWhere(
                                  (e) => e.key == currentPrayer.value,
                                  orElse: () => entries.first,
                                );

                                return entries.take(3).map((e) {
                                  return PrayerTileWidget(
                                    prayer: e.key,
                                    time: e.value,
                                    isCurrent: current.key == e.key,
                                    displayName: _displayName,
                                    format: _format,
                                    iconFor: _iconFor,
                                  );
                                }).toList();
                              }(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Stack azanDisplay(PrayerTimes times, Prayer? currentPrayer) {
  //   final imageData = _getImageForPrayerPosition(currentPrayer);
  //   log('Current Prayer: $currentPrayer, Image: ${imageData.asset}');

  //   return Stack(
  //     clipBehavior: Clip.none,
  //     children: [
  //       Prayer.maghrib == currentPrayer
  //           ? Positioned(
  //             top: -25,

  //             // right: 140,
  //             child: Opacity(
  //               opacity: .5,
  //               child: Image.asset(
  //                 "assets/images/m3rep.png",
  //                 color: Colors.white.withValues(alpha: .2),

  //                 fit: BoxFit.contain,
  //               ),
  //             ),
  //           )
  //           : const SizedBox(),
  //       Positioned(
  //         top: imageData.top,
  //         bottom: imageData.bottom,
  //         left: imageData.left,
  //         right: imageData.right,
  //         child: Opacity(
  //           opacity: .5,
  //           child: Image.asset(imageData.asset, fit: BoxFit.contain),
  //         ),
  //       ),
  //       AzanGrid(todayTimes: times),
  //     ],
  //   );
  // }

  // _PrayerImageData _getImageForPrayerPosition(Prayer? prayer) {
  //   switch (prayer) {
  //     case Prayer.fajr:
  //       return const _PrayerImageData(asset: "assets/images/stars.png", top: 0);
  //     case Prayer.sunrise:
  //       return const _PrayerImageData(
  //         asset: "assets/images/Sun.png",

  //         bottom: -150,

  //         left: 5,
  //       );
  //     case Prayer.dhuhr:
  //       return const _PrayerImageData(
  //         asset: "assets/images/Sun.png",
  //         top: -23,
  //         right: 140,
  //       );
  //     case Prayer.asr:
  //       return const _PrayerImageData(
  //         asset: "assets/images/Sun.png",
  //         bottom: -60,

  //         right: 5,
  //       );
  //     case Prayer.maghrib:
  //       return const _PrayerImageData(
  //         asset: "assets/images/Sun.png",
  //         bottom: -180,

  //         right: 5,
  //       );
  //     case Prayer.isha:
  //       return const _PrayerImageData(
  //         asset: "assets/images/moon.png",
  //         bottom: -160,
  //       );
  //     default:
  //       return const _PrayerImageData(
  //         asset: "assets/images/stars.png",
  //         top: -10,
  //       );
  //   }
  // }
}
