import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/feature/khatmah/view_model/khatmah_cubit.dart';
import 'package:islami_app/feature/khatmah/data/model/khatmah_model.dart';
import 'package:islami_app/feature/khatmah/view/widget/daily_ward_completion_dialog.dart';

/// Helper class لتتبع تقدم الختمة من أي صفحة في التطبيق
class KhatmahProgressTracker {
  /// تحديث الصفحة الحالية وفحص إتمام الورد
  static Future<void> updateCurrentPage(
    BuildContext context, {
    required int pageNumber,
  }) async {
    // الحصول على الختمة النشطة
    final khatmahCubit = context.read<KhatmahCubit>();
    final activeKhatmah = await khatmahCubit.getActiveKhatmah();

    if (activeKhatmah == null) {
      // مفيش ختمة نشطة، مش محتاجين نتتبع
      return;
    }

    // البحث عن اليوم والجزء الذي تنتمي له هذه الصفحة في الختمة كاملة
    DailyProgress? foundDay;
    JuzProgress? foundJuz;

    for (final day in activeKhatmah.dailyProgress) {
      for (final juz in day.juzList) {
        if (pageNumber >= juz.startPage && pageNumber <= juz.endPage) {
          foundDay = day;
          foundJuz = juz;
          break;
        }
      }
      if (foundDay != null) break;
    }

    if (foundDay != null && foundJuz != null) {
      debugPrint(
        '📖 Updating Progress: Day ${foundDay.dayNumber}, Juz ${foundJuz.juzNumber}, Page $pageNumber',
      );

      // تحديث الصفحة الحالية في اليوم والجزء الصحيحين
      await khatmahCubit.updateCurrentPage(
        khatmahId: activeKhatmah.id,
        dayNumber: foundDay.dayNumber,
        juzNumber: foundJuz.juzNumber,
        newPage: pageNumber,
      );
    }
  }

  /// الاستماع لحالة إتمام الورد اليومي
  static void listenForDailyCompletion(
    BuildContext context, {
    required void Function(int dayNumber, String khatmahId) onCompleted,
  }) {
    // هذه الدالة تُستخدم في BlocListener
    // مثال الاستخدام في الويدجت:
    /*
    BlocListener<KhatmahCubit, KhatmahState>(
      listener: (context, state) {
        if (state is KhatmahDailyCompleted) {
          KhatmahProgressTracker.showCompletionDialog(
            context,
            dayNumber: state.dayNumber,
            khatmahId: state.khatmahId,
          );
        }
      },
      child: YourWidget(),
    )
    */
  }

  /// عرض dialog إتمام الورد
  static void showCompletionDialog(
    BuildContext context, {
    required int dayNumber,
    required String khatmahId,
    required KhatmahCubit cubit,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => BlocProvider.value(
            value: cubit,
            child: DailyWardCompletionDialog(
              khatmahId: khatmahId,
              dayNumber: dayNumber,
              cubit: cubit,
            ),
          ),
    );
  }
}
