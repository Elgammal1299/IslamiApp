part of 'bookmark_cubit.dart';

@immutable
sealed class BookmarkState  extends Equatable {
  @override
  List<Object?> get props => [];
}

final class BookmarkInitial extends BookmarkState {}

final class BookmarksInitial extends BookmarkState {}

final class BookmarksLoading extends BookmarkState {}

final class BookmarksLoaded extends BookmarkState {
  final List<String> bookmarks;
  BookmarksLoaded(this.bookmarks);
  @override
  List<Object?> get props => [bookmarks];
}

final class BookmarksError extends BookmarkState {
  final String message;
  BookmarksError(this.message);
  @override
  List<Object?> get props => [message];
}
