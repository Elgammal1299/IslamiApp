import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/services/bookmark_manager.dart';
import 'package:flutter/foundation.dart';

part 'bookmark_state.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  final BookmarkManager _bookmarkManager;

  BookmarkCubit(this._bookmarkManager) : super(BookmarkInitial());

  Future<void> loadBookmarks() async {
    if (!isClosed) emit(BookmarksLoading());
    try {
      debugPrint('🔄 Loading bookmarks...');
      final bookmarks = await _bookmarkManager.getAllBookmarks();
      debugPrint('📚 Found ${bookmarks.length} bookmarks: $bookmarks');
      if (!isClosed) emit(BookmarksLoaded(bookmarks));
    } catch (e) {
      debugPrint('❌ Error loading bookmarks: $e');
      if (!isClosed) emit(BookmarksError(e.toString()));
    }
  }

  Future<void> addBookmark(int surah, int ayah) async {
    try {
      debugPrint('🔖 Adding bookmark: Surah $surah, Ayah $ayah');
      await _bookmarkManager.addBookmark(surah, ayah);
      debugPrint('✅ Bookmark added successfully');
      if (!isClosed) loadBookmarks();
    } catch (e) {
      debugPrint('❌ Error adding bookmark: $e');
      if (!isClosed) emit(BookmarksError(e.toString()));
    }
  }

  Future<void> removeBookmark(int surah, int ayah) async {
    try {
      debugPrint('🗑️ Removing bookmark: Surah $surah, Ayah $ayah');
      await _bookmarkManager.removeBookmark(surah, ayah);
      debugPrint('✅ Bookmark removed successfully');
      if (!isClosed) loadBookmarks();
    } catch (e) {
      debugPrint('❌ Error removing bookmark: $e');
      if (!isClosed) emit(BookmarksError(e.toString()));
    }
  }

  Future<bool> isBookmarked(int surah, int ayah) async {
    try {
      return await _bookmarkManager.isBookmarked(surah, ayah);
    } catch (e) {
      return false;
    }
  }

  /// Force refresh bookmarks from storage
  Future<void> refreshBookmarks() async {
    await loadBookmarks();
  }

  /// Get current bookmarks list
  List<String> get currentBookmarks {
    final state = this.state;
    if (state is BookmarksLoaded) {
      return state.bookmarks;
    }
    return [];
  }
}
