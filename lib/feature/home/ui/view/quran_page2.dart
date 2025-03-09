// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:islami_app/feature/home/data/model/sura.dart';
// // import 'package:quran/quran.dart' as quran;
// // import 'package:share_plus/share_plus.dart';

// // class QuranViewPage extends StatelessWidget {
// //   final SurahModel surah;

// //   const QuranViewPage({Key? key, required this.surah}) : super(key: key);

// // // تجميع الآيات حسب الصفحة
// // Map<int, List<int>> groupAyahsByPage() {
// //   Map<int, List<int>> pages = {};

// //   for (int ayah = 1; ayah <= surah.numberOfAyahs; ayah++) {
// //     int pageNumber = quran.getPageNumber(surah.number, ayah);
// //     if (!pages.containsKey(pageNumber)) {
// //       pages[pageNumber] = [];
// //     }
// //     pages[pageNumber]!.add(ayah);
// //   }

// //   return pages;
// // }

// // // استخدام التجميع في العرض
// // // Widget buildPagedView() {
// // //   final pageGroups = groupAyahsByPage();

// // //   return ListView.builder(
// // //     itemCount: pageGroups.length,
// // //     itemBuilder: (context, index) {
// // //       final pageNumber = pageGroups.keys.elementAt(index);
// // //       final ayahsInPage = pageGroups[pageNumber]!;

// // //       return Column(
// // //         children: [
// // //           Text('صفحة $pageNumber'),
// // //           ...ayahsInPage.map((ayahNumber) =>
// // //             // عرض الآية كما في الكود السابق
// // //             Container(
// // //               margin: const EdgeInsets.all(8),
// // //               padding: const EdgeInsets.all(16),
// // //               decoration: BoxDecoration(
// // //                 borderRadius: BorderRadius.circular(10),
// // //                 border: Border.all(color: Colors.grey.shade300),
// // //             )),
// // //           ).toList()
// // //         ],
// // //       );
// // //     },
// // //   );
// // // }

// // Widget _buildBismillah() {
// //   // لا نعرض البسملة في سورة التوبة
// //   if (surah.number != 9) {
// //     return Container(
// //       alignment: Alignment.center,
// //       padding: const EdgeInsets.all(16),
// //       child: Text(
// //         quran.basmala,
// //         style: const TextStyle(
// //           fontSize: 24,
// //           fontFamily: 'Uthmanic',
// //         ),
// //       ),
// //     );
// //   }
// //   return const SizedBox.shrink();
// // }

// // Widget _buildAyahActions(int ayahNumber, BuildContext context) {
// //   return Row(
// //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //     children: [
// //       IconButton(
// //         icon: const Icon(Icons.copy),
// //         onPressed: () {
// //           Clipboard.setData(ClipboardData(
// //             text: quran.getVerse(surah.number, ayahNumber),
// //           ));
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(content: Text('تم نسخ الآية')),
// //           );
// //         },
// //       ),
// //       IconButton(
// //         icon: const Icon(Icons.bookmark_border),
// //         onPressed: () {
// //           // إضافة الآية للمفضلة
// //         },
// //       ),
// //       IconButton(
// //         icon: const Icon(Icons.share),
// //         onPressed: () {
// //           Share.share(quran.getVerse(surah.number, ayahNumber));
// //         },
// //       ),
// //     ],
// //   );
// // }
// // Widget _buildSurahInfo() {
// //   return Container(
// //     padding: const EdgeInsets.all(16),
// //     child: Column(
// //       children: [
// //         Text('عدد الآيات: ${surah.numberOfAyahs}'),
// //         Text('نوع السورة: ${surah.revelationType}'),
// //         // يمكنك استخدام quran package للحصول على معلومات إضافية
// //       ],
// //     ),
// //   );
// // }

// // @override
// // Widget build(BuildContext context) {
// //   return Scaffold(
// //     appBar: AppBar(
// //       title: Text(surah.name),
// //       centerTitle: true,
// //     ),
// //     body: ListView(
// //       children: [
// //         _buildSurahInfo(),
// //         _buildBismillah(),
// //         buildPagedView(context),
// //       ],
// //     ),
// //   );
// // }

// // Widget buildPagedView(BuildContext context) {
// //   final pageGroups = groupAyahsByPage();

// //   return Column(
// //     children: pageGroups.entries.map((entry) {
// //       final pageNumber = entry.key;
// //       final ayahsInPage = entry.value;

