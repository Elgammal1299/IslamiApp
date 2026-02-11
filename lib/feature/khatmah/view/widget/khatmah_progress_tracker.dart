import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/feature/khatmah/view_model/khatmah_cubit.dart';
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

    // البحث عن اليوم الحالي (أول يوم غير مكتمل)
    final currentDay = activeKhatmah.dailyProgress.firstWhere(
      (day) => !day.isCompleted,
      orElse: () => activeKhatmah.dailyProgress.last,
    );

    // البحث عن الجزء اللي فيه الصفحة الحالية
    for (final juz in currentDay.juzList) {
      if (pageNumber >= juz.startPage && pageNumber <= juz.endPage) {
        // الصفحة الحالية في هذا الجزء
        debugPrint(
          '📖 Updating: Day ${currentDay.dayNumber}, Juz ${juz.juzNumber}, Page $pageNumber',
        );

        // تحديث الصفحة الحالية
        await khatmahCubit.updateCurrentPage(
          khatmahId: activeKhatmah.id,
          dayNumber: currentDay.dayNumber,
          juzNumber: juz.juzNumber,
          newPage: pageNumber,
        );

        break;
      }
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
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<KhatmahCubit>(),
        child: DailyWardCompletionDialog(
          khatmahId: khatmahId,
          dayNumber: dayNumber,
        ),
      ),
    );
  }
}