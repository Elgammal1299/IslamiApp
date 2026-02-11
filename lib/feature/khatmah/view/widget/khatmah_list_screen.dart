import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/feature/khatmah/data/model/khatmah_model.dart';

import 'package:islami_app/feature/khatmah/utils/khatmah_calculator.dart';
import 'package:intl/intl.dart';
import 'package:islami_app/feature/khatmah/view/ui/khatmah_details_screen.dart';
import 'package:islami_app/feature/khatmah/view/ui/khatmah_screen.dart';
import 'package:islami_app/feature/khatmah/view_model/khatmah_cubit.dart';

class KhatmahListScreen extends StatefulWidget {
  const KhatmahListScreen({super.key});

  @override
  State<KhatmahListScreen> createState() => _KhatmahListScreenState();
}

class _KhatmahListScreenState extends State<KhatmahListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<KhatmahCubit>().loadKhatmahs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ختماتي'), centerTitle: true),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => BlocProvider.value(
                    value: context.read<KhatmahCubit>(),
                    child: const CreateKhatmahScreen(),
                  ),
            ),
          );
        },
        label: const Text('إنشاء ختمة جديدة'),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<KhatmahCubit, KhatmahState>(
        listener: (context, state) {
          if (state is KhatmahCreated) {
            context.read<KhatmahCubit>().loadKhatmahs();
          }
        },
        child: BlocBuilder<KhatmahCubit, KhatmahState>(
          builder: (context, state) {
            if (state is KhatmahLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is KhatmahError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64.sp,
                      color: AppColors.error,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      state.message,
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: AppColors.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () {
                        context.read<KhatmahCubit>().loadKhatmahs();
                      },
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }

            if (state is KhatmahLoaded || state is KhatmahCreated) {
              if (state is KhatmahCreated) {
                return const Center(child: CircularProgressIndicator());
              }

              final loadedState = state as KhatmahLoaded;
              if (loadedState.khatmahs.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<KhatmahCubit>().refreshKhatmahs();
                },
                child: ListView(
                  padding: EdgeInsets.all(16.w),
                  children: [
                    // الختمة النشطة
                    if (loadedState.activeKhatmah != null) ...[
                      Text(
                        'الختمة النشطة',
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _buildKhatmahCard(
                        loadedState.activeKhatmah!,
                        isActive: true,
                      ),
                      SizedBox(height: 24.h),
                    ],

                    // الختمات الأخرى
                    if (loadedState.khatmahs.length > 1 ||
                        (loadedState.khatmahs.length == 1 &&
                            loadedState.activeKhatmah == null)) ...[
                      Text(
                        'جميع الختمات',
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      ...loadedState.khatmahs
                          .where((k) => k.id != loadedState.activeKhatmah?.id)
                          .map(
                            (khatmah) => Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: _buildKhatmahCard(khatmah),
                            ),
                          ),
                    ],
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.book_outlined,
            size: 120.sp,
            color: AppColors.primary.withOpacity(0.3),
          ),
          SizedBox(height: 24.h),
          Text(
            'لا توجد ختمات بعد',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'ابدأ رحلتك مع القرآن الكريم',
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => BlocProvider.value(
                        value: context.read<KhatmahCubit>(),
                        child: const CreateKhatmahScreen(),
                      ),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('إنشاء ختمة جديدة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKhatmahCard(KhatmahModel khatmah, {bool isActive = false}) {
    final progress = KhatmahCalculator.calculateOverallProgress(
      khatmah.dailyProgress,
    );
    final currentDay = KhatmahCalculator.getCurrentDay(khatmah.dailyProgress);
    final remainingDays = KhatmahCalculator.calculateRemainingDays(
      khatmah.dailyProgress,
    );
    final dateFormat = DateFormat('yyyy/MM/dd', 'ar');

    return Card(
      elevation: isActive ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side:
            isActive
                ? BorderSide(color: AppColors.primary, width: 2)
                : BorderSide.none,
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => BlocProvider.value(
                    value: context.read<KhatmahCubit>(),
                    child: KhatmahDetailsScreen(khatmahId: khatmah.id),
                  ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الرأس
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      khatmah.name,
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isActive)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        'نشطة',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (khatmah.isCompleted)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 16.sp,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'مكتملة',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              SizedBox(height: 12.h),

              // شريط التقدم
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                  SizedBox(height: 8.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: LinearProgressIndicator(
                      value: progress / 100,
                      minHeight: 8.h,
                      backgroundColor: AppColors.divider,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // المعلومات
              Row(
                children: [
                  Expanded(
                    child: _buildInfoChip(
                      Icons.calendar_today,
                      '${khatmah.totalDays} يوم',
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _buildInfoChip(
                      Icons.timelapse,
                      '$remainingDays متبقي',
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8.h),

              Row(
                children: [
                  Expanded(
                    child: _buildInfoChip(
                      Icons.play_arrow,
                      dateFormat.format(khatmah.startDate),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _buildInfoChip(
                      Icons.flag,
                      dateFormat.format(khatmah.endDate),
                    ),
                  ),
                ],
              ),

              if (currentDay != null && !khatmah.isCompleted) ...[
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.today, color: AppColors.primary, size: 20.sp),
                      SizedBox(width: 8.w),
                      Text(
                        'اليوم ${currentDay.dayNumber} من ${khatmah.totalDays}',
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: AppColors.textSecondary),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              label,
              style: context.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}