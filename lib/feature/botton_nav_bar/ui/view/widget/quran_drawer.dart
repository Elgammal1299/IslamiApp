import 'package:flutter/material.dart';
import 'package:qcf_quran_plus/qcf_quran_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami_app/core/extension/theme_text.dart';

class QuranDrawer extends StatelessWidget {
  final int currentSurahIndex;
  final ValueChanged<int> onSurahSelected;

  const QuranDrawer({
    super.key,
    required this.currentSurahIndex,
    required this.onSurahSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              child: Text(
                'فهرس السور',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Amiri',
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
            ),
            Divider(color: Theme.of(context).dividerColor),
            Expanded(
              child: ListView.builder(
                itemCount: 114,
                itemBuilder: (context, index) {
                  final surahIndex = index + 1;
                  final surahName = getSurahNameArabic(surahIndex);
                  final isSelected = surahIndex == currentSurahIndex;
                  return ListTile(
                    selected: isSelected,
                    selectedTileColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    title: Text(
                      surahName,
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 18.sp,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected 
                            ? Theme.of(context).primaryColor 
                            : Theme.of(context).primaryColorDark,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    onTap: () => onSurahSelected(surahIndex),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
