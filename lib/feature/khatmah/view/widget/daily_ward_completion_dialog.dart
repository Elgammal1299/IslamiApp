import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/feature/khatmah/view_model/khatmah_cubit.dart';

/// Dialog يظهر عند إتمام الورد اليومي
class DailyWardCompletionDialog extends StatelessWidget {
  final String khatmahId;
  final int dayNumber;
  final KhatmahCubit cubit;

  const DailyWardCompletionDialog({
    super.key,
    required this.khatmahId,
    required this.dayNumber,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // أيقونة النجاح
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 50.sp,
              ),
            ),

            SizedBox(height: 20.h),

            // العنوان
            Text(
              '🎉 ماشاء الله!',
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 12.h),

            // الرسالة
            Text(
              'لقد أتممت ورد اليوم $dayNumber بنجاح',
              style: context.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 24.h),

            // الخيارات
            Column(
              children: [
                // خيار 1: إتمام الورد (حفظ فقط)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // حفظ إتمام الورد
                      cubit.completeDailyWard(
                        khatmahId: khatmahId,
                        dayNumber: dayNumber,
                      );
                      Navigator.of(context).pop();

                      // رسالة تأكيد
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('✅ تم حفظ إتمام الورد بنجاح'),
                          backgroundColor: AppColors.success,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.save),
                    label: Text(
                      'إتمام الورد',
                      style: context.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 12.h),

                // خيار 2: إتمام الورد والتكملة
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // حفظ إتمام الورد
                      cubit.completeDailyWard(
                        khatmahId: khatmahId,
                        dayNumber: dayNumber,
                      );
                      Navigator.of(context).pop();

                      // الانتقال لليوم التالي
                      final khatmah = cubit.getKhatmah(khatmahId);

                      if (khatmah != null && dayNumber < khatmah.totalDays) {
                        // رسالة تأكيد
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '✅ تم حفظ الورد. يمكنك الآن متابعة اليوم ${dayNumber + 1}',
                            ),
                            backgroundColor: AppColors.primary,
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      } else {
                        // الختمة اكتملت
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('🎊 مبروك! لقد أتممت الختمة كاملة'),
                            backgroundColor: AppColors.accent,
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.forward),
                    label: Text(
                      'إتمام الورد والتكملة',
                      style: context.textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 12.h),

                // زر الإلغاء
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'إلغاء',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
