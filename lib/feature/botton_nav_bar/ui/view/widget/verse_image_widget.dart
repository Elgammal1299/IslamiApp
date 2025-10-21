// import 'dart:ui' as m;

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:islami_app/core/constant/app_image.dart';
// import 'package:islami_app/feature/botton_nav_bar/ui/view/quran_screen.dart';
// import 'package:quran/quran.dart';

// class VerseImageWidget extends StatelessWidget {
//   final int surah;
//   final int verse;
//   final String verseText;
//   final int surahNumber;
//   final int pageIndex;

//   const VerseImageWidget({
//     super.key,
//     required this.surah,
//     required this.verse,
//     required this.verseText,
//     required this.surahNumber,
//     required this.pageIndex,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Container(
//       color: theme.focusColor, // Light background like Quran screen
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SizedBox(
//             height: 80.h,
//             child: Stack(
//               children: [
//                 Center(
//                   child: Image.asset(
//                     AppImage.surahFramImage,
//                     height: 80.h,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Center(
//                       child: RichText(
//                         text: TextSpan(
//                           text: surahNumber.toString(),

//                           style: TextStyle(
//                             fontFamily: "arsura",
//                             fontSize: 22,
//                             color: Theme.of(context).primaryColorDark,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           Padding(
//             padding: EdgeInsets.only(right: 15.w, left: 15.w),
//             child: Text(
//               verseText,
//               style: TextStyle(
//                 height: PageConfig.getLineHeight(
//                   pageIndex,
//                   MediaQuery.of(context).size.height,
//                 ),
//                 fontFamily: "QCF_P${pageIndex.toString().padLeft(3, "0")}",
//                 fontSize: PageConfig.getFontSize(pageIndex),
//                 color: theme.primaryColorDark,
//               ),
//               textDirection: m.TextDirection.rtl,
//               textAlign: PageConfig.getTextAlign(pageIndex),
//               softWrap: true,
//               locale: const Locale("ar"),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
