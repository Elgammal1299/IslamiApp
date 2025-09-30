// import 'package:Huda/helpers/get_screen_type.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart' as m;
// import 'package:flutter/scheduler.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:Huda/blocs/bookmarks_bloc/bookmarks_bloc.dart';
// import 'package:Huda/blocs/quran_home/quran_home_bloc.dart';
// import 'package:Huda/blocs/starred/starred_bloc.dart';
// import 'package:Huda/blocs/verse_selection/verse_selection_bloc.dart';
// import 'package:Huda/helpers/constants.dart';
// import 'package:Huda/helpers/convert_to_arabic_number.dart';
// import 'package:Huda/helpers/exceptioned_headers.dart';
// import 'package:Huda/helpers/get_font_size.dart' as g;
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:Huda/helpers/hive_helpers.dart';
// import 'package:Huda/main.dart';
// import 'package:Huda/views/tajweed_rules_scree.dart';
// import 'package:Huda/widgets/sheets/ayah_options_sheet.dart';
// import 'package:Huda/widgets/basmalla_widget.dart';
// import 'package:Huda/widgets/bottom_line_widget.dart';
// import 'package:Huda/widgets/header_widget.dart';
// import 'package:Huda/widgets/top_head_widget.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:quran/quran.dart';
// import 'dart:ui' as UI;

// import 'package:quran/quraters.dart';

// class QuranPageviewContent extends StatelessWidget {
//   final int pageIndex;
//   GlobalKey<ScaffoldState> scaffoldkey;
//   final PageController pageController;
//   QuranPageviewContent(
//       {required this.pageIndex,
//       required this.pageController,
//       required this.scaffoldkey,
//       Key? key})
//       : super(key: key);

//   bool isVerseStarred(starredVerses, int surahNumber, int verseNumber) {
//     final verseKey = "$surahNumber-$verseNumber";
//     return starredVerses.contains(verseKey);
//   }

//   ScrollController scrollController = ScrollController();
//   getStarredWidgetSpan() {
//     return const WidgetSpan(
//         alignment: PlaceholderAlignment.middle,
//         baseline: TextBaseline.alphabetic,
//         child: ImageIcon(
//             color: Colors.amberAccent, AssetImage("assets/images/starred.png")),
//         style: TextStyle(backgroundColor: Colors.transparent));
//   }

//   getBookmarkedWidgetSpan(i, e, bookmarksState) {
//     return WidgetSpan(
//         alignment: PlaceholderAlignment.middle,
//         baseline: TextBaseline.ideographic,
//         child: ImageIcon(
//             color: Color(int.parse(
//                 "0x${bookmarksState.bookmarks.where((element) => element["suraNumber"] == e["surah"] && element["verseNumber"] == i).first["color"]}")),
//             const AssetImage("assets/images/bookmarked.png")),
//         style: const TextStyle(backgroundColor: Colors.transparent));
//   }

//   getNewSpan(selectedVerseState, bookmarksState, starredState, e, context,
//       screenSize, isPortrait, quranHomeState, snapshotdata) {
//     List<InlineSpan> spans = [];

//     for (int i = e["start"]; i <= e["end"]; i++) {
//       spans.add(TextSpan(
//         recognizer: LongPressGestureRecognizer()
//           ..onLongPress = () {
//             showAyahOptionsSheet(pageIndex, e["surah"], i, context);
//           }
//           ..onLongPressDown = (details) {
//             verseSelectionBloc.add(VerseSelected("${e["surah"]}-$i"));
//           }
//           ..onLongPressUp = () {
//             verseSelectionBloc.add(VerseUnselected());
//           }
//           ..onLongPressCancel = () {
//             verseSelectionBloc.add(VerseUnselected());
//           },
//         text: i == e["start"]
//             ? "${getVerseQCF(e["surah"], i).substring(0, 1)}\u200A${getVerseQCF(e["surah"], i).substring(1, getVerseQCF(e["surah"], i).length - 1)}"
//             : getVerseQCF(e["surah"], i)
//                 .substring(0, getVerseQCF(e["surah"], i).length - 1),
//         locale: const Locale("ar"),
//         children: [
//           // if (isVerseStarred(starredState.starredVerses, e["surah"], i) &&
//           //     bookmarksState.bookmarks
//           //         .where((element) =>
//           //             element["suraNumber"] == e["surah"] &&
//           //             element["verseNumber"] == i)
//           //         .isEmpty)
//           //   getStarredWidgetSpan(),

