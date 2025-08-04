import 'package:shared_preferences/shared_preferences.dart';

class BookmarkManager {
  static const String _bookmarksKey = 'quran_bookmarks';
  final SharedPreferences _prefs;

  BookmarkManager(this._prefs);

  // إضافة آية للمفضلة
  Future<void> addBookmark(int surah, int ayah) async {
    List<String> bookmarks = _prefs.getStringList(_bookmarksKey) ?? [];
    String bookmark = '$surah:$ayah';
    if (!bookmarks.contains(bookmark)) {
      bookmarks.add(bookmark);
      await _prefs.setStringList(_bookmarksKey, bookmarks);
    }
  }

  // إزالة آية من المفضلة
  Future<void> removeBookmark(int surah, int ayah) async {
    List<String> bookmarks = _prefs.getStringList(_bookmarksKey) ?? [];
    bookmarks.remove('$surah:$ayah');
    await _prefs.setStringList(_bookmarksKey, bookmarks);
  }

  // التحقق ما إذا كانت الآية في المفضلة
  Future<bool> isBookmarked(int surah, int ayah) async {
    List<String> bookmarks = _prefs.getStringList(_bookmarksKey) ?? [];
    return bookmarks.contains('$surah:$ayah');
  }

  // الحصول على جميع الآيات المفضلة
  Future<List<String>> getAllBookmarks() async {
    return _prefs.getStringList(_bookmarksKey) ?? [];
  }
}
