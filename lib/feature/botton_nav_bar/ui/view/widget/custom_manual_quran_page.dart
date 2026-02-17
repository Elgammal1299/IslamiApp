// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:quran/quran.dart' as quran;
// import 'package:islami_app/core/constant/app_image.dart';
// import 'package:islami_app/core/widget/header_widget.dart';
// import 'package:islami_app/feature/botton_nav_bar/ui/view_model/surah/surah_cubit.dart';
// import 'package:islami_app/feature/botton_nav_bar/ui/view_model/verse_selection_cubit.dart';
// import 'botton_sheet_item.dart';

// class CustomManualQuranPage extends StatelessWidget {
//   final int pageIndex;

//   const CustomManualQuranPage({super.key, required this.pageIndex});

//   int _getCumulativeAyahNumber(int surahNumber, int ayahNumber) {
//     int cumulativeNumber = 0;
//     for (int i = 1; i < surahNumber; i++) {
//       cumulativeNumber += quran.getVerseCount(i);
//     }
//     return cumulativeNumber + ayahNumber;
//   }

//   void _showAyahOptions(BuildContext context, int surah, int verse) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return BottonSheetItem(
//           surah: surah,
//           verse: verse,
//           cumulativeNumber: _getCumulativeAyahNumber(surah, verse),
//         );
//       },
//     ).then((_) {
//       context.read<VerseSelectionCubit>().clearSelection();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final pageData = quran.getPageData(pageIndex);

//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.w),
//       child: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 children:
//                     pageData.map<Widget>((section) {
//                       final surahNum = section['surah'] as int;
//                       final start = section['start'] as int;
//                       final end = section['end'] as int;

//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           if (start == 1) ...[
//                             HeaderWidget(
//                               e: section,
//                               jsonData: context.read<SurahCubit>().surahs,
//                             ),
//                             if (surahNum != 1 && surahNum != 9)
//                               Padding(
//                                 padding: EdgeInsets.symmetric(vertical: 8.h),
//                                 child: Image.asset(
//                                   AppImage.basmalaImage,
//                                   height: 40.h,
//                                   fit: BoxFit.contain,
//                                 ),
//                               ),
//                           ],
//                           _buildVerses(context, surahNum, start, end),
//                         ],
//                       );
//                     }).toList(),
//               ),
//             ),
//           ),
//           SizedBox(height: 10.h),
//         ],
//       ),
//     );
//   }

//   Widget _buildVerses(BuildContext context, int surahNum, int start, int end) {
//     return BlocBuilder<VerseSelectionCubit, String?>(
//       builder: (context, selectedVerseId) {
//         final List<InlineSpan> spans = [];

//         for (int i = start; i <= end; i++) {
//           final isSelected = selectedVerseId == "$surahNum:$i";
//           final verseText = quran.getVerseQCF(surahNum, i);

//           // Split text and verse end symbol if needed
//           // Most QCF text includes the end symbol at the end.

//           spans.add(
//             TextSpan(
//               text: verseText,
//               recognizer:
//                   LongPressGestureRecognizer()
//                     ..onLongPress = () {
//                       context.read<VerseSelectionCubit>().selectVerse(
//                         surahNum,
//                         i,
//                       );
//                       _showAyahOptions(context, surahNum, i);
//                     },
//               style: TextStyle(
//                 fontFamily: "QCF_P${pageIndex.toString().padLeft(3, "0")}",
//                 fontSize: 22.sp,
//                 height: 2.0,
//                 color: Colors.black,
//                 backgroundColor:
//                     isSelected ? Colors.green.withValues(alpha:0.3) : null,
//               ),
//             ),
//           );

//           // Add a small space between verses
//           spans.add(const TextSpan(text: " "));
//         }

//         return Directionality(
//           textDirection: TextDirection.rtl,
//           child: RichText(
//             textAlign: TextAlign.justify,
//             text: TextSpan(children: spans),
//           ),
//         );
//       },
//     );
//   }
// }