//           // if (bookmarksState.bookmarks
//           //     .where((element) =>
//           //         element["suraNumber"] == e["surah"] &&
//           //         element["verseNumber"] == i)
//           //     .isNotEmpty)
//           //   getBookmarkedWidgetSpan(i, e, bookmarksState),
//           // if (bookmarksState.bookmarks
//           //         .where((element) =>
//           //             element["suraNumber"] == e["surah"] &&
//           //             element["verseNumber"] == i)
//           //         .isEmpty &&
//           //     isVerseStarred(starredState.starredVerses, e["surah"], i) ==
//           //         false)
//           TextSpan(
//               text: getVerseQCF(e["surah"], i).substring(
//                   getVerseQCF(e["surah"], i).length - 1,
//                   getVerseQCF(e["surah"], i).length),
//               style: TextStyle(
//                   //inherit: false,
//                   color: verseNumberColors[getValue("themeIndex")]))
//         ],
//         style: TextStyle(
//           color: fontColors[getValue("themeIndex")],
//           //  snapshotdata != null &&
//           //         quranHomeState.startVerse == quranHomeState.endVerse &&
//           //         quranHomeState.suraNumber == e["surah"] &&
//           //         quranHomeState.startVerse == i
//           //     ? textSelectionColors[getValue("themeIndex")]
//           //     : snapshotdata != null &&
//           //             quranHomeState.startVerse != quranHomeState.endVerse &&
//           //             snapshotdata! == i - 1 &&
//           //             quranHomeState.suraNumber == e["surah"]
//           //         ? textSelectionColors[getValue("themeIndex")]
//           //         : selectedVerseState.selectedVerseId == "${e["surah"]}-$i"
//           //             ? textSelectionColors[getValue("themeIndex")]
//           //             : fontColors[getValue("themeIndex")],
//           height: isPortrait
//               ? (pageIndex == 1 || pageIndex == 2)
//                   ? 2
//                   : MediaQuery.of(context).systemGestureInsets.left > 0 == false
//                       ? 2.075
//                       : 2.1
//               : 3.25,
//           letterSpacing: 0.w,
//           wordSpacing: 0,
//           // fontWeight: FontWeight.bold,
//           shadows: getValue("selectedFontMode") == 1
//               ? [
//                   Shadow(
//                     offset: Offset.fromDirection(0),
//                     blurRadius: 0,
//                     color: fontColors[getValue("themeIndex")].withOpacity(.4),
//                   ),
//                   Shadow(
//                     blurRadius: 0,
//                     offset: Offset.fromDirection(1),
//                     color: fontColors[getValue("themeIndex")].withOpacity(.4),
//                   ),
//                 ]
//               : [],
//           fontFamily: "QCF_P${pageIndex.toString().padLeft(3, "0")}",
//           fontSize: g.getFontSize(pageIndex, context),
//           // backgroundColor:
//           //  snapshotdata != null &&
//           //         quranHomeState.startVerse == quranHomeState.endVerse &&
//           //         quranHomeState.suraNumber == e["surah"] &&
//           //         quranHomeState.startVerse == i
//           //     ? audioPlayingColors[getValue("themeIndex")]
//           //     : snapshotdata != null &&
//           //             quranHomeState.startVerse != quranHomeState.endVerse &&
//           //             snapshotdata! == i - 1 &&
//           //             quranHomeState.suraNumber == e["surah"]
//           //         ? audioPlayingColors[getValue("themeIndex")]
//           //         : bookmarksState.bookmarks
//           //                 .where((element) =>
//           //                     element["suraNumber"] == e["surah"] &&
//           //                     element["verseNumber"] == i)
//           //                 .isNotEmpty
//           //             ? Color(int.parse(
//           //                     "0x${bookmarksState.bookmarks.where((element) => element["suraNumber"] == e["surah"] && element["verseNumber"] == i).first["color"]}"))
//           //                 .withOpacity(.3)
//           //             : selectedVerseState.selectedVerseId ==
//           //                     "${e["surah"]}-$i"
//           //                 ? selectionColors[getValue("themeIndex")]
//           //                 : Colors.transparent,
//         ),
//       ));
//     }

//     return spans;
//   }

