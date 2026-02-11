import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/feature/khatmah/data/model/khatmah_model.dart';
import 'package:islami_app/feature/khatmah/data/repo/khatmah_repo.dart';
import 'package:islami_app/feature/khatmah/utils/khatmah_calculator.dart';

part 'khatmah_state.dart';

class KhatmahCubit extends Cubit<KhatmahState> {
  final KhatmahRepository _repository;

  KhatmahCubit(this._repository) : super(KhatmahInitial()) {
    loadKhatmahs();
  }

  /// تحميل جميع الختمات
  Future<void> loadKhatmahs() async {
    if (isClosed) return;
    try {
      emit(KhatmahLoading());
      final khatmahs = await _repository.getAllKhatmahs();
      final activeKhatmah = await _repository.getActiveKhatmah();

      if (isClosed) return;
      emit(KhatmahLoaded(khatmahs: khatmahs, activeKhatmah: activeKhatmah));
    } catch (e) {
      debugPrint('❌ Error loading khatmahs: $e');
      if (!isClosed) emit(KhatmahError('فشل تحميل الختمات: $e'));
    }
  }

  /// إنشاء ختمة جديدة
  Future<void> createKhatmah({
    required String name,
    required int totalDays,
    required DateTime startDate,
  }) async {
    if (isClosed) return;
    try {
      emit(KhatmahLoading());

      // حساب التوزيع اليومي
      final dailyProgress = KhatmahCalculator.distributeDailyReading(
        startDate,
        totalDays,
      );

      // إنشاء الختمة
      final khatmah = await _repository.createKhatmah(
        name: name,
        totalDays: totalDays,
        startDate: startDate,
        dailyProgress: dailyProgress,
      );

      debugPrint('✅ Khatmah created: ${khatmah.name}');

      // إعادة تحميل الختمات
      await loadKhatmahs();

      if (!isClosed) emit(KhatmahCreated(khatmah));
    } catch (e) {
      debugPrint('❌ Error creating khatmah: $e');
      if (!isClosed) emit(KhatmahError('فشل إنشاء الختمة: $e'));
    }
  }

  /// حذف ختمة
  Future<void> deleteKhatmah(String khatmahId) async {
    if (isClosed) return;
    try {
      await _repository.deleteKhatmah(khatmahId);
      debugPrint('✅ Khatmah deleted: $khatmahId');
      await loadKhatmahs();
    } catch (e) {
      debugPrint('❌ Error deleting khatmah: $e');
      if (!isClosed) emit(KhatmahError('فشل حذف الختمة: $e'));
    }
  }

  /// تحديث صفحة الجزء الحالية
  Future<void> updateCurrentPage({
    required String khatmahId,
    required int dayNumber,
    required int juzNumber,
    required int newPage,
  }) async {
    if (isClosed) return;
    try {
      // حفظ الحالة السابقة
      final khatmahBefore = _repository.getKhatmah(khatmahId);
      if (khatmahBefore == null) return;
      
      final dayBefore = khatmahBefore.dailyProgress.firstWhere(
        (day) => day.dayNumber == dayNumber,
      );
      final wasDayCompleted = dayBefore.isCompleted;

      // تحديث الصفحة
      await _repository.updateCurrentPage(
        khatmahId,
        dayNumber,
        juzNumber,
        newPage,
      );

      debugPrint(
        '✅ Updated page for Juz $juzNumber on Day $dayNumber to page $newPage',
      );

      // التحقق من إتمام الورد اليومي
      final khatmahAfter = _repository.getKhatmah(khatmahId);
      if (khatmahAfter != null) {
        final dayAfter = khatmahAfter.dailyProgress.firstWhere(
          (day) => day.dayNumber == dayNumber,
        );
        
        // إذا تم إكمال اليوم للتو (لم يكن مكتملاً من قبل والآن أصبح مكتملاً)
        if (!wasDayCompleted && dayAfter.isCompleted) {
          debugPrint('🎉 Daily ward completed for day $dayNumber!');
          if (!isClosed) {
            emit(KhatmahDailyCompleted(
              dayNumber: dayNumber,
              khatmahId: khatmahId,
            ));
          }
        }
      }

      await loadKhatmahs();
    } catch (e) {
      debugPrint('❌ Error updating current page: $e');
      if (!isClosed) emit(KhatmahError('فشل تحديث الصفحة: $e'));
    }
  }