// //       return Column(
// //         children: [
// //           // عنوان الصفحة
// //           Container(
// //             padding: const EdgeInsets.all(8),
// //             color: Colors.grey.shade200,
// //             child: Text(
// //               'صفحة $pageNumber',
// //               style: const TextStyle(
// //                 fontSize: 16,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ),
// //           // الآيات في هذه الصفحة
// //           ...ayahsInPage.map((ayahNumber) =>
// //             Container(
// //               margin: const EdgeInsets.all(8),
// //               padding: const EdgeInsets.all(16),
// //               decoration: BoxDecoration(
// //                 borderRadius: BorderRadius.circular(10),
// //                 border: Border.all(color: Colors.grey.shade300),
// //               ),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.end,
// //                 children: [
// //                   // نص الآية
// //                   Text(
// //                     quran.getVerse(surah.number, ayahNumber, verseEndSymbol: true),
// //                     style: const TextStyle(
// //                       fontSize: 20,
// //                       fontFamily: 'Uthmanic',
// //                     ),
// //                     textDirection: TextDirection.rtl,
// //                   ),
// //                   const SizedBox(height: 8),
// //                   // معلومات الآية
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       Text(
// //                         'آية $ayahNumber',
// //                         style: TextStyle(color: Colors.grey.shade600),
// //                       ),
// //                       Text(
// //                         'جزء ${quran.getJuzNumber(surah.number, ayahNumber)}',
// //                         style: TextStyle(color: Colors.grey.shade600),
// //                       ),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 8),
// //                   // أزرار التفاعل
// //                   _buildAyahActions(ayahNumber, context),
// //                 ],
// //               ),
// //             ),
// //           ).toList(),
// //         ],
// //       );
// //     }).toList(),
// //   );
// // }
// // }
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:islami_app/core/widget/basmallah.dart';
// import 'package:islami_app/core/widget/header_widget.dart';
// import 'package:islami_app/feature/home/data/model/sura.dart';
// import 'package:quran/quran.dart' as quran;
// import 'package:wakelock_plus/wakelock_plus.dart';

// class QuranViewPage extends StatefulWidget {
//   final int pageNumber;
//   final SurahModel jsonData;

//   const QuranViewPage({
//     Key? key,
//     required this.pageNumber,
//     required this.jsonData,
//   }) : super(key: key);

//   @override
//   State<QuranViewPage> createState() => _QuranViewPageState();
// }

// class _QuranViewPageState extends State<QuranViewPage> {
//   late PageController _pageController;
//   late int currentPage;
//   String selectedSpan = "";
//   static const int TOTAL_PAGES = 604;
//   List<GlobalKey> richTextKeys = List.generate(604, (_) => GlobalKey());

//   @override
//   void initState() {
//     super.initState();
//     currentPage = widget.pageNumber;
//     _pageController = PageController(
//       initialPage: TOTAL_PAGES - widget.pageNumber,
//     );
//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
//     WakelockPlus.enable();
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//     WakelockPlus.disable();
//     super.dispose();
//   }

//   List<Map<String, dynamic>> getPageData(int pageNumber) {
//     List<Map<String, dynamic>> pageData = [];
//     for (int surahNumber = 1; surahNumber <= 114; surahNumber++) {
//       int verseCount = quran.getVerseCount(surahNumber);
//       for (int verseNumber = 1; verseNumber <= verseCount; verseNumber++) {
//         if (quran.getPageNumber(surahNumber, verseNumber) == pageNumber) {
//           int endVerse = verseNumber;
//           while (endVerse < verseCount &&
//               quran.getPageNumber(surahNumber, endVerse + 1) == pageNumber) {
//             endVerse++;
//           }
//           pageData.add({
//             "surah": surahNumber,
//             "start": verseNumber,
//             "end": endVerse,
//             "juzNumber": quran.getJuzNumber(surahNumber, verseNumber),
//           });
//           verseNumber = endVerse;
//         }
//       }
//     }
//     return pageData;
//   }

//   void _handleVerseLongPress(int surah, int verse) {
//     showModalBottomSheet(
//       context: context,
//       builder:
//           (context) => Container(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 ListTile(
//                   leading: const Icon(Icons.copy),
//                   title: const Text('نسخ الآية'),
//                   onTap: () {
//                     Clipboard.setData(
//                       ClipboardData(text: quran.getVerse(surah, verse)),
//                     );
//                     Navigator.pop(context);
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('تم نسخ الآية')),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.share),
//                   title: const Text('مشاركة الآية'),
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.bookmark),
//                   title: const Text('إضافة إلى المفضلة'),
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//               ],
//             ),
//           ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         body: PageView.builder(
//           controller: _pageController,
//           itemCount: TOTAL_PAGES,
//           scrollDirection: Axis.horizontal,
//           reverse: true,
//           onPageChanged: (index) {
//             setState(() {
//               currentPage = TOTAL_PAGES - index;
//             });
//           },
//           itemBuilder: (context, index) {
//             int pageNumber = TOTAL_PAGES - index;
//             List<Map<String, dynamic>> pageData = getPageData(pageNumber);

