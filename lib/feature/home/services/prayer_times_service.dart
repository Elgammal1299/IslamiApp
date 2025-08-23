import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';

/// Encapsulates all Adhan logic: location, calculation method, madhab, etc.
class PrayerTimesService {
  final CalculationMethod calculationMethod;
  final Madhab madhab;

  PrayerTimesService({
    this.calculationMethod = CalculationMethod.muslim_world_league,
    this.madhab = Madhab.shafi,
  });

  /// Requests location permission if needed and returns current [Position].
  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw StateError('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      throw StateError('Location permissions are denied');
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Exposes current position for callers that need to compute times
  /// for dates other than today using the same coordinates.
  Future<Position> getCurrentPosition() => _getCurrentPosition();

  /// Returns today's [PrayerTimes] for the user's current location.
  Future<PrayerTimes> getTodayPrayerTimes() async {
    final Position position = await _getCurrentPosition();
    return getPrayerTimesForDate(
      latitude: position.latitude,
      longitude: position.longitude,
      date: DateTime.now(),
    );
  }

  /// Returns [PrayerTimes] for the given date and location.
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

  /// Ordered list of the six main prayers we display/schedule.
  static const List<Prayer> displayPrayers = <Prayer>[
    Prayer.fajr,
    Prayer.sunrise,
    Prayer.dhuhr,
    Prayer.asr,
    Prayer.maghrib,
    Prayer.isha,
  ];

  /// Returns the current prayer enum for given [PrayerTimes].
  Prayer currentPrayer(PrayerTimes times) => times.currentPrayer();

  /// Returns the next prayer enum for given [PrayerTimes].
  Prayer nextPrayer(PrayerTimes times) => times.nextPrayer();

  /// Returns the [DateTime] for a specific [Prayer].
  DateTime? timeForPrayer(PrayerTimes times, Prayer prayer) =>
      times.timeForPrayer(prayer);

  /// Returns a map of prayer names to times for rendering.
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

  final PrayerTimesService _prayerService = PrayerTimesService();

  PrayerTimes? _todayTimes;
  Map<Prayer, DateTime> _namedTimes = {};
  Prayer? _currentPrayer;
  Prayer? _nextPrayer;
  Duration _countdown = Duration.zero;
  Timer? _timer;

  // Getters
  PrayerTimes? get todayTimes => _todayTimes;
  Map<Prayer, DateTime> get namedTimes => _namedTimes;
  Prayer? get currentPrayer => _currentPrayer;
  Prayer? get nextPrayer => _nextPrayer;
  Duration get countdown => _countdown;

  /// Initialize and start the provider
  Future<void> initialize() async {
    await _loadPrayerTimes();
    _startTimer();
  }

  /// Dispose the provider and clean up resources
  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  /// Load prayer times for today
  Future<void> _loadPrayerTimes() async {
    try {
      final times = await _prayerService.getTodayPrayerTimes();
      _setTimes(times);
    } catch (e) {
      // Handle error silently
    }
  }

  /// Set the prayer times and calculate current/next prayers
  void _setTimes(PrayerTimes times) {
    _todayTimes = times;

    // Apply summer time offset
    _namedTimes = _prayerService.getNamedTimes(times);

    _refreshPrayers();
    notifyListeners();
  }

  /// Apply time offset to prayer times
 
  /// Refresh current and next prayer information
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

  /// Start the countdown timer
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateCountdown();
    });
  }

  /// Update the countdown timer
  void _updateCountdown() {
    if (_nextPrayer != null && _todayTimes != null) {
      final nextTime = _prayerService.timeForPrayer(_todayTimes!, _nextPrayer!);
      if (nextTime != null) {
        final adjustedTime = nextTime;

        if (adjustedTime.isAfter(DateTime.now())) {
          _countdown = adjustedTime.difference(DateTime.now());
          notifyListeners();
        } else {
          // Prayer time has passed, reload to get next prayer
          _loadPrayerTimes();
        }
      }
    }
  }

  /// Get prayer name in Arabic
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

  /// Format time as HH:MM
  String formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Format countdown as HH:MM:SS
  String formatCountdown() {
    final hours = _countdown.inHours.toString().padLeft(2, '0');
    final minutes = (_countdown.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_countdown.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  /// Refresh prayer times (for pull-to-refresh)
  Future<void> refresh() async {
    await _loadPrayerTimes();
  }
}
