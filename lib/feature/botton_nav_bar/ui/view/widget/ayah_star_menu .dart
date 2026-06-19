import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/services/bookmark_manager.dart';
import 'package:islami_app/core/services/setup_service_locator.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/widget/verse_action_handler.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/verse_selection_cubit.dart';
import 'package:star_menu/star_menu.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AyahStarMenu {
  static Future<void> show({
    required BuildContext context,
    required int surah,
    required int ayah,
    required LongPressStartDetails details,
  }) async {
    final isBookmarked = await sl<BookmarkManager>().isBookmarked(surah, ayah);

    final items = [
      buildMenuItem(Icons.play_arrow, "استماع", Colors.blue),
      buildMenuItem(Icons.menu_book, "التفسير", Colors.green),
      buildMenuItem(Icons.copy, "نسخ", Colors.orange),
      buildMenuItem(
        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
        isBookmarked ? "إزالة" : "حفظ",
        Colors.purple,
      ),
      buildMenuItem(Icons.share, "نص", Colors.teal),
      buildMenuItem(Icons.image, "صورة", Colors.redAccent),
    ];

    if (!context.mounted) return;

    StarMenuOverlay.displayStarMenu(
      
      context,
      StarMenu(
        parentContext: context,
        params: StarMenuParameters(
          shape: MenuShape.circle,
          circleShapeParams: CircleShapeParams(
            radiusX: 90.w,
            radiusY: 90.w,
            startAngle: -90,
            endAngle: 270,
          ),
          openDurationMs: 400,
          centerOffset:
              details.globalPosition -
              Offset(
                MediaQuery.of(context).size.width / 2,
                MediaQuery.of(context).size.height / 2,
              ),
          useScreenCenter: true,
        ),
        items: items,
        onItemTapped: (index, controller) {
          controller.closeMenu!();


          VerseActionHandler.handleAction(
            index: index,
            context: context,
            surah: surah,
            ayah: ayah,
          );
        },
      ),
    );
  }
}

Widget buildMenuItem(IconData icon, String label, Color color) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 50.w,
        height: 50.w,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white),
      ),
      SizedBox(height: 4.h),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Text(label,style: TextStyle(color: Colors.white, fontSize: 12.sp,fontFamily: 'Amiri'),),
      ),
    ],
  );
}