  /// إتمام الورد اليومي
  Future<void> completeDailyWard({
    required String khatmahId,
    required int dayNumber,
  }) async {
    if (isClosed) return;
    try {
      final khatmah = _repository.getKhatmah(khatmahId);
      if (khatmah == null) return;

      final updatedDailyProgress = khatmah.dailyProgress.map((day) {
        if (day.dayNumber == dayNumber) {
          return day.copyWith(isCompleted: true);
        }
        return day;
      }).toList();

      // التحقق من إكمال الختمة
      final isCompleted = updatedDailyProgress.every((day) => day.isCompleted);

      final updatedKhatmah = khatmah.copyWith(
        dailyProgress: updatedDailyProgress,
        isCompleted: isCompleted,
      );

      await _repository.updateKhatmah(updatedKhatmah);
      debugPrint('✅ Daily ward completed and saved for day $dayNumber');

      await loadKhatmahs();
    } catch (e) {
      debugPrint('❌ Error completing daily ward: $e');
      if (!isClosed) emit(KhatmahError('فشل حفظ إتمام الورد: $e'));
    }
  }

  /// تحديث تقدم جزء معين
  Future<void> updateJuzProgress({
    required String khatmahId,
    required int dayNumber,
    required int juzNumber,
    required JuzProgress newJuzProgress,
  }) async {
    if (isClosed) return;
    try {
      await _repository.updateJuzProgress(
        khatmahId,
        dayNumber,
        juzNumber,
        newJuzProgress,
      );

      debugPrint('✅ Updated Juz $juzNumber progress on Day $dayNumber');

      await loadKhatmahs();
    } catch (e) {
      debugPrint('❌ Error updating juz progress: $e');
      if (!isClosed) emit(KhatmahError('فشل تحديث التقدم: $e'));
    }
  }

  /// تحديث تقدم يوم معين
  Future<void> updateDailyProgress({
    required String khatmahId,
    required int dayNumber,
    required DailyProgress newProgress,
  }) async {
    if (isClosed) return;
    try {
      await _repository.updateDailyProgress(khatmahId, dayNumber, newProgress);

      debugPrint('✅ Updated Day $dayNumber progress');

      await loadKhatmahs();
    } catch (e) {
      debugPrint('❌ Error updating daily progress: $e');
      if (!isClosed) emit(KhatmahError('فشل تحديث التقدم اليومي: $e'));
    }
  }

  /// تحديث ختمة
  Future<void> updateKhatmah(KhatmahModel khatmah) async {
    if (isClosed) return;
    try {
      await _repository.updateKhatmah(khatmah);
      debugPrint('✅ Khatmah updated: ${khatmah.name}');
      await loadKhatmahs();
    } catch (e) {
      debugPrint('❌ Error updating khatmah: $e');
      if (!isClosed) emit(KhatmahError('فشل تحديث الختمة: $e'));
    }
  }

  /// الحصول على الختمة النشطة
  Future<KhatmahModel?> getActiveKhatmah() async {
    try {
      return await _repository.getActiveKhatmah();
    } catch (e) {
      debugPrint('❌ Error getting active khatmah: $e');
      return null;
    }
  }

  /// الحصول على ختمة معينة
  KhatmahModel? getKhatmah(String id) {
    try {
      return _repository.getKhatmah(id);
    } catch (e) {
      debugPrint('❌ Error getting khatmah: $e');
      return null;
    }
  }

  /// الحصول على الختمات المكتملة
  Future<List<KhatmahModel>> getCompletedKhatmahs() async {
    try {
      return await _repository.getCompletedKhatmahs();
    } catch (e) {
      debugPrint('❌ Error getting completed khatmahs: $e');
      return [];
    }
  }

  /// إعادة تحميل الختمات
  Future<void> refreshKhatmahs() async {
    await loadKhatmahs();
  }
}