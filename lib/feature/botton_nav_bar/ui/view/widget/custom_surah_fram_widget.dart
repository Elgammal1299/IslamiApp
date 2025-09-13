import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/quran_screen.dart';
import 'package:quran/quran.dart';

class CustomSurahFramWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomSurahFramWidget({
    super.key,
    required this.widget,
    required this.index,
  });

  final QuranViewScreen widget;
  final int index;

  @override
  Widget build(BuildContext context) {
    final surahName = widget.jsonData[getPageData(index)[0]["surah"] - 1].name;

    int surah = getPageData(index)[0]["surah"];
    int ayah = getPageData(index)[0]["start"];
    int juz = getJuzNumber(surah, ayah);

    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, size: 20.sp, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        surahName,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.titleLarge?.copyWith(
          fontSize: 18.sp,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15), // خلفية شفافة بسيطة
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.white24),
            ),
            child: Text(
              "صفحة $index | جزء $juz",
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
