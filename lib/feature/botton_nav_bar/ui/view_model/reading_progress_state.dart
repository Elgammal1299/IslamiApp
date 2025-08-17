part of 'reading_progress_cubit.dart';

@immutable
sealed class ReadingProgressState extends Equatable {
  const ReadingProgressState();

  @override
  List<Object?> get props => [];
}

final class ReadingProgressInitial extends ReadingProgressState {
  const ReadingProgressInitial();
}

class ReadingProgressLoaded extends ReadingProgressState {
  final int surah;
  final int ayah;
  final int page;

  const ReadingProgressLoaded({
    required this.surah,
    required this.ayah,
    required this.page,
  });

  @override
  List<Object?> get props => [surah, ayah, page];

  ReadingProgressLoaded copyWith({int? surah, int? ayah, int? page}) {
    return ReadingProgressLoaded(
      surah: surah ?? this.surah,
      ayah: ayah ?? this.ayah,
      page: page ?? this.page,
    );
  }
}

class ReadingProgressError extends ReadingProgressState {
  final String message;

  const ReadingProgressError(this.message);

  @override
  List<Object?> get props => [message];
}
