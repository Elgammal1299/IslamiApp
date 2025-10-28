import 'package:geolocator/geolocator.dart';
import 'package:islami_app/core/services/setup_service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';

/// Service for managing location storage and retrieval
class LocationService {
  final _prefs = sl<SharedPreferences>();

  // Keys for storing location data
  static const String _keyLatitude = 'location_latitude';
  static const String _keyLongitude = 'location_longitude';
  static const String _keyLocationName = 'location_name';
  static const String _keyLastUpdate = 'location_last_update';

  

 
  bool hasStoredLocation() {
    return _prefs.containsKey(_keyLatitude) &&
        _prefs.containsKey(_keyLongitude);
  }

  /// Get stored location coordinates
  /// Returns null if no location is stored
  Position? getStoredLocation() {
    if (!hasStoredLocation()) return null;

    final latitude = _prefs.getDouble(_keyLatitude);
    final longitude = _prefs.getDouble(_keyLongitude);

    if (latitude == null || longitude == null) return null;

    return Position(
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );
  }

  /// Get stored location name (city/area)
  String? getStoredLocationName() {
    return _prefs.getString(_keyLocationName);
  }

  /// Get last update timestamp
  DateTime? getLastUpdateTime() {
    final timestamp = _prefs.getString(_keyLastUpdate);
    if (timestamp == null) return null;
    return DateTime.tryParse(timestamp);
  }

  /// Store location coordinates and fetch location name
  Future<void> storeLocation(Position position) async {
    await _prefs.setDouble(_keyLatitude, position.latitude);
    await _prefs.setDouble(_keyLongitude, position.longitude);
    await _prefs.setString(_keyLastUpdate, DateTime.now().toIso8601String());

    // Try to fetch and store location name
    try {
      final locationName = await _getLocationName(
        position.latitude,
        position.longitude,
      );
      if (locationName != null) {
        await _prefs.setString(_keyLocationName, locationName);
      }
    } catch (e) {
      // Silently fail - location name is optional
    }
  }

  /// Fetch location name from coordinates using reverse geocoding
  Future<String?> _getLocationName(double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isEmpty) return null;

      final placemark = placemarks.first;
      // Build location name from available data
      final parts = <String>[];

      if (placemark.locality != null && placemark.locality!.isNotEmpty) {
        parts.add(placemark.locality!);
      }
      if (placemark.administrativeArea != null &&
          placemark.administrativeArea!.isNotEmpty) {
        parts.add(placemark.administrativeArea!);
      }
      if (placemark.country != null && placemark.country!.isNotEmpty) {
        parts.add(placemark.country!);
      }

      return parts.isNotEmpty ? parts.join(', ') : null;
    } catch (e) {
      return null;
    }
  }

  /// Get current device position
  Future<Position> getCurrentPosition() async {
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
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  /// Initialize location - get from storage or fetch new
  Future<Position> initializeLocation() async {
    // Check if location is already stored
    if (hasStoredLocation()) {
      final stored = getStoredLocation();
      if (stored != null) {
        return stored;
      }
    }

    // No stored location, fetch current position
    final position = await getCurrentPosition();
    await storeLocation(position);
    return position;
  }

  /// Update location manually and store it
  Future<Position> updateLocation() async {
    final position = await getCurrentPosition();
    await storeLocation(position);
    return position;
  }

  /// Clear stored location data
  Future<void> clearLocation() async {
    await _prefs.remove(_keyLatitude);
    await _prefs.remove(_keyLongitude);
    await _prefs.remove(_keyLocationName);
    await _prefs.remove(_keyLastUpdate);
  }
}