//   final keys = <GlobalKey<WidgetSpanWrapperState>>[];
//   GlobalKey<WidgetSpanWrapperState> nextKey() {
//     GlobalKey<WidgetSpanWrapperState> key = GlobalKey<WidgetSpanWrapperState>();
//     keys.add(key);
//     return key;
//   }

//   getVerseSpans(selectedVerseState, bookmarksState, starredState, context,
//       screenSize, isPortrait, quranHomeState, snapshotdata) {
//     // SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
//     //   List<GlobalKey<WidgetSpanWrapperState>>? sameRow;
//     //   GlobalKey<WidgetSpanWrapperState> prev = keys.removeAt(0);
//     //   for (var key in keys) {
//     //     if (getYOffsetOf(key) == getYOffsetOf(prev)) {
//     //       sameRow ??= [prev];
//     //       sameRow.add(key);
//     //     } else if (sameRow != null) {
//     //       resolveSameRow(sameRow);
//     //       sameRow = null;
//     //     }
//     //     prev = key;
//     //   }
//     //   if (sameRow != null) {
//     //     resolveSameRow(sameRow);
//     //   }
//     // });

//     return getPageData(pageIndex).expand((e) {
//       // print(e);
//       List<InlineSpan> spans = [];
//       if (pageIndex == 2 || pageIndex == 1) {
//         spans.add(WidgetSpan(
//             child: SizedBox(
//           height: screenSize.height * .175,
//         )));
//       }
//       for (var i = e["start"]; i <= e["end"]; i++) {
//         if (i == 1) {
//           spans.add(WidgetSpan(
//             child: HeaderWidget(
//               suraNumber: e["surah"],
//             ),
//           ));

//           if (pageIndex != 187 && pageIndex != 1) {
//             spans.add(TextSpan(
//                 text: pageIndex == 2 ? " \nﱁ ﱂﱃﱄ\n" : "        \n\n 齃𧻓𥳐龎\n",
//                 style: TextStyle(
//                     fontFamily: pageIndex == 2 ? "QCF_P001" : "QCF_BSML",
//                     fontSize: getScreenType(context) == ScreenType.large
//                         ? 13.2.sp
//                         : pageIndex == 2
//                             ? 24.sp
//                             : 19.sp,
//                     // foreground: Paint()..color = fontColors[getValue("themeIndex")],
//                     // color: fontColors[getValue("themeIndex")]
//                     // foreground: Paint()
//                     //   ..colorFilter = getValue("selectedFontMode") == 1
//                     //       ? ColorFilter.mode(
//                     //           getValue("themeIndex") < 5
//                     //               ? fontColors[getValue("themeIndex")]
//                     //               : Colors.black,
//                     //           BlendMode.srcATop)
//                     //       : null
//                     //   ..invertColors = getValue("themeIndex") < 5 ? false : true,

//                     color: fontColors[getValue("themeIndex")])));
//           }
//           if (pageIndex == 187 || pageIndex == 1) {
//             spans.add(WidgetSpan(
//                 child: SizedBox(height: 10.h, width: screenSize.width)));
//           }
//         }

//         // Verses
//         spans.add(TextSpan(
//           recognizer: LongPressGestureRecognizer()
//             ..onLongPress = () {
//               showAyahOptionsSheet(pageIndex, e["surah"], i, context);
//             }
//             ..onLongPressDown = (details) {
//               verseSelectionBloc.add(VerseSelected("${e["surah"]}-$i"));
//             }
//             ..onLongPressUp = () {
//               verseSelectionBloc.add(VerseUnselected());
//             }
//             ..onLongPressCancel = () {
//               verseSelectionBloc.add(VerseUnselected());
//             },
//           text: i == e["start"]
//               ? getVerseQCF(e["surah"], i).endsWith("\n")
//                   ? "${getVerseQCF(e["surah"], i).substring(0, 1)}\u200A${getVerseQCF(e["surah"], i).substring(1, getVerseQCF(e["surah"], i).length - 2)}"
//                   : "${getVerseQCF(e["surah"], i).substring(0, 1)}\u200A${getVerseQCF(e["surah"], i).substring(1, getVerseQCF(e["surah"], i).length - 1)}"
//               : getVerseQCF(e["surah"], i).substring(
//                   0,
//                   getVerseQCF(e["surah"], i).endsWith("\n")
//                       ? getVerseQCF(e["surah"], i).length - 2
//                       : getVerseQCF(e["surah"], i).length -
//                           1), // .substring(0, getVerseQCF(e["surah"], i).length - 1)

