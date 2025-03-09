import 'package:bloc/bloc.dart';
import 'package:islami_app/core/services/bookmark_manager.dart';
import 'package:meta/meta.dart';

part 'bookmark_state.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  BookmarkCubit() : super(BookmarkInitial());


  Future<void> loadBookmarks() async {
    emit(BookmarksLoading());
    try {
      final bookmarks = await BookmarkManager.getAllBookmarks();
      emit(BookmarksLoaded(bookmarks));
    } catch (e) {
      emit(BookmarksError(e.toString()));
    }
  }

  Future<void> removeBookmark(int surah, int ayah) async {
    try {
      await BookmarkManager.removeBookmark(surah, ayah);
      loadBookmarks(); // إعادة تحميل القائمة
    } catch (e) {
      emit(BookmarksError(e.toString()));
    }
  }
}

