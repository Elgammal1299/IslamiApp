import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';

/// Encapsulates all Adhan logic: location, calculation method, madhab, etc.
class PrayerTimesService {
  final CalculationMethod calculationMethod;
  final Madhab madhab;
  final Duration? customOffset;

  PrayerTimesService({
    this.calculationMethod = CalculationMethod.muslim_world_league,
    this.madhab = Madhab.shafi,
    this.customOffset,
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

    // Use optimal calculation method for the location
    final optimalMethod = getOptimalCalculationMethod(
      position.latitude,
      position.longitude,
    );
    if (optimalMethod != calculationMethod) {
      // Create a new instance with optimal method if different
      final optimalService = PrayerTimesService(
        calculationMethod: optimalMethod,
        madhab: madhab,
        customOffset: customOffset,
      );
      return optimalService.getPrayerTimesForDate(
        latitude: position.latitude,
        longitude: position.longitude,
        date: DateTime.now(),
      );
    }

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

  /// Get timezone-aware current time
  DateTime getCurrentTime() {
    return DateTime.now();
  }

  /// Check if daylight saving time is active
  bool isDaylightSavingTime() {
    final now = DateTime.now();
    final january = DateTime(now.year, 1, 1);
    final july = DateTime(now.year, 7, 1);

    // Simple DST check - this is a basic implementation
    // In production, you might want to use a more sophisticated approach
    return now.isAfter(january.add(const Duration(days: 60))) &&
        now.isBefore(july.add(const Duration(days: 90)));
  }

  /// Get appropriate time offset based on DST
  Duration getTimeOffset() {
    return isDaylightSavingTime() ? const Duration(hours: 1) : Duration.zero;
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
  Map<Prayer, DateTime> getNamedTimes(PrayerTimes times, {Duration? offset}) {
    final Map<Prayer, DateTime> result = {};
    for (final Prayer p in displayPrayers) {
      final DateTime? t = times.timeForPrayer(p);
      if (t != null) {
        result[p] = offset != null ? t.add(offset) : t;
      }
    }
    return result;
  }

  /// Apply time offset to prayer times
  Map<Prayer, DateTime> applyOffset(
    Map<Prayer, DateTime> times,
    Duration offset,
  ) {
    return times.map((p, t) => MapEntry(p, t.add(offset)));
  }

  /// Get optimal calculation method based on location
  static CalculationMethod getOptimalCalculationMethod(
    double latitude,
    double longitude,
  ) {
    // Simple geographic-based method selection
    if (latitude > 20 && latitude < 40 && longitude > -120 && longitude < -60) {
      // North America - use ISNA method
      return CalculationMethod.muslim_world_league; // Fallback to MWL
    } else if (latitude > 10 &&
        latitude < 40 &&
        longitude > 20 &&
        longitude < 60) {
      // Middle East and North Africa
      return CalculationMethod.muslim_world_league;
    } else if (latitude > 25 &&
        latitude < 40 &&
        longitude > 60 &&
        longitude < 80) {
      // South Asia
      return CalculationMethod.karachi;
    } else if (latitude > -40 &&
        latitude < 10 &&
        longitude > 110 &&
        longitude < 160) {
      // Southeast Asia
      return CalculationMethod.singapore;
    } else if (latitude > 40 &&
        latitude < 70 &&
        longitude > -10 &&
        longitude < 40) {
      // Europe - use France method
      return CalculationMethod.muslim_world_league; // Fallback to MWL
    } else {
      // Default to Muslim World League
      return CalculationMethod.muslim_world_league;
    }
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
  DateTime? _lastUpdate;

  // Getters
  PrayerTimes? get todayTimes => _todayTimes;
  Map<Prayer, DateTime> get namedTimes => _namedTimes;
  Prayer? get currentPrayer => _currentPrayer;
  Prayer? get nextPrayer => _nextPrayer;
  Duration get countdown => _countdown;

  // Dynamic summer offset based on DST detection
  Duration get summerOffset => _prayerService.getTimeOffset();

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
      _lastUpdate = DateTime.now();
    } catch (e) {
      // Handle error silently
    }
  }

  /// Set the prayer times and calculate current/next prayers
  void _setTimes(PrayerTimes times) {
    _todayTimes = times;

    // Apply summer time offset
    _namedTimes = _prayerService.getNamedTimes(times, offset: summerOffset);

    _refreshPrayers();
    notifyListeners();
  }

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
      _countdown = nextTime.add(summerOffset).difference(DateTime.now());
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
    // Check if we need to refresh for new day
    autoRefreshIfNeeded();

    if (_nextPrayer != null && _todayTimes != null) {
      final nextTime = _prayerService.timeForPrayer(_todayTimes!, _nextPrayer!);
      if (nextTime != null) {
        final adjustedTime = nextTime.add(summerOffset);
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

  /// Check if we need to refresh prayer times (new day)
  bool shouldRefreshPrayerTimes() {
    if (_todayTimes == null || _lastUpdate == null) return true;

    final now = DateTime.now();

    // Check if it's a new day
    return now.day != _lastUpdate!.day ||
        now.month != _lastUpdate!.month ||
        now.year != _lastUpdate!.year;
  }

  /// Auto-refresh if needed
  Future<void> autoRefreshIfNeeded() async {
    if (shouldRefreshPrayerTimes()) {
      await _loadPrayerTimes();
    }
  }
}