//           locale: const Locale("ar"),
//           children: [
//             //  if (isVerseStarred(starredState.starredVerses, e["surah"], i) &&
//             //       bookmarksState.bookmarks
//             //           .where((element) =>
//             //               element["suraNumber"] == e["surah"] &&
//             //               element["verseNumber"] == i)
//             //           .isEmpty)
//             //     getStarredWidgetSpan(),
//             //   if (bookmarksState.bookmarks
//             //       .where((element) =>
//             //           element["suraNumber"] == e["surah"] &&
//             //           element["verseNumber"] == i)
//             //       .isNotEmpty)
//             //     getBookmarkedWidgetSpan(i, e, bookmarksState),

//             // if (bookmarksState.bookmarks
//             //         .where((element) =>
//             //             element["suraNumber"] == e["surah"] &&
//             //             element["verseNumber"] == i)
//             //         .isEmpty &&
//             //     isVerseStarred(starredState.starredVerses, e["surah"], i) ==
//             //         false)
//             // WidgetSpan(
//             //     alignment: PlaceholderAlignment.baseline,
//             //     baseline: TextBaseline.alphabetic,
//             //     child: WidgetSpanWrapper(
//             //       key: nextKey(),
//             //       child: Container(
//             //         width: 20.w,
//             //         height: 20.h,
//             //         decoration: const BoxDecoration(
//             //             image: DecorationImage(
//             //           image: AssetImage(
//             //             "assets/images/preview1.png",
//             //           ),
//             //         )),
//             //         child: Center(
//             //           child: RichText(
//             //               softWrap: true,
//             //               text: TextSpan(
//             //                 text: convertToArabicNumber(i.toString()),
//             //                 style: TextStyle(
//             //                     fontFamily: "UthmanTN1",
//             //                     color: Colors.black,
//             //                     fontWeight: FontWeight.bold,
//             //                     fontSize: 10.sp),
//             //               )),
//             //         ),
//             //       ),
//             //     ))
//             TextSpan(
//                 text: getVerseQCF(e["surah"], i).endsWith("\n")
//                     ? convertToArabicNumber(i.toString()) + "\n"
//                     : convertToArabicNumber(i.toString()) + " ",
//                 style: TextStyle(
//                   //inherit: false,
//                   // foreground: Paint(),
//                   fontFamily:
//                       verseFont[getValue("themeIndex")], height: 1.35.h
//                   // fontSize: 23.sp
//                 ))
//           ],
//           style: TextStyle(
//             // foreground: Paint()..style=PaintingStyle.fill..colorFilter=ColorFilter.mode(fontColors[getValue("themeIndex")], BlendMode.srcATop),
//             color: fontColors[getValue("themeIndex")],
//             // foreground: Paint()
//             // ..colorFilter = getValue("selectedFontMode") == 1
//             //     ? ColorFilter.mode(
//             //         getValue("themeIndex") < 5
//             //             ? fontColors[getValue("themeIndex")]
//             //             : Colors.black,
//             //         BlendMode.srcATop)
//             //     : null
//             // ..invertColors = getValue("themeIndex") < 5 ?getValue("selectedFontMode") == 1?false:  false : true,

