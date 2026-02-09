import 'package:islami_app/feature/khatmah/data/model/khatmah_model.dart';
import 'package:islami_app/feature/khatmah/utils/khatmah_constants.dart';

/// Helper class لحساب توزيع القراءة والتقدم
class KhatmahCalculator {
  /// حساب عدد الأجزاء المطلوبة يومياً
  static double calculateDailyJuz(int totalDays) {
    return KhatmahConstants.totalJuz / totalDays;
  }

  /// حساب عدد الصفحات المطلوبة يومياً
  static double calculateDailyPages(int totalDays) {
    return KhatmahConstants.totalPages / totalDays;
  }

  /// توزيع الأجزاء على الأيام
  static List<DailyProgress> distributeDailyReading(
    DateTime startDate,
    int totalDays,
  ) {
    final List<DailyProgress> dailyProgressList = [];
    final double juzPerDay = calculateDailyJuz(totalDays);

    double currentJuz = 0;

    for (int day = 0; day < totalDays; day++) {
      final date = startDate.add(Duration(days: day));
      final List<JuzProgress> juzList = [];

      // حساب الأجزاء المطلوبة لهذا اليوم
      final double startJuz = currentJuz;
      final double endJuz = currentJuz + juzPerDay;

      // إضافة الأجزاء الكاملة
      int fullJuzStart = startJuz.toInt() + 1;
      int fullJuzEnd = endJuz.floor();

      // إذا كان هناك جزء جزئي في البداية
      if (startJuz % 1 != 0) {
        final int juzNumber = startJuz.floor() + 1;
        final int startPage = _calculatePartialStartPage(
          juzNumber,
          startJuz % 1,
        );
        final int endPage = KhatmahConstants.juzEndPages[juzNumber]!;

        juzList.add(
          JuzProgress(
            juzNumber: juzNumber,
            startPage: startPage,
            endPage: endPage,
            currentPage: startPage,
            isCompleted: false,
          ),
        );

        fullJuzStart = juzNumber + 1;
      }

      // إضافة الأجزاء الكاملة
      for (int juzNum = fullJuzStart; juzNum <= fullJuzEnd; juzNum++) {
        if (juzNum <= KhatmahConstants.totalJuz) {
          juzList.add(
            JuzProgress(
              juzNumber: juzNum,
              startPage: KhatmahConstants.juzStartPages[juzNum]!,
              endPage: KhatmahConstants.juzEndPages[juzNum]!,
              currentPage: KhatmahConstants.juzStartPages[juzNum]!,
              isCompleted: false,
            ),
          );
        }
      }

      // إذا كان هناك جزء جزئي في النهاية
      if (endJuz % 1 != 0 && endJuz.ceil() <= KhatmahConstants.totalJuz) {
        final int juzNumber = endJuz.ceil();
        final int startPage = KhatmahConstants.juzStartPages[juzNumber]!;
        final int endPage = _calculatePartialEndPage(juzNumber, endJuz % 1);

        juzList.add(
          JuzProgress(
            juzNumber: juzNumber,
            startPage: startPage,
            endPage: endPage,
            currentPage: startPage,
            isCompleted: false,
          ),
        );
      }

      dailyProgressList.add(
        DailyProgress(
          dayNumber: day + 1,
          date: date,
          juzList: juzList,
          isCompleted: false,
        ),
      );

      currentJuz = endJuz;
    }

    return dailyProgressList;
  }

  /// حساب صفحة البداية للجزء الجزئي
  static int _calculatePartialStartPage(int juzNumber, double fraction) {
    final int startPage = KhatmahConstants.juzStartPages[juzNumber]!;
    final int endPage = KhatmahConstants.juzEndPages[juzNumber]!;
    final int totalPagesInJuz = endPage - startPage + 1;

    return startPage + (totalPagesInJuz * fraction).round();
  }

  /// حساب صفحة النهاية للجزء الجزئي
  static int _calculatePartialEndPage(int juzNumber, double fraction) {
    final int startPage = KhatmahConstants.juzStartPages[juzNumber]!;
    final int totalPagesInJuz =
        KhatmahConstants.juzEndPages[juzNumber]! - startPage + 1;

    return startPage + (totalPagesInJuz * fraction).round() - 1;
  }

  /// حساب النسبة المئوية للتقدم الإجمالي
  static double calculateOverallProgress(List<DailyProgress> dailyProgress) {
    if (dailyProgress.isEmpty) return 0.0;

    int totalPages = 0;
    int completedPages = 0;

    for (final day in dailyProgress) {
      for (final juz in day.juzList) {
        final juzTotalPages = juz.endPage - juz.startPage + 1;
        totalPages += juzTotalPages;

        if (juz.isCompleted) {
          completedPages += juzTotalPages;
        } else {
          completedPages += juz.currentPage - juz.startPage;
        }
      }
    }

    return totalPages > 0 ? (completedPages / totalPages) * 100 : 0.0;
  }

  /// حساب النسبة المئوية للتقدم اليومي
  static double calculateDailyProgress(DailyProgress day) {
    if (day.juzList.isEmpty) return 0.0;

    int totalPages = 0;
    int completedPages = 0;

    for (final juz in day.juzList) {
      final juzTotalPages = juz.endPage - juz.startPage + 1;
      totalPages += juzTotalPages;

      if (juz.isCompleted) {
        completedPages += juzTotalPages;
      } else {
        completedPages += juz.currentPage - juz.startPage;
      }
    }

    return totalPages > 0 ? (completedPages / totalPages) * 100 : 0.0;
  }

  /// الحصول على رقم الجزء من رقم الصفحة
  static int getJuzNumberFromPage(int pageNumber) {
    for (int juzNum = 1; juzNum <= KhatmahConstants.totalJuz; juzNum++) {
      final startPage = KhatmahConstants.juzStartPages[juzNum]!;
      final endPage = KhatmahConstants.juzEndPages[juzNum]!;

      if (pageNumber >= startPage && pageNumber <= endPage) {
        return juzNum;
      }
    }

    return 1; // Default to first juz
  }

  /// التحقق من إكمال اليوم
  static bool isDayCompleted(DailyProgress day) {
    if (day.juzList.isEmpty) return false;

    return day.juzList.every((juz) => juz.isCompleted);
  }

  /// حساب عدد الأيام المتبقية
  static int calculateRemainingDays(List<DailyProgress> dailyProgress) {
    return dailyProgress.where((day) => !day.isCompleted).length;
  }

  /// الحصول على اليوم الحالي (أول يوم غير مكتمل)
  static DailyProgress? getCurrentDay(List<DailyProgress> dailyProgress) {
    try {
      return dailyProgress.firstWhere((day) => !day.isCompleted);
    } catch (e) {
      return null; // جميع الأيام مكتملة
    }
  }

  /// الحصول على الجزء الحالي (أول جزء غير مكتمل في اليوم الحالي)
  static JuzProgress? getCurrentJuz(DailyProgress day) {
    try {
      return day.juzList.firstWhere((juz) => !juz.isCompleted);
    } catch (e) {
      return null; // جميع الأجزاء مكتملة
    }
  }
}
