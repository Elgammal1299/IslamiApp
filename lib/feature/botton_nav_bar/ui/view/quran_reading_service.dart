import 'package:shared_preferences/shared_preferences.dart';

class QuranReadingService {
  static const String _lastSurahKey = 'lastSurah';
  static const String _lastAyahKey = 'lastAyah';
  static const String _lastPageKey = 'lastPage';

  /// Save last reading position
  static Future<void> saveLastRead(int surah, int ayah, int page) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastSurahKey, surah);
    await prefs.setInt(_lastAyahKey, ayah);
    await prefs.setInt(_lastPageKey, page);
  }

  /// Get last reading position
  static Future<Map<String, int>?> getLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    final surah = prefs.getInt(_lastSurahKey);
    final ayah = prefs.getInt(_lastAyahKey);
    final page = prefs.getInt(_lastPageKey);

    if (surah != null && ayah != null && page != null) {
      return {'surah': surah, 'ayah': ayah, 'page': page};
    }
    return null; // No saved data
  }

  /// Clear last read (optional)
  static Future<void> clearLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastSurahKey);
    await prefs.remove(_lastAyahKey);
    await prefs.remove(_lastPageKey);
  }
}