//             // color: snapshotdata != null &&
//             //         quranHomeState.startVerse == quranHomeState.endVerse &&
//             //         quranHomeState.suraNumber == e["surah"] &&
//             //         quranHomeState.startVerse == i
//             //     ? textSelectionColors[getValue("themeIndex")]
//             //     : snapshotdata != null &&
//             //             quranHomeState.startVerse != quranHomeState.endVerse &&
//             //             snapshotdata! == i - 1 &&
//             //             quranHomeState.suraNumber == e["surah"]
//             //         ? textSelectionColors[getValue("themeIndex")]
//             //         : selectedVerseState.selectedVerseId == "${e["surah"]}-$i"
//             //             ? textSelectionColors[getValue("themeIndex")]
//             //             : fontColors[getValue("themeIndex")],
//             height: isPortrait
//                 ? (pageIndex == 1 || pageIndex == 2)
//                     ? 2.2
//                     : MediaQuery.of(context).systemGestureInsets.left > 0 ==
//                             false
//                         ? getValue("isVerseByVerse") == false &&
//                                 getValue("selectedFontMode") == 0 &&
//                                 getValue("showTajweedRules") &&
//                                 getValue("tajweedMode") == 1
//                             ? MediaQuery.of(context).viewPadding.top > 0
//                                 ? 1.825
//                                 : 1.875
//                             : MediaQuery.of(context).viewPadding.top > 0
//                                 ? 2.065 //bottom bar cisible
//                                 : 2.2
//                         : getValue("isVerseByVerse") == false &&
//                                 getValue("selectedFontMode") == 0 &&
//                                 getValue("showTajweedRules") &&
//                                 getValue("tajweedMode") == 1
//                             ? MediaQuery.of(context).viewPadding.top > 0
//                                 ? 1.825
//                                 : 1.9
//                             : MediaQuery.of(context).viewPadding.top > 0
//                                 ? 2.15//no bottom bar
//                                 : 2.1//bottom bar
//                 : (pageIndex == 1 || pageIndex == 2)
//                     ? 2.5
//                     : 1.8,
//             letterSpacing: 0.w,
//             wordSpacing: 0,
// // fontWeight: FontWeight.bold,
//             // fontWeight: FontWeight.w900,
//             // fontWeight: FontWeight.bold,
//             // shadows: getValue("selectedFontMode") == 1
//             //     ? [
//             //         Shadow(
//             //           // offset: Offset.fromDirection(0),
//             //           blurRadius: .1,
//             //           color: fontColors[getValue("themeIndex")],
//             //         ),
//             //         // Shadow(
//             //         //   blurRadius: 0,
//             //         //   // offset: Offset.fromDirection(1),
//             //         //   color: fontColors[getValue("themeIndex")].withOpacity(.1),
//             //         // ),
//             //       ]
//             //     : [],
//             fontFamily: "QCF_P${pageIndex.toString().padLeft(3, "0")}",
//             fontSize: isPortrait
//                 ? g.getFontSize(pageIndex, context)
//                 : (pageIndex == 1 || pageIndex == 2)
//                     ? 20.sp
//                     : g.getFontSize(pageIndex, context) -
//                         17.sp //Device pixel density
//             ,
//             backgroundColor: snapshotdata != null &&
//                     quranHomeState.startVerse == quranHomeState.endVerse &&
//                     quranHomeState.suraNumber == e["surah"] &&
//                     quranHomeState.startVerse == i
//                 ? audioPlayingColors[getValue("themeIndex")]
//                 : snapshotdata != null &&
//                         quranHomeState.startVerse != quranHomeState.endVerse &&
//                         snapshotdata! == i - 1 &&
//                         quranHomeState.suraNumber == e["surah"]
//                     ? audioPlayingColors[getValue("themeIndex")]
//                     : bookmarksState.bookmarks
//                             .where((element) =>
//                                 element["suraNumber"] == e["surah"] &&
//                                 element["verseNumber"] == i)
//                             .isNotEmpty
//                         ? Color(int.parse(
//                                 "0x${bookmarksState.bookmarks.where((element) => element["suraNumber"] == e["surah"] && element["verseNumber"] == i).first["color"]}"))
//                             .withOpacity(.3)
//                         : selectedVerseState.selectedVerseId ==
//                                 "${e["surah"]}-$i"
//                             ? selectionColors[getValue("themeIndex")]
//                             : Colors.transparent,
//           ),
//         ));

//         // if (pageIndex != 604 &&
//         //     getPageData(pageIndex + 1)[0]["start"] == 1 &&
//         //     i == e["end"]) {
//         //   if (exceptionIndexes.contains(pageIndex + 1)) {
//         //   } else {}
//         // }
//       }

//       return spans;
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

