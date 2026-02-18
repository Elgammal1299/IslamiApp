import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/feature/home/ui/view/azkar/data/model/category_model.dart';
import 'package:islami_app/feature/home/ui/view/azkar/view/azkar_and_doa_list_screen.dart';

class CustomAzkarAndDoaList extends StatelessWidget {
  const CustomAzkarAndDoaList({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AzkarAndDoaListScreen(category: category),
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
                 category.name,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontSize: 20.sp,fontFamily: 'Amiri'),
                ),
              ),
               Text(
                      '${category.supplications.length} حديث',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(fontSize: 18.sp, fontFamily: 'Amiri'),
                    ),
    
            ],
          ),
        ),
      ),
    );

  }
}
