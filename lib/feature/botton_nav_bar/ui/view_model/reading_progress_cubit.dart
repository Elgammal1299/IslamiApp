import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/quran_reading_service.dart';

part 'reading_progress_state.dart';

class ReadingProgressCubit extends Cubit<ReadingProgressState> {
  ReadingProgressCubit() : super(const ReadingProgressInitial()) {
    _loadInitialState();
  }

  /// Load initial reading state from SharedPreferences
  Future<void> _loadInitialState() async {
    try {
      debugPrint('🔄 Loading initial reading state...');
      final lastRead = await QuranReadingService.getLastRead();
      if (lastRead != null) {
        debugPrint(
          '📖 Found saved reading progress: Surah ${lastRead['surah']}, Ayah ${lastRead['ayah']}, Page ${lastRead['page']}',
        );
        emit(
          ReadingProgressLoaded(
            surah: lastRead['surah']!,
            ayah: lastRead['ayah']!,
            page: lastRead['page']!,
          ),
        );
      } else {
        debugPrint(
          '📖 No saved reading progress found, defaulting to Al-Fatiha',
        );
        emit(const ReadingProgressLoaded(surah: 1, ayah: 1, page: 1));
      }
    } catch (e) {
      debugPrint('❌ Failed to load reading progress: $e');
      emit(ReadingProgressError('Failed to load reading progress: $e'));
    }
  }

  /// Update reading progress and save to SharedPreferences
  Future<void> updateReadingProgress(int surah, int ayah, int page) async {
    try {
      debugPrint(
        '🔄 Updating reading progress: Surah $surah, Ayah $ayah, Page $page',
      );

      // Save to SharedPreferences
      await QuranReadingService.saveLastRead(surah, ayah, page);

      // Emit new state immediately
      emit(ReadingProgressLoaded(surah: surah, ayah: ayah, page: page));

      debugPrint('✅ Reading progress updated successfully');
    } catch (e) {
      debugPrint('❌ Failed to update reading progress: $e');
      emit(ReadingProgressError('Failed to update reading progress: $e'));
    }
  }

  /// Clear reading progress
  Future<void> clearReadingProgress() async {
    try {
      await QuranReadingService.clearLastRead();
      emit(const ReadingProgressInitial());
    } catch (e) {
      emit(ReadingProgressError('Failed to clear reading progress: $e'));
    }
  }

  /// Refresh reading progress from SharedPreferences
  Future<void> refreshReadingProgress() async {
    await _loadInitialState();
  }
}
