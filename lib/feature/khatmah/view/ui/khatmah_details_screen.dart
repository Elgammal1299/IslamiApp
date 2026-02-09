import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/core/router/app_routes.dart';
import 'package:islami_app/feature/khatmah/data/model/khatmah_model.dart';
import 'package:islami_app/feature/khatmah/utils/khatmah_calculator.dart';
import 'package:intl/intl.dart';
import 'package:islami_app/feature/khatmah/view_model/khatmah_cubit.dart';

class KhatmahDetailsScreen extends StatefulWidget {
  final String khatmahId;

  const KhatmahDetailsScreen({super.key, required this.khatmahId});

  @override
  State<KhatmahDetailsScreen> createState() => _KhatmahDetailsScreenState();
}

class _KhatmahDetailsScreenState extends State<KhatmahDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الختمة'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteDialog();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: AppColors.error),
                    SizedBox(width: 8),
                    Text('حذف الختمة'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<KhatmahCubit, KhatmahState>(
        builder: (context, state) {
          final khatmah = context.read<KhatmahCubit>().getKhatmah(
            widget.khatmahId,
          );

          if (khatmah == null) {
            return const Center(child: Text('الختمة غير موجودة'));
          }

          return _buildKhatmahDetails(khatmah);
        },
      ),
    );
  }

  Widget _buildKhatmahDetails(KhatmahModel khatmah) {
    final progress = KhatmahCalculator.calculateOverallProgress(
      khatmah.dailyProgress,
    );
    final currentDay = KhatmahCalculator.getCurrentDay(khatmah.dailyProgress);
    final dateFormat = DateFormat('yyyy/MM/dd', 'ar');

    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        // رأس الختمة
        Card(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Text(
                  khatmah.name,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                CircularProgressIndicator(
                  value: progress / 100,
                  strokeWidth: 8,
                  backgroundColor: AppColors.divider,
                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                ),
                SizedBox(height: 8.h),
                Text(
                  '${progress.toStringAsFixed(1)}%',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 16.h),

        // معلومات الختمة
        Card(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'معلومات الختمة',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                _buildInfoRow('تاريخ البداية', dateFormat.format(khatmah.startDate)),
                _buildInfoRow('تاريخ الانتهاء', dateFormat.format(khatmah.endDate)),
                _buildInfoRow('المدة الكلية', '${khatmah.totalDays} يوم'),
                _buildInfoRow(
                  'الحالة',
                  khatmah.isCompleted ? 'مكتملة ✓' : 'جارية',
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 16.h),

        // قائمة الأيام
        Text(
          'الأيام',
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),

        ...khatmah.dailyProgress.map((day) {
          final dayProgress = KhatmahCalculator.calculateDailyProgress(day);
          final isCurrentDay = currentDay?.dayNumber == day.dayNumber;

          return Card(
            color: isCurrentDay ? AppColors.primary.withOpacity(0.1) : null,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: day.isCompleted
                    ? AppColors.success
                    : isCurrentDay
                    ? AppColors.primary
                    : AppColors.divider,
                child: day.isCompleted
                    ? const Icon(Icons.check, color: Colors.white)
                    : Text(
                  '${day.dayNumber}',
                  style: TextStyle(
                    color: isCurrentDay ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
              title: Text('اليوم ${day.dayNumber}'),
              subtitle: Text(dateFormat.format(day.date)),
              trailing: day.isCompleted
                  ? const Icon(Icons.done_all, color: AppColors.success)
                  : Text('${dayProgress.toStringAsFixed(0)}%'),
              onTap: () {
                _showDayDetails(day, khatmah);
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showDayDetails(DailyProgress day, KhatmahModel khatmah) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'اليوم ${day.dayNumber}',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            ...day.juzList.map((juz) {
              return ListTile(
                leading: Icon(
                  juz.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                  color: juz.isCompleted ? AppColors.success : AppColors.divider,
                ),
                title: Text('الجزء ${juz.juzNumber}'),
                subtitle: Text(
                  'من صفحة ${juz.startPage} إلى ${juz.endPage}',
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      context,
                      AppRoutes.quranViewRouter,
                      arguments: {"pageNumber": juz.currentPage},
                    );
                  },
                  child: const Text('قراءة'),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الختمة'),
        content: const Text('هل أنت متأكد من حذف هذه الختمة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              context.read<KhatmahCubit>().deleteKhatmah(widget.khatmahId);
              Navigator.pop(context); // إغلاق الـ dialog
              Navigator.pop(context); // الرجوع للصفحة السابقة
            },
            child: const Text(
              'حذف',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}