import 'package:islami_app/core/services/hive_service.dart';
import 'package:islami_app/feature/khatmah/data/model/khatmah_model.dart';
import 'package:uuid/uuid.dart';

class KhatmahRepository {
  final HiveService<KhatmahModel> _hiveService;
  final _uuid = const Uuid();

  KhatmahRepository(this._hiveService);

  /// إنشاء ختمة جديدة
  Future<KhatmahModel> createKhatmah({
    required String name,
    required int totalDays,
    required DateTime startDate,
    required List<DailyProgress> dailyProgress,
  }) async {
    final khatmah = KhatmahModel(
      id: _uuid.v4(),
      name: name,
      totalDays: totalDays,
      startDate: startDate,
      endDate: startDate.add(Duration(days: totalDays - 1)),
      dailyProgress: dailyProgress,
      isCompleted: false,
      createdAt: DateTime.now(),
    );

    await _hiveService.put(khatmah.id, khatmah);
    return khatmah;
  }

  /// الحصول على جميع الختمات
  Future<List<KhatmahModel>> getAllKhatmahs() async {
    return await _hiveService.getAll();
  }

  /// الحصول على ختمة معينة
  KhatmahModel? getKhatmah(String id) {
    return _hiveService.get(id);
  }

  /// تحديث ختمة
  Future<void> updateKhatmah(KhatmahModel khatmah) async {
    await _hiveService.put(khatmah.id, khatmah);
  }

  /// حذف ختمة
  Future<void> deleteKhatmah(String id) async {
    await _hiveService.delete(id);
  }

  /// الحصول على الختمة النشطة (آخر ختمة غير مكتملة)
  Future<KhatmahModel?> getActiveKhatmah() async {
    final khatmahs = await getAllKhatmahs();
    if (khatmahs.isEmpty) return null;

    try {
      return khatmahs.firstWhere((k) => !k.isCompleted);
    } catch (e) {
      return null;
    }
  }

  /// الحصول على الختمات المكتملة
  Future<List<KhatmahModel>> getCompletedKhatmahs() async {
    final khatmahs = await getAllKhatmahs();
    return khatmahs.where((k) => k.isCompleted).toList();
  }

  /// تحديث تقدم يوم معين
  Future<void> updateDailyProgress(
    String khatmahId,
    int dayNumber,
    DailyProgress newProgress,
  ) async {
    final khatmah = getKhatmah(khatmahId);
    if (khatmah == null) return;

    final updatedDailyProgress = khatmah.dailyProgress.map((day) {
      if (day.dayNumber == dayNumber) {
        return newProgress;
      }
      return day;
    }).toList();

    // التحقق من إكمال الختمة
    final isCompleted = updatedDailyProgress.every((day) => day.isCompleted);

    final updatedKhatmah = khatmah.copyWith(
      dailyProgress: updatedDailyProgress,
      isCompleted: isCompleted,
    );

    await updateKhatmah(updatedKhatmah);
  }

  /// تحديث تقدم جزء معين
  Future<void> updateJuzProgress(
    String khatmahId,
    int dayNumber,
    int juzNumber,
    JuzProgress newJuzProgress,
  ) async {
    final khatmah = getKhatmah(khatmahId);
    if (khatmah == null) return;

    final updatedDailyProgress = khatmah.dailyProgress.map((day) {
      if (day.dayNumber == dayNumber) {
        final updatedJuzList = day.juzList.map((juz) {
          if (juz.juzNumber == juzNumber) {
            return newJuzProgress;
          }
          return juz;
        }).toList();

        // التحقق من إكمال اليوم
        final isDayCompleted = updatedJuzList.every((juz) => juz.isCompleted);

        return day.copyWith(
          juzList: updatedJuzList,
          isCompleted: isDayCompleted,
        );
      }
      return day;
    }).toList();

    // التحقق من إكمال الختمة
    final isCompleted = updatedDailyProgress.every((day) => day.isCompleted);

    final updatedKhatmah = khatmah.copyWith(
      dailyProgress: updatedDailyProgress,
      isCompleted: isCompleted,
    );

    await updateKhatmah(updatedKhatmah);
  }

  /// تحديث صفحة الجزء الحالية
  Future<void> updateCurrentPage(
    String khatmahId,
    int dayNumber,
    int juzNumber,
    int newPage,
  ) async {
    final khatmah = getKhatmah(khatmahId);
    if (khatmah == null) return;

    final updatedDailyProgress = khatmah.dailyProgress.map((day) {
      if (day.dayNumber == dayNumber) {
        final updatedJuzList = day.juzList.map((juz) {
          if (juz.juzNumber == juzNumber) {
            final isCompleted = newPage >= juz.endPage;
            return juz.copyWith(
              currentPage: newPage,
              isCompleted: isCompleted,
            );
          }
          return juz;
        }).toList();

        final isDayCompleted = updatedJuzList.every((juz) => juz.isCompleted);

        return day.copyWith(
          juzList: updatedJuzList,
          isCompleted: isDayCompleted,
        );
      }
      return day;
    }).toList();

    final isCompleted = updatedDailyProgress.every((day) => day.isCompleted);

    final updatedKhatmah = khatmah.copyWith(
      dailyProgress: updatedDailyProgress,
      isCompleted: isCompleted,
    );

    await updateKhatmah(updatedKhatmah);
  }
}