//     return Stack(
//       children: [
//         BlocBuilder<QuranHomeBloc, QuranHomeState>(
//           bloc: quranHomeBloc,
//           builder: (context, state1) {
//             return Scrollbar(
//               controller: scrollController,
//               child: SingleChildScrollView(
//                 controller: scrollController,
//                 child: SizedBox(
//                   height: screenSize.height,
//                   width: screenSize.width,
//                   child: ListView(
//                     shrinkWrap: true,
//                     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: false
//                         ? getPageData(pageIndex)
//                             .map((e) => Container(
//                                   child: Column(
//                                     children: [
//                                       e["start"] == 1
//                                           ? HeaderWidget(suraNumber: e["surah"])
//                                           : const SizedBox(),
//                                       e["start"] == 1
//                                           ? Text(
//                                               "321\n",
//                                               textDirection:
//                                                   m.TextDirection.rtl,
//                                               style: TextStyle(
//                                                   fontFamily: "QCF_BSML",
//                                                   fontSize: 22.sp,
//                                                   color: fontColors[
//                                                       getValue("themeIndex")]),
//                                             )
//                                           : const SizedBox(),
//                                       RichText(
//                                           textAlign: TextAlign.center,
//                                           text: TextSpan(
//                                               children: getNewSpan(
//                                             VerseSelectionState,
//                                             BookmarksState,
//                                             StarredState,
//                                             e,
//                                             context,
//                                             screenSize,
//                                             isPortrait,
//                                             state1,
//                                             null,
//                                           )))
//                                     ],
//                                   ),
//                                 ))
//                             .toList()
//                         : [
//                             TopHeadWidget(
//                               pageIndex: pageIndex,
//                               openEnddrawerFunction: () {
//                                 scaffoldkey.currentState!.openDrawer();
//                               },
//                             ),
//                             SizedBox(
//                               height: screenSize.height * .01,
//                             ),
//                             Directionality(
//                               textDirection: m.TextDirection.rtl,
//                               child: BlocBuilder<StarredBloc, StarredState>(
//                                 bloc: starredBloc,
//                                 builder: (context, starredState) {
//                                   if (starredState is FetchedStarredVerses) {
//                                     return BlocBuilder<BookmarksBloc,
//                                         BookmarksState>(
//                                       bloc: bookmarksBloc,
//                                       builder: (context, bookmarksState) {
//                                         if (bookmarksState
//                                             is BookmarksFetched) {
//                                           return SizedBox(
//                                             width: double.infinity,
                                     
//                                               child: BlocBuilder<
//                                                   VerseSelectionBloc,
//                                                   VerseSelectionState>(
//                                                 bloc: verseSelectionBloc,
//                                                 builder: (context, state) {
//                                                   if (state1 is QuranHomeReady) {
//                                                     return RichText(
//                                                       textDirection:
//                                                           m.TextDirection.rtl,
//                                                       textAlign: TextAlign.center,
//                                                       softWrap: true,
//                                                       locale: const Locale("ar"),
//                                                       text: TextSpan(
//                                                           style: TextStyle(
//                                                             color: backgroundColors[
//                                                                 getValue(
//                                                                     "themeIndex")],
//                                                           ),
//                                                           children: getVerseSpans(
//                                                               state,
//                                                               bookmarksState,
//                                                               starredState,
//                                                               context,
//                                                               screenSize,
//                                                               isPortrait,
//                                                               state1,
//                                                               null)),
//                                                     );
//                                                   } else if (state1
//                                                       is QuranHomeAudioReady) {
//                                                     return StreamBuilder<int?>(
//                                                         stream: state1.player
//                                                             .currentIndexStream,
//                                                         builder:
//                                                             (context, snapshot) {
//                                                           if (snapshot.hasData) {
//                                                             if (snapshot.data ==
//                                                                 state1.endVerse) {
//                                                               quranHomeBloc.add(
//                                                                   CloseAllPlayers());
//                                                               // state1.player.seek(Duration.zero,index: state1.startVerse);
//                                                             }
//                                                             return RichText(
//                                                               textDirection: m
//                                                                   .TextDirection
//                                                                   .rtl,
//                                                               textAlign: TextAlign
//                                                                   .center,
//                                                               softWrap: true,
//                                                               locale:
//                                                                   const Locale(
//                                                                       "ar"),
//                                                               text: TextSpan(
//                                                                   style:
//                                                                       TextStyle(
//                                                                     color: backgroundColors[
//                                                                         getValue(
//                                                                             "themeIndex")],
//                                                                   ),
//                                                                   children: getVerseSpans(
//                                                                       state,
//                                                                       bookmarksState,
//                                                                       starredState,
//                                                                       context,
//                                                                       screenSize,
//                                                                       isPortrait,
//                                                                       state1,
//                                                                       snapshot
//                                                                           .data!)),
//                                                             );
//                                                           }
//                                                           return Container();
//                                                         });
//                                                   }
//                                                   return Container();
//                                                 },
//                                               ),

