import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/services/bookmark_manager.dart';

part 'bookmark_state.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  final BookmarkManager _bookmarkManager;

  BookmarkCubit(this._bookmarkManager) : super(BookmarkInitial());

  Future<void> loadBookmarks() async {
    if (!isClosed) emit(BookmarksLoading());
    try {
      final bookmarks = await _bookmarkManager.getAllBookmarks();
      if (!isClosed) emit(BookmarksLoaded(bookmarks));
    } catch (e) {
      if (!isClosed) emit(BookmarksError(e.toString()));
    }
  }

  Future<void> removeBookmark(int surah, int ayah) async {
    try {
      await _bookmarkManager.removeBookmark(surah, ayah);
      if (!isClosed) loadBookmarks();
    } catch (e) {
      if (!isClosed) emit(BookmarksError(e.toString()));
    }
  }
}
