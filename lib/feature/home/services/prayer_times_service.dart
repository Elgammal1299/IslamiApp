import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';
import 'package:islami_app/feature/home/services/location_service.dart';

/// Encapsulates all Adhan logic: location, calculation method, madhab, etc.
class PrayerTimesService {
  final CalculationMethod calculationMethod;
  final Madhab madhab;
  final LocationService locationService;

  PrayerTimesService({
    this.calculationMethod = CalculationMethod.muslim_world_league,
    this.madhab = Madhab.shafi,
    required this.locationService,
  });

  /// Get current position using LocationService
  Future<Position> getCurrentPosition() async {
    return await locationService.initializeLocation();
  }

  Future<PrayerTimes> getTodayPrayerTimes() async {
    final Position position = await getCurrentPosition();
    return getPrayerTimesForDate(
      latitude: position.latitude,
      longitude: position.longitude,
      date: DateTime.now(),
    );
  }

  PrayerTimes getPrayerTimesForDate({
    required double latitude,
    required double longitude,
    required DateTime date,
  }) {
    final Coordinates coordinates = Coordinates(latitude, longitude);
    final DateComponents dateComponents = DateComponents.from(date);
    final CalculationParameters params =
        calculationMethod.getParameters()..madhab = madhab;

    return PrayerTimes(coordinates, dateComponents, params);
  }

  static const List<Prayer> displayPrayers = <Prayer>[
    Prayer.fajr,
    Prayer.sunrise,
    Prayer.dhuhr,
    Prayer.asr,
    Prayer.maghrib,
    Prayer.isha,
  ];

  Prayer currentPrayer(PrayerTimes times) => times.currentPrayer();

  Prayer nextPrayer(PrayerTimes times) => times.nextPrayer();

  DateTime? timeForPrayer(PrayerTimes times, Prayer prayer) =>
      times.timeForPrayer(prayer);

  Map<Prayer, DateTime> getNamedTimes(PrayerTimes times) {
    final Map<Prayer, DateTime> result = {};
    for (final Prayer p in displayPrayers) {
      final DateTime? t = times.timeForPrayer(p);
      if (t != null) result[p] = t;
    }
    return result;
  }
}

/// Shared provider for prayer times that can be used across multiple screens
class SharedPrayerTimesProvider extends ChangeNotifier {
  static SharedPrayerTimesProvider? _instance;
  static SharedPrayerTimesProvider get instance =>
      _instance ??= SharedPrayerTimesProvider._();

  SharedPrayerTimesProvider._();

  late PrayerTimesService _prayerService;
  late LocationService _locationService;

  void setLocationService(LocationService locationService) {
    _locationService = locationService;
    _prayerService = PrayerTimesService(locationService: _locationService);
  }

  void setPrayerTimesService(PrayerTimesService service) {
    _prayerService = service;
  }

  PrayerTimes? _todayTimes;
  Map<Prayer, DateTime> _namedTimes = {};
  Prayer? _currentPrayer;
  Prayer? _nextPrayer;
  Duration _countdown = Duration.zero;
  Timer? _timer;

  PrayerTimes? get todayTimes => _todayTimes;
  Map<Prayer, DateTime> get namedTimes => _namedTimes;
  Prayer? get currentPrayer => _currentPrayer;
  Prayer? get nextPrayer => _nextPrayer;
  Duration get countdown => _countdown;

  Future<void> initialize() async {
    await _loadPrayerTimes();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  Future<void> _loadPrayerTimes() async {
    try {
      final times = await _prayerService.getTodayPrayerTimes();
      _setTimes(times);
    } catch (e) {
      // Handle error silently
    }
  }

  void _setTimes(PrayerTimes times) {
    _todayTimes = times;
    _namedTimes = _prayerService.getNamedTimes(times);
    _refreshPrayers();
    notifyListeners();
  }

  void _refreshPrayers() {
    if (_todayTimes == null) return;

    final t = _todayTimes!;
    _currentPrayer = _prayerService.currentPrayer(t);
    _nextPrayer = _prayerService.nextPrayer(t);

    final DateTime? nextTime =
        _nextPrayer != null
            ? _prayerService.timeForPrayer(t, _nextPrayer!)
            : null;

    if (nextTime != null && nextTime.isAfter(DateTime.now())) {
      _countdown = nextTime.difference(DateTime.now());
    } else {
      _countdown = Duration.zero;
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateCountdown();
    });
  }

  void _updateCountdown() {
    if (_nextPrayer != null && _todayTimes != null) {
      final nextTime = _prayerService.timeForPrayer(_todayTimes!, _nextPrayer!);
      if (nextTime != null) {
        if (nextTime.isAfter(DateTime.now())) {
          _countdown = nextTime.difference(DateTime.now());
          notifyListeners();
        } else {
          _loadPrayerTimes();
        }
      }
    }
  }

  String getPrayerName(Prayer prayer) {
    switch (prayer) {
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

  String formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String formatCountdown() {
    final hours = _countdown.inHours.toString().padLeft(2, '0');
    final minutes = (_countdown.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_countdown.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  Future<void> refresh() async {
    await _loadPrayerTimes();
  }
}
