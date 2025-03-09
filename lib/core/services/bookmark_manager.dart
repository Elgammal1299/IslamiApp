import 'package:shared_preferences/shared_preferences.dart';

class BookmarkManager {
  static const String _bookmarksKey = 'quran_bookmarks';

  // إضافة آية للمفضلة
  static Future<void> addBookmark(int surah, int ayah) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList(_bookmarksKey) ?? [];
    String bookmark = '$surah:$ayah';
    if (!bookmarks.contains(bookmark)) {
      bookmarks.add(bookmark);
      await prefs.setStringList(_bookmarksKey, bookmarks);
    }
  }

  // إزالة آية من المفضلة
  static Future<void> removeBookmark(int surah, int ayah) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList(_bookmarksKey) ?? [];
    bookmarks.remove('$surah:$ayah');
    await prefs.setStringList(_bookmarksKey, bookmarks);
  }

  // التحقق ما إذا كانت الآية في المفضلة
  static Future<bool> isBookmarked(int surah, int ayah) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList(_bookmarksKey) ?? [];
    return bookmarks.contains('$surah:$ayah');
  }

  // الحصول على جميع الآيات المفضلة
  static Future<List<String>> getAllBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_bookmarksKey) ?? [];
  }
}