//                                           );
//                                         }
//                                         return Container();
//                                       },
//                                     );
//                                   }
//                                   return Container();
//                                 },
//                               ),
//                             ),
//                             if ((pageIndex == 1 || pageIndex == 2))
//                               SizedBox(
//                                 height: (screenSize.height * .08),
//                               ),
//                             SizedBox(
//                               height: 10.h,
//                             ),
//                             // BottomLineWidget(
//                             //   quarters: quarters,
//                             //   pageIndex: pageIndex,
//                             // ),
//                             if (getValue("selectedFontMode") == 0 &&
//                                 getValue("showTajweedRules") &&
//                                 getValue("tajweedMode") == 0)
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     showDialog(
//                                       context: context,
//                                       builder: (c) => Dialog(
//                                           insetPadding: EdgeInsets.zero,
//                                           backgroundColor: backgroundColors[
//                                               getValue("themeIndex")],
//                                           child: TajweedRulesScreen()),
//                                     );
//                                   },
//                                   child: Container(
//                                     child: Container(
//                                       // height: 280.h,
//                                       child: GridView(
//                                           shrinkWrap: true,
//                                           gridDelegate:
//                                               SliverGridDelegateWithFixedCrossAxisCount(
//                                                   crossAxisCount: 4,
//                                                   childAspectRatio: 2 / 1.2),
//                                           children: TajweedRulesData.rules
//                                               .map((rule) => Column(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .center,
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .center,
//                                                     children: [
//                                                       Text(
//                                                         rule.fontCode,
//                                                         style: TextStyle(
//                                                             foreground: Paint()
//                                                               ..invertColors =
//                                                                   getValue("themeIndex") >
//                                                                           4
//                                                                       ? true
//                                                                       : false,
//                                                             fontFamily:
//                                                                 "tajweedRules",
//                                                             fontSize: 14.sp),
//                                                       ),
//                                                       Text(
//                                                         context.locale ==
//                                                                 Locale("ar")
//                                                             ? " " +
//                                                                 rule.arabicDescription
//                                                                     .split("\n")
//                                                                     .first
//                                                             : " " +
//                                                                 rule.description
//                                                                     .split("\n")
//                                                                     .first,
//                                                         textAlign:
//                                                             TextAlign.center,
//                                                         style: TextStyle(
//                                                             fontSize: 8.sp,
//                                                             fontFamily: "zain",
//                                                             color: fontColors[
//                                                                 getValue(
//                                                                     "themeIndex")],
//                                                             fontWeight:
//                                                                 FontWeight
//                                                                     .bold),
//                                                       )
//                                                     ],
//                                                   ))
//                                               .toList()),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                           ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//         Positioned(
//           bottom: 5.h,
         
//               child: Padding(
//                 padding:  EdgeInsets.symmetric(horizontal:  20.0.sp,vertical: 10.h ),
//                 child: BottomLineWidget(
//                   quarters: quarters,
//                   pageIndex: pageIndex,
                
                           
//                           ),
//               ),
//         ),
//       ],
//     ) /* Your page content */
//         // Your current page content
//         ;
//   }
// }

// void resolveSameRow(List<GlobalKey<WidgetSpanWrapperState>> keys) {
//   var middle = (keys.length / 2.0).floor();
//   for (int i = 0; i < middle; i++) {
//     var a = keys[i];
//     var b = keys[keys.length - i - 1];
//     var left = getXOffsetOf(a);
//     var right = getXOffsetOf(b);
//     a.currentState?.updateXOffset(right - left);
//     b.currentState?.updateXOffset(left - right);
//   }
// }

// double getYOffsetOf(GlobalKey key) {
//   RenderBox? box = key.currentContext!.findRenderObject() as RenderBox;
//   return box.globalToLocal(Offset.zero).dy;

//   // return box!.getTransformTo(box!.parent).localToGlobal(Offset.zero).dy;
// }

// double getXOffsetOf(GlobalKey key) {
//   RenderBox? box = key.currentContext!.findRenderObject() as RenderBox;
//   return box.localToGlobal(Offset.zero).dx;
// }

// class WidgetSpanWrapper extends StatefulWidget {
//   // const WidgetSpanWrapper({Key? key, required this.child}) : super(key: key);
//   const WidgetSpanWrapper({super.key, required this.child});

//   final Widget child;

//   @override
//   WidgetSpanWrapperState createState() => WidgetSpanWrapperState();
// }

// class WidgetSpanWrapperState extends State<WidgetSpanWrapper> {
//   Offset offset = Offset.zero;

//   void updateXOffset(double xOffset) {
//     setState(() {
//       offset = Offset(xOffset, 0);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Transform.translate(
//       offset: offset,
//       child: widget.child,
//     );
//   }
// }
