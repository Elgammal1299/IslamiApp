import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami_app/feature/home/data/model/hadith_40_model.dart';
import 'package:islami_app/feature/home/ui/view/hadith_40_details_screen.dart';

class CustomHadith40ListViewItem extends StatelessWidget {
  const CustomHadith40ListViewItem({super.key, required this.model});

  final Hadith40Model model;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Hadith40DetailsScreen(model: model),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(top: 12.h),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  model.category,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 20.sp,
                    fontFamily: 'Amiri',
                  ),
                ),
              ),
               Icon(Icons.arrow_forward_ios, size: 16,color: Theme.of(context).primaryColorDark,),
            ],
          ),
        ),
      ),
    );
  }
}
