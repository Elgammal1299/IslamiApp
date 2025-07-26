import 'package:islami_app/core/services/server_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkManager {
  static const String _bookmarksKey = 'quran_bookmarks';

  // إضافة آية للمفضلة
  static Future<void> addBookmark(int surah, int ayah) async {
    List<String> bookmarks =
        sl<SharedPreferences>().getStringList(_bookmarksKey) ?? [];
    String bookmark = '$surah:$ayah';
    if (!bookmarks.contains(bookmark)) {
      bookmarks.add(bookmark);
      await sl<SharedPreferences>().setStringList(_bookmarksKey, bookmarks);
    }
  }

  // إزالة آية من المفضلة
  static Future<void> removeBookmark(int surah, int ayah) async {
    List<String> bookmarks =
        sl<SharedPreferences>().getStringList(_bookmarksKey) ?? [];
    bookmarks.remove('$surah:$ayah');
    await sl<SharedPreferences>().setStringList(_bookmarksKey, bookmarks);
  }

  // التحقق ما إذا كانت الآية في المفضلة
  static Future<bool> isBookmarked(int surah, int ayah) async {
    List<String> bookmarks =
        sl<SharedPreferences>().getStringList(_bookmarksKey) ?? [];
    return bookmarks.contains('$surah:$ayah');
  }

  // الحصول على جميع الآيات المفضلة
  static Future<List<String>> getAllBookmarks() async {
    return sl<SharedPreferences>().getStringList(_bookmarksKey) ?? [];
  }
}