//             bool isFirstPageOfSurah = pageData.any(
//               (verse) =>
//                   verse["start"] == 1 &&
//                   verse["surah"] == widget.jsonData.number,
//             );

//             return Container(
//               decoration: const BoxDecoration(color: Color(0xFFFDF5E6)),
//               child: SafeArea(
//                 child: Column(
//                   children: [
//                     if (isFirstPageOfSurah)
//                       HeaderWidget(jsonData: widget.jsonData, e: pageData[0]),

//                     Expanded(
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8),
//                         child: RichText(
//                           key: richTextKeys[pageNumber - 1],
//                           textDirection: TextDirection.rtl,
//                           textAlign: TextAlign.justify,
//                           text: TextSpan(
//                             style: TextStyle(
//                               color: Colors.black,
//                               height:
//                                   (pageNumber == 1 || pageNumber == 2)
//                                       ? 2.5
//                                       : 1.95,
//                               letterSpacing: 1.0, // إضافة مسافة بين الحروف
//                               wordSpacing: 4.0, // إضافة مسافة بين الكلمات
//                               fontFamily:
//                                   "QCF_P${pageNumber.toString().padLeft(3, "0")}",
//                               fontSize: _getSpecificPageFontSize(pageNumber),
//                             ),

//                             children:
//                                 pageData.expand((verse) {
//                                   return _buildVerseSpans(verse, pageNumber);
//                                 }).toList(),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   double _getSpecificPageFontSize(int pageNumber) {
//     if (pageNumber == 1 || pageNumber == 2) {
//       return 28;
//     } else if (pageNumber == 145 || pageNumber == 201) {
//       return 22.4;
//     } else if (pageNumber == 532 || pageNumber == 533) {
//       return 22.5;
//     } else {
//       return 23.1;
//     }
//   }

//   List<InlineSpan> _buildVerseSpans(
//     Map<String, dynamic> verse,
//     int pageNumber,
//   ) {
//     List<InlineSpan> spans = [];

//     if (verse["start"] == 1 && pageNumber != 187 && pageNumber != 1) {
//       spans.add(WidgetSpan(child: Basmallah(index: 0)));
//     }

//     for (int i = verse["start"]; i <= verse["end"]; i++) {
//       spans.add(
//         TextSpan(
//           recognizer:
//               LongPressGestureRecognizer()
//                 ..onLongPress = () {
//                   _handleVerseLongPress(verse["surah"], i);
//                 }
//                 ..onLongPressDown = (details) {
//                   setState(() {
//                     selectedSpan = " ${verse["surah"]}$i";
//                   });
//                 }
//                 ..onLongPressUp = () {
//                   setState(() {
//                     selectedSpan = "";
//                   });
//                 }
//                 ..onLongPressCancel =
//                     () => setState(() {
//                       selectedSpan = "";
//                     }),
//           text:
//               i == verse["start"]
//                   ? "${quran.getVerseQCF(verse["surah"], i).substring(0, 1)}\u200A${quran.getVerseQCF(verse["surah"], i).substring(1)} "
//                   : "${quran.getVerseQCF(verse["surah"], i)} ", // إضافة مسافة بعد كل آية
//           style: TextStyle(
//             backgroundColor:
//                 selectedSpan == " ${verse["surah"]}$i"
//                     ? Colors.yellow.withOpacity(0.3)
//                     : Colors.transparent,
//             letterSpacing: 1.0, // إضافة مسافة بين الحروف
//             wordSpacing: 4.0, // إضافة مسافة بين الكلمات
//           ),
//         ),
//       );
//     }
//     return spans;
//   }
// }