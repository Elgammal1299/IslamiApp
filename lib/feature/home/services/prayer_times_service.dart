import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';

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
