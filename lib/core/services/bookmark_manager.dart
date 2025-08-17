import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class BookmarkManager {
  static const String _bookmarksKey = 'quran_bookmarks';
  final SharedPreferences _prefs;

  BookmarkManager(this._prefs);

  // إضافة آية للمفضلة
  Future<void> addBookmark(int surah, int ayah) async {
    List<String> bookmarks = _prefs.getStringList(_bookmarksKey) ?? [];
    String bookmark = '$surah:$ayah';
    debugPrint('🔖 BookmarkManager: Current bookmarks: $bookmarks');
    debugPrint('🔖 BookmarkManager: Adding bookmark: $bookmark');

    if (!bookmarks.contains(bookmark)) {
      bookmarks.add(bookmark);
      await _prefs.setStringList(_bookmarksKey, bookmarks);
      debugPrint('✅ BookmarkManager: Bookmark added. New list: $bookmarks');
    } else {
      debugPrint('ℹ️ BookmarkManager: Bookmark already exists');
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
    final bookmarks = _prefs.getStringList(_bookmarksKey) ?? [];
    debugPrint('📚 BookmarkManager: Retrieved bookmarks: $bookmarks');
    return bookmarks;
  }
}
