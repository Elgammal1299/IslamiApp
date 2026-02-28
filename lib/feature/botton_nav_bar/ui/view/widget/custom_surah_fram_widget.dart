// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:islami_app/core/constant/app_color.dart';
// import 'package:islami_app/core/extension/theme_text.dart';
// import 'package:islami_app/core/router/app_routes.dart';
// import 'package:islami_app/feature/botton_nav_bar/ui/view/quran_screen.dart';
// import 'package:quran/quran.dart' as quran;

// class CustomSurahFramWidget extends StatelessWidget
//     implements PreferredSizeWidget {
//   const CustomSurahFramWidget({super.key, required this.index});

//   final int index;

//   @override
//   Widget build(BuildContext context) {
//     final pos = QuranPageIndex.firstAyahOnPage(index);
//     final surahName = quran.getSurahNameArabic(pos.surah);
//     final juz = quran.getJuzNumber(pos.surah, pos.ayah);

//     return AppBar(
//       centerTitle: false,
//       backgroundColor: AppColors.primary,
//       elevation: 0,
//       // flexibleSpace: Container(
//       //   decoration: BoxDecoration(
//       //     gradient: LinearGradient(
//       //       begin: Alignment.topCenter,
//       //       end: Alignment.bottomCenter,
//       //       colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
//       //     ),
//       //   ),
//       // ),
//       leading: IconButton(
//         icon: Icon(Icons.arrow_back_ios, size: 20.sp, color:Theme.of(context).secondaryHeaderColor),
//         onPressed: () => Navigator.pop(context),
//       ),
//       title: Text(
//         surahName,
//         overflow: TextOverflow.ellipsis,
//         style: context.textTheme.titleLarge?.copyWith(
//           fontSize: 18.sp,
//           color: Theme.of(context).secondaryHeaderColor,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       actions: [
//         // Padding(
//         //   padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 8.h),
//         //   child: Container(
//         //     padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
//         //     decoration: BoxDecoration(
//         //       color: Colors.black.withValues(alpha: 0.15),
//         //       borderRadius: BorderRadius.circular(8.r),
//         //       border: Border.all(color:Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.3)),
//         //     ),
//         //     child: Text(
//         //       "صفحة $index | جزء $juz",
//         //       style: TextStyle(
//         //         fontSize: 12.sp,
//         //         color:Theme.of(context).secondaryHeaderColor,
//         //         fontWeight: FontWeight.w500,
//         //       ),
//         //     ),
//         //   ),
//         // ),
        
//         Padding(
//           padding: EdgeInsets.symmetric(vertical: 8.h),
//           child: IconButton(
//             onPressed: () {
//             },
//             icon:  Icon(Icons.bookmark_add_rounded, color: Theme.of(context).secondaryHeaderColor),
//           ),
//         ),
//         Padding(
//           padding: EdgeInsets.symmetric(vertical: 8.h),
//           child: IconButton(
//             onPressed: () {
//               Navigator.pushNamed(context, AppRoutes.searchRouter);
//             },
//             icon:  Icon(Icons.search, color: Theme.of(context).secondaryHeaderColor),
//           ),
//         ),
//         // Padding(
//         //   padding: EdgeInsets.symmetric(vertical: 8.h),
//         //   child: IconButton(
//         //     onPressed: () {
//         //       Scaffold.of(context).openEndDrawer();
//         //     },
//         //     icon:  Icon(Icons.menu, color: Theme.of(context).secondaryHeaderColor),
//         //   ),
//         // ),
//       ],
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }

// // class QuranDrawer extends StatelessWidget {
// //   final int currentSurahIndex;

// //   const QuranDrawer({Key? key, required this.currentSurahIndex}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Drawer(
// //       child: ListView.builder(
// //         itemCount: quran.totalSurahCount,
// //         itemBuilder: (context, surahIndex) {
// //           final surahName = quran.getSurahNameArabic(surahIndex + 1);
// //           return ListTile(
// //             title: Text(
// //               surahName,
// //               style: TextStyle(
// //                 fontWeight: surahIndex + 1 == currentSurahIndex
// //                     ? FontWeight.bold
// //                     : FontWeight.normal,
// //               ),
// //             ),
// //             onTap: () {
// //               Navigator.pop(context); // Close the drawer
// //               Navigator.pushReplacement(
// //                 context,
// //                 MaterialPageRoute(
// //                   builder: (context) => QuranViewScreen(
// //                     pageNumber: quran.getPageNumber(surahIndex + 1, 1),
// //                   ),
// //                 ),
// //               );
// //             },
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/core/router/app_routes.dart';
import 'package:islami_app/core/services/setup_service_locator.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/quran_screen.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/bookmarks/bookmark_cubit.dart';
import 'package:quran/quran.dart' as quran;

class CustomSurahFramWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomSurahFramWidget({super.key, required this.index});

  final int index;

  void _showBookmarksPopup(BuildContext context) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50.h,
        right: 60.w,
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              overlayEntry.remove();
            },
            child: Container(
              color: Colors.transparent,
              child: Stack(
                children: [
                  const BookmarksPopupMenu(),
                  // Close button or tap outside to close
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        overlayEntry.remove();
                      },
                      child: const SizedBox(
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // إغلاق الـ popup بعد 10 ثواني أو عند الضغط خارجه
    Future.delayed(const Duration(seconds: 4), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pos = QuranPageIndex.firstAyahOnPage(index);
    final surahName = quran.getSurahNameArabic(pos.surah);
    final juz = quran.getJuzNumber(pos.surah, pos.ayah);

    return AppBar(
      centerTitle: false,
      backgroundColor: AppColors.primary,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, size: 20.sp, color:Theme.of(context).secondaryHeaderColor),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        surahName,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.titleLarge?.copyWith(
          fontSize: 18.sp,
          color: Theme.of(context).secondaryHeaderColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: IconButton(
            onPressed: () {
              _showBookmarksPopup(context);
            },
            icon: Icon(Icons.bookmark_add_rounded, color: Theme.of(context).secondaryHeaderColor),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.searchRouter);
            },
            icon:  Icon(Icons.search, color: Theme.of(context).secondaryHeaderColor),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}


class BookmarksPopupMenu extends StatefulWidget {
  const BookmarksPopupMenu({super.key});

  @override
  State<BookmarksPopupMenu> createState() => _BookmarksPopupMenuState();
}

class _BookmarksPopupMenuState extends State<BookmarksPopupMenu> {
  @override
  void initState() {
    super.initState();
    // تحميل البوكمارات عند فتح الـ popup
    sl<BookmarkCubit>().loadBookmarks();
  }

  String _truncateText(String text, int maxLength) {
    if (text.length > maxLength) {
      return '${text.substring(0, maxLength)}...';
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    // استخدم BlocProvider.value لتوفير الـ Cubit من Service Locator
    return BlocProvider<BookmarkCubit>.value(
      value: sl<BookmarkCubit>(),
      child: BlocBuilder<BookmarkCubit, BookmarkState>(
        builder: (context, state) {
          if (state is BookmarksLoading) {
            return Container(
              width: 300.w,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is BookmarksError) {
            return Container(
              width: 300.w,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                'حدث خطأ في تحميل البيانات',
                style: context.textTheme.bodyMedium,
                textDirection: TextDirection.rtl,
              ),
            );
          }

          if (state is BookmarksLoaded) {
            if (state.bookmarks.isEmpty) {
              return Container(
                width: 300.w,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12.r),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black.withOpacity(0.2),
                  //     blurRadius: 8,
                  //     offset: const Offset(0, 4),
                  //   ),
                  // ],
                ),
                child: Center(
                  child: Text(
                    'لا توجد مرجعيات',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).primaryColorDark,
                      fontFamily: 'Amiri',
                      fontSize: 18,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              );
            }

            return Container(
              width: 320.w,
              // constraints: BoxConstraints(maxHeight: 400.h),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12.r),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black.withOpacity(0.2),
                //     blurRadius: 12,
                //     offset: const Offset(0, 6),
                //   ),
                // ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.r),
                          topRight: Radius.circular(12.r),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.bookmark,
                            color: Theme.of(context).primaryColorDark,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'المرجعيات',
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColorDark,

                              fontFamily: 'Amiri',
                              fontSize: 18,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                          const Spacer(),
                          Text(
                            '${state.bookmarks.length}',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).primaryColorDark,
                              fontFamily: 'Amiri',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // List Items
                    ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.bookmarks.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        color: Theme.of(context).dividerColor.withOpacity(0.3),
                      ),
                      itemBuilder: (context, index) {
                        final bookmark = state.bookmarks[index];
                        final parts = bookmark.split(':');
                        final surah = int.parse(parts[0]);
                        final ayah = int.parse(parts[1]);
                        final verseText =
                            quran.getVerse(surah, ayah, verseEndSymbol: false);
                        final surahName = quran.getSurahNameArabic(surah);
                        final truncatedVerse = _truncateText(verseText, 40);

                        return InkWell(
                          onTap: () {
                            final pageNumber = quran.getPageNumber(surah, ayah);
                            Navigator.pop(context); // Close popup first
                            Navigator.pushNamed(
                              context,
                              AppRoutes.quranViewRouter,
                              arguments: {"pageNumber": pageNumber},
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 10.h,
                            ),
                            child: Row(
                              textDirection: TextDirection.rtl,
                              children: [
                                // Verse Number Badge
                                // Container(
                                //   width: 32.w,
                                //   height: 32.w,
                                //   decoration: BoxDecoration(
                                //     color: Theme.of(context)
                                //         .primaryColor
                                //         .withOpacity(0.15),
                                //     shape: BoxShape.circle,
                                //   ),
                                //   child: Center(
                                    // child: Text(
                                    //   '$ayah',
                                    //   style: TextStyle(
                                    //     fontSize: 11.sp,
                                    //     fontWeight: FontWeight.bold,
                                    //     color: Theme.of(context).primaryColor,
                                    //   ),
                                    // ),
                                //   ),
                                // ),
                                // SizedBox(width: 10.w),
                                // Verse Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'سورة $surahName',
                                            style:
                                                context.textTheme.bodySmall?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                  fontFamily: 'Amiri',
                                                  fontSize: 16,
                                                ),
                                            textDirection: TextDirection.rtl,
                                          ),
                                          SizedBox(width: 10.w),
                                          Text(
                                      'آية $ayah',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColorDark,
                                        fontFamily: 'Amiri',
                                      ),
                                    ),
                                        ],
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        truncatedVerse,
                                        style:
                                            context.textTheme.bodySmall?.copyWith(
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                              fontFamily: 'Amiri',
                                              fontSize: 14,
                                              height: 1.3,
                                            ),
                                        textDirection: TextDirection.rtl,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                // Delete Button
                                GestureDetector(
                                  onTap: () {
                                    sl<BookmarkCubit>()
                                        .removeBookmark(surah, ayah);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('تم إزالة المرجعية'),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    
                                    Icons.close_rounded,
                                    size: 18.sp,
                                    color: Colors.red.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}