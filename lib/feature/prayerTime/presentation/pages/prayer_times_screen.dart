import 'dart:async';
import 'package:adhan/adhan.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  late PrayerTimesService _prayerService;
  late final LocationService _locationService;
  late final SharedPreferences _prefs;
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
  int _lastLoadedDay = DateTime.now().day;
  DateTime? _tomorrowFajr;

  @override
  void initState() {
    super.initState();
    _locationService = sl<LocationService>();
    _prefs = sl<SharedPreferences>();
    _prayerService = PrayerTimesService(
      locationService: _locationService,
      calculationMethod: PrayerSettings.loadMethod(_prefs),
      madhab: PrayerSettings.loadMadhab(_prefs),
    );
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
      _lastLoadedDay = DateTime.now().day;
      try {
        _tomorrowFajr = await _prayerService.getTomorrowFajrTime();
      } catch (_) {}
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

    // Detect day change and reload
    final today = DateTime.now().day;
    if (today != _lastLoadedDay) {
      _load();
      return;
    }

    final PrayerTimes t = todayTimes.value!;
    currentPrayer.value = _prayerService.currentPrayer(t);
    nextPrayer.value = _prayerService.nextPrayer(t);

    final DateTime? nextTime =
        (nextPrayer.value != null && nextPrayer.value != Prayer.none)
            ? _prayerService.timeForPrayer(t, nextPrayer.value!)
            : null;

    if (nextTime != null && nextTime.isAfter(DateTime.now())) {
      countdown.value = nextTime.difference(DateTime.now());
    } else if (_tomorrowFajr != null && _tomorrowFajr!.isAfter(DateTime.now())) {
      // After Isha - countdown to tomorrow's Fajr
      countdown.value = _tomorrowFajr!.difference(DateTime.now());
    } else {
      countdown.value = Duration.zero;
    }
  }

  Future<void> _scheduleTodayAndTomorrow() async {
    try {
      final pos =
          currentLocation.value ??
          _locationService.getStoredLocation() ??
          await _prayerService.getCurrentPosition();
      final params = _prayerService.calculationMethod.getParameters()
        ..madhab = _prayerService.madhab;
      await _notificationService.scheduleMultipleDays(
        days: 7,
        latitude: pos.latitude,
        longitude: pos.longitude,
        params: params,
        prayerName: _displayName,
        preReminderEnabled: preReminderEnabled.value,
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
    if (p == Prayer.none) return 'انتهت الصلوات';
    return PrayerTimesService.getPrayerName(p);
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

  void _showSettingsSheet() {
    var selectedMethod = _prayerService.calculationMethod;
    var selectedMadhab = _prayerService.madhab;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.6,
              maxChildSize: 0.85,
              builder: (ctx, scrollController) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      const Center(
                        child: Text(
                          'إعدادات مواقيت الصلاة',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'طريقة الحساب',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...PrayerSettings.availableMethods.map((method) {
                        final isSelected = method == selectedMethod;
                        return ListTile(
                          dense: true,
                          title: Text(
                            PrayerSettings.methodDisplayName(method),
                            style: TextStyle(
                              color: isSelected ? Colors.amber : Colors.white,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check, color: Colors.amber)
                              : null,
                          onTap: () {
                            setSheetState(() => selectedMethod = method);
                          },
                        );
                      }),
                      const Divider(color: Colors.white24),
                      const SizedBox(height: 8),
                      const Text(
                        'مذهب حساب العصر',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...Madhab.values.map((madhab) {
                        final isSelected = madhab == selectedMadhab;
                        return ListTile(
                          dense: true,
                          title: Text(
                            PrayerSettings.madhabDisplayName(madhab),
                            style: TextStyle(
                              color: isSelected ? Colors.amber : Colors.white,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check, color: Colors.amber)
                              : null,
                          onTap: () {
                            setSheetState(() => selectedMadhab = madhab);
                          },
                        );
                      }),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () async {
                          final navigator = Navigator.of(ctx);
                          await PrayerSettings.saveMethod(
                            _prefs,
                            selectedMethod,
                          );
                          await PrayerSettings.saveMadhab(
                            _prefs,
                            selectedMadhab,
                          );
                          _prayerService = PrayerTimesService(
                            locationService: _locationService,
                            calculationMethod: selectedMethod,
                            madhab: selectedMadhab,
                          );
                          navigator.pop();
                          _load();
                        },
                        child: const Text('حفظ'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
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
                      decoration: BoxDecoration(
                        gradient: _getGradientForPrayer(current),
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return ListView(
                            padding: EdgeInsets.zero,
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [

                                    Stack(
                                      children: [
                                        ValueListenableBuilder<String?>(
                                          valueListenable: locationName,
                                          builder: (context, locName, _) {
                                            return ValueListenableBuilder<bool>(
                                              valueListenable: isUpdatingLocation,
                                              builder: (context, updating, _) {
                                                return LocationCardWidget(
                                                  locationName: locName,
                                                  isUpdating: updating,
                                                  onUpdate: _updateLocation,
                                                );
                                              },
                                            );
                                          },
                                        ),
                                        Positioned(
                                          left: 8,
                                          top: 8,
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.settings,
                                              color: Colors.white70,
                                              size: 22,
                                            ),
                                            tooltip: 'إعدادات الحساب',
                                            onPressed: _showSettingsSheet,
                                          ),
                                        ),
                                      ],
                                    ),

                                    AzanDisplay(
                                      times: times,
                                      currentPrayer: current,
                                    ),

                                    Image.asset(
                                      "assets/images/Vector.png",
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      color: const Color(0xff0C222B),
                                    ),

                                    ColoredBox(
                                      color: const Color(0xff0C222B),
                                      child: ValueListenableBuilder<Map<Prayer, DateTime>>(
                                        valueListenable: namedTimes,
                                        builder: (context, times, _) {
                                          if (times.isEmpty) return const SizedBox();

                                          // Sort: current prayer first, then remaining in chronological order
                                          final entries = times.entries.toList();
                                          final currentIdx = entries.indexWhere(
                                            (e) => e.key == current,
                                          );

                                          List<MapEntry<Prayer, DateTime>> sorted;
                                          if (currentIdx >= 0) {
                                            sorted = [
                                              entries[currentIdx],
                                              ...entries.sublist(currentIdx + 1),
                                              ...entries.sublist(0, currentIdx),
                                            ];
                                          } else {
                                            sorted = entries;
                                          }

                                          return Column(
                                            children: sorted.map((e) {
                                              return PrayerTileWidget(
                                                prayer: e.key,
                                                time: e.value,
                                                isCurrent: e.key == current,
                                                displayName: _displayName,
                                                format: _format,
                                                iconFor: _iconFor,
                                              );
                                            }).toList(),
                                          );
                                        },
                                      ),
                                    ),
                                   
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
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

}
