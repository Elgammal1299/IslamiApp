import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/feature/home/ui/view/azkar/data/repo/azkar_random_repo.dart';
import 'package:islami_app/feature/home/ui/view/azkar/view_model/azkar_random_cubit/azkar_random_cubit.dart';

class AzkarRandomScreen extends StatelessWidget {
  const AzkarRandomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AzkarRandomCubit(AzkarRandomRepo())..loadAdhkar(),
      child: BlocBuilder<AzkarRandomCubit, AzkarRandomState>(
        builder: (context, state) {
          if (state is DikrLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AzkarRandomLoaded) {
            final dikr = state.dikr;

            return Center(
              child: Container(
                width: 0.9.sw,
                height: 170.h,
                constraints: BoxConstraints(maxWidth: 500.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 1.w,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 10.r,
                      offset: Offset(0, 4.h),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        child: Center(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: AutoSizeText(
                              dikr.dikr,
                              key: ValueKey(dikr.dikr),
                              textAlign: TextAlign.center,
                              maxLines: 6,
                              overflow: TextOverflow.ellipsis,
                              minFontSize: 12,
                              maxFontSize: 20,
                              stepGranularity: 1,
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(height: 1.8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(20.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 20.sp,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              context.read<AzkarRandomCubit>().previousDikr();
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 20.sp,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              context.read<AzkarRandomCubit>().nextDikr();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is AzkarRandomError) {
            return Center(child: Text('حدث خطأ: ${state.message}'));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
