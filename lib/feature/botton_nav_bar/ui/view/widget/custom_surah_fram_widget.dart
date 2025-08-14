import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/quran_screen.dart';
import 'package:quran/quran.dart';

class CustomSurahFramWidget extends StatelessWidget {
  const CustomSurahFramWidget({
    super.key,
    required this.widget,
    required this.index,
  });

  final QuranViewScreen widget;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.sw, // عرض الشاشة بالكامل

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ✅ الجزء الأيسر: زر الرجوع واسم السورة
          SizedBox(
            width: 0.35.sw, // 35% من عرض الشاشة
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 20.sp,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                Flexible(
                  child: Text(
                    widget.jsonData[getPageData(index)[0]["surah"] - 1].name,
                    style: context.textTheme.titleLarge?.copyWith(
                      fontSize: 18.sp,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ✅ الجزء الأيمن: صندوق رقم الصفحة
          EasyContainer(
            borderRadius: 10.r,
            color: Theme.of(context).secondaryHeaderColor,
            showBorder: true,
            height: 28.h,
            width: 110.w,
            padding: 0,
            margin: 0,
            child: Center(
              child: Text(
                "صفحة $index",
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontSize: 12.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
