import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/core/router/app_routes.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/quran_screen.dart';
import 'package:quran/quran.dart' as quran;

class CustomSurahFramWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomSurahFramWidget({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final pos = QuranPageIndex.firstAyahOnPage(index);
    final surahName = quran.getSurahNameArabic(pos.surah);
    final juz = quran.getJuzNumber(pos.surah, pos.ayah);

    return AppBar(
      centerTitle: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
          ),
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, size: 20.sp, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        surahName,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.titleLarge?.copyWith(
          fontSize: 18.sp,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 8.h),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.black.withValues(alpha: 0.3)),
            ),
            child: Text(
              "صفحة $index | جزء $juz",
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.searchRouter);
            },
            icon: const Icon(Icons.search, color: Colors.black),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
