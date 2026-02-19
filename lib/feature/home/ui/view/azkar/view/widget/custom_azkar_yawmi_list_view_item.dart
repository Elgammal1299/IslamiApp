import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami_app/feature/home/ui/view/azkar/data/model/azkar_yawmi_model.dart';
import 'package:islami_app/feature/home/ui/view/azkar/view/supplication_reader_screen.dart';

class CustomAzkarYawmiListViewItem extends StatelessWidget {
  const CustomAzkarYawmiListViewItem({super.key, required this.model});

  final AzkarCategoryModel model;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => SupplicationReaderScreen(supplications: model.array),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(top: 12.h),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 20.h),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16.r),
       
          ),
          child: Row(
            children: [
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  model.category,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontSize: 20.sp,fontFamily: 'Amiri'),
                ),
              ),
               Text(
                      '${model.array.length} ذكر',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(fontSize: 14.sp),
                    ),
       
            ],
          ),
        ),
      ),
    );
  }
}
