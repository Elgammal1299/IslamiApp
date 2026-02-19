import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  /// Centralized prayer name mapping (Arabic)
  static String getPrayerName(Prayer prayer) {
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
        return '';
    }
  }

  /// Get tomorrow's Fajr time for after-Isha countdown
  Future<DateTime?> getTomorrowFajrTime() async {
    final Position position = await getCurrentPosition();
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final tomorrowTimes = getPrayerTimesForDate(
      latitude: position.latitude,
      longitude: position.longitude,
      date: tomorrow,
    );
    return tomorrowTimes.timeForPrayer(Prayer.fajr);
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
  int _lastLoadedDay = DateTime.now().day;
  DateTime? _tomorrowFajr;

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
      _lastLoadedDay = DateTime.now().day;
      try {
        _tomorrowFajr = await _prayerService.getTomorrowFajrTime();
      } catch (_) {}
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

    // Detect day change and reload
    final today = DateTime.now().day;
    if (today != _lastLoadedDay) {
      _loadPrayerTimes();
      return;
    }

    final t = _todayTimes!;
    _currentPrayer = _prayerService.currentPrayer(t);
    _nextPrayer = _prayerService.nextPrayer(t);

    final DateTime? nextTime =
        (_nextPrayer != null && _nextPrayer != Prayer.none)
            ? _prayerService.timeForPrayer(t, _nextPrayer!)
            : null;

    if (nextTime != null && nextTime.isAfter(DateTime.now())) {
      _countdown = nextTime.difference(DateTime.now());
    } else if (_tomorrowFajr != null && _tomorrowFajr!.isAfter(DateTime.now())) {
      // After Isha - countdown to tomorrow's Fajr
      _countdown = _tomorrowFajr!.difference(DateTime.now());
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
    if (_todayTimes == null) return;

    // Detect day change
    if (DateTime.now().day != _lastLoadedDay) {
      _loadPrayerTimes();
      return;
    }

    _refreshPrayers();
    notifyListeners();
  }

  String getPrayerName(Prayer prayer) {
    if (prayer == Prayer.none) return 'انتهت الصلوات';
    return PrayerTimesService.getPrayerName(prayer);
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

/// Helper for persisting prayer calculation settings
class PrayerSettings {
  static const String _keyCalcMethod = 'prayer_calculation_method';
  static const String _keyMadhab = 'prayer_madhab';

  static const List<CalculationMethod> availableMethods = [
    CalculationMethod.egyptian,
    CalculationMethod.umm_al_qura,
    CalculationMethod.muslim_world_league,
    CalculationMethod.karachi,
    CalculationMethod.dubai,
    CalculationMethod.kuwait,
    CalculationMethod.qatar,
    CalculationMethod.turkey,
    CalculationMethod.tehran,
    CalculationMethod.north_america,
    CalculationMethod.singapore,
    CalculationMethod.moon_sighting_committee,
  ];

  static CalculationMethod loadMethod(SharedPreferences prefs) {
    final name = prefs.getString(_keyCalcMethod);
    if (name == null) return CalculationMethod.egyptian;
    for (final m in CalculationMethod.values) {
      if (m.name == name) return m;
    }
    return CalculationMethod.egyptian;
  }

  static Madhab loadMadhab(SharedPreferences prefs) {
    final name = prefs.getString(_keyMadhab);
    if (name == null) return Madhab.shafi;
    for (final m in Madhab.values) {
      if (m.name == name) return m;
    }
    return Madhab.shafi;
  }

  static Future<void> saveMethod(
    SharedPreferences prefs,
    CalculationMethod method,
  ) async {
    await prefs.setString(_keyCalcMethod, method.name);
  }

  static Future<void> saveMadhab(
    SharedPreferences prefs,
    Madhab madhab,
  ) async {
    await prefs.setString(_keyMadhab, madhab.name);
  }

  static String methodDisplayName(CalculationMethod method) {
    switch (method) {
      case CalculationMethod.egyptian:
        return 'الهيئة المصرية العامة للمساحة';
      case CalculationMethod.umm_al_qura:
        return 'أم القرى (السعودية)';
      case CalculationMethod.muslim_world_league:
        return 'رابطة العالم الإسلامي';
      case CalculationMethod.karachi:
        return 'جامعة العلوم الإسلامية، كراتشي';
      case CalculationMethod.dubai:
        return 'دبي';
      case CalculationMethod.kuwait:
        return 'الكويت';
      case CalculationMethod.qatar:
        return 'قطر';
      case CalculationMethod.turkey:
        return 'تركيا';
      case CalculationMethod.tehran:
        return 'طهران';
      case CalculationMethod.north_america:
        return 'أمريكا الشمالية (ISNA)';
      case CalculationMethod.singapore:
        return 'سنغافورة';
      case CalculationMethod.moon_sighting_committee:
        return 'لجنة رؤية الهلال';
      case CalculationMethod.other:
        return 'أخرى';
    }
  }

  static String madhabDisplayName(Madhab madhab) {
    switch (madhab) {
      case Madhab.shafi:
        return 'الشافعي / المالكي / الحنبلي';
      case Madhab.hanafi:
        return 'الحنفي';
    }
  }
}
