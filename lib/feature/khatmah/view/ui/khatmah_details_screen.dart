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
import 'package:islami_app/feature/khatmah/view/widget/daily_ward_completion_dialog.dart';

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
            itemBuilder:
                (context) => [
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
      body: BlocConsumer<KhatmahCubit, KhatmahState>(
        listener: (context, state) {
          // الاستماع لحالة إتمام الورد اليومي
          if (state is KhatmahDailyCompleted) {
            // التأكد من أن الختمة الحالية هي المقصودة
            if (state.khatmahId == widget.khatmahId) {
              _showDailyCompletionDialog(state.dayNumber);
            }
          }
        },
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

  /// عرض dialog إتمام الورد اليومي
  void _showDailyCompletionDialog(int dayNumber) {
    showDialog(
      context: context,
      barrierDismissible: false, // لا يمكن إغلاقه بالضغط خارجه
      builder:
          (dialogContext) => BlocProvider.value(
            value: context.read<KhatmahCubit>(),
            child: DailyWardCompletionDialog(
              khatmahId: widget.khatmahId,
              dayNumber: dayNumber,
              cubit: context.read<KhatmahCubit>(),
            ),
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
        Container(
          padding: EdgeInsets.all(16.w),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                khatmah.name,
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 16.h),
              LinearProgressIndicator(
                value: progress / 100,
                backgroundColor: AppColors.divider,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
              SizedBox(height: 8.h),
              Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('التقدم', style: context.textTheme.bodyMedium),
                    Text(
                      '${progress.toStringAsFixed(1)}%',
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // إعدادات الإشعارات
        Card(
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('الإشعارات اليومية'),
                subtitle: Text(
                  khatmah.isNotificationEnabled
                      ? 'منبه في: ${khatmah.notificationTime != null ? TimeOfDay.fromDateTime(khatmah.notificationTime!).format(context) : 'غير محدد'}'
                      : 'التذكير اليومي معطل',
                ),
                value: khatmah.isNotificationEnabled,
                activeColor: AppColors.primary,
                onChanged: (value) {
                  context.read<KhatmahCubit>().updateNotificationSettings(
                    khatmahId: khatmah.id,
                    isEnabled: value,
                  );
                },
              ),
              if (khatmah.isNotificationEnabled)
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                  child: InkWell(
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime:
                            khatmah.notificationTime != null
                                ? TimeOfDay.fromDateTime(
                                  khatmah.notificationTime!,
                                )
                                : const TimeOfDay(hour: 20, minute: 0),
                      );
                      if (picked != null) {
                        if (!mounted) return;
                        context.read<KhatmahCubit>().updateNotificationSettings(
                          khatmahId: khatmah.id,
                          isEnabled: true,
                          notificationTime: DateTime(
                            0,
                            0,
                            0,
                            picked.hour,
                            picked.minute,
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 8.w),
                          const Text('تغيير وقت التنبيه'),
                          const Spacer(),
                          const Icon(
                            Icons.edit,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
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
            color:
                isCurrentDay ? AppColors.primary.withValues(alpha: 0.1) : null,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    day.isCompleted
                        ? AppColors.success
                        : isCurrentDay
                        ? AppColors.primary
                        : AppColors.divider,
                child:
                    day.isCompleted
                        ? const Icon(Icons.check, color: Colors.white)
                        : Text(
                          '${day.dayNumber}',
                          style: TextStyle(
                            color:
                                isCurrentDay
                                    ? Colors.white
                                    : AppColors.textPrimary,
                          ),
                        ),
              ),
              title: Text('اليوم ${day.dayNumber}'),
              subtitle: Text(dateFormat.format(day.date)),
              trailing:
                  day.isCompleted
                      ? const Icon(Icons.done_all, color: AppColors.success)
                      : Text('${dayProgress.toStringAsFixed(0)}%'),
              onTap: () {
                _showDayDetails(day, khatmah);
              },
            ),
          );
        }),
        SizedBox(height: 12.h),
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
                _buildInfoRow(
                  'تاريخ البداية',
                  dateFormat.format(khatmah.startDate),
                ),
                _buildInfoRow(
                  'تاريخ الانتهاء',
                  dateFormat.format(khatmah.endDate),
                ),
                _buildInfoRow('المدة الكلية', '${khatmah.totalDays} يوم'),
                _buildInfoRow(
                  'الحالة',
                  khatmah.isCompleted ? 'مكتملة ✓' : 'جارية',
                ),
              ],
            ),
          ),
        ),
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
      builder:
          (context) => Container(
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
                      juz.isCompleted
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color:
                          juz.isCompleted
                              ? AppColors.success
                              : AppColors.divider,
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
                          arguments: {
                            "pageNumber": juz.currentPage,
                            "isKhatmah": true,
                            "khatmahId": khatmah.id,
                          },
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
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('حذف الختمة'),
            content: const Text('هل أنت متأكد من حذف هذه الختمة؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () {
                  context.read<KhatmahCubit>().deleteKhatmah(widget.khatmahId);
                  Navigator.pop(dialogContext); // إغلاق الـ dialog
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
