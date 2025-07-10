import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islami_app/core/widget/basmallah.dart';
import 'package:islami_app/core/widget/header_widget.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/sura.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/widget/botton_sheet_iItem.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/widget/custom_surah_fram_widget.dart';
import 'package:quran/quran.dart';
import 'package:quran/quran.dart' as Quran;

import 'package:wakelock_plus/wakelock_plus.dart';

class QuranViewPage extends StatefulWidget {
  final int pageNumber;
  final List<SurahModel> jsonData;

  const QuranViewPage({
    super.key,
    required this.pageNumber,
    required this.jsonData,
  });

  @override
  State<QuranViewPage> createState() => _QuranViewPageState();
}

class _QuranViewPageState extends State<QuranViewPage> {
  List<GlobalKey> richTextKeys = List.generate(
    604, // Replace with the number of pages in your PageView
    (_) => GlobalKey(),
  );
  setIndex() {
    setState(() {
      index = widget.pageNumber;
    });
  }

  int index = 0;
  late PageController _pageController;
  int? highlightedSurah;
  int? highlightedVerse;

  // late Timer timer;
  String selectedSpan = "";

  // highlightVerseFunction(bool shouldHighlightText, String highlightVerse) {
  //   setState(() {
  //     this.shouldHighlightText = shouldHighlightText;
  //   });
  //   if (shouldHighlightText) {
  //     setState(() {
  //       this.highlightVerse = highlightVerse;
  //     });

  //     Timer.periodic(const Duration(milliseconds: 400), (timer) {
  //       if (mounted) {
  //         setState(() {
  //           this.shouldHighlightText = false;
  //         });
  //       }
  //       Timer(const Duration(milliseconds: 200), () {
  //         if (mounted) {
  //           setState(() {
  //             this.shouldHighlightText = true;
  //           });
  //         }
  //         if (timer.tick == 4) {
  //           if (mounted) {
  //             setState(() {
  //               highlightVerse = "";

  //               shouldHighlightText = false;
  //             });
  //           }
  //           timer.cancel();
  //         }
  //       });
  //     });
  //   }
  // }

  int getCumulativeAyahNumber(int surahNumber, int ayahNumber) {
    int cumulativeNumber = 0;

    for (int i = 1; i < surahNumber; i++) {
      cumulativeNumber += Quran.getVerseCount(i);
    }

    return cumulativeNumber + ayahNumber;
  }

  void _handleVerseLongPress(int surah, int verse) {
    setState(() {
      highlightedSurah = surah;
      highlightedVerse = verse;
    });
    int cumulativeNumber = getCumulativeAyahNumber(surah, verse);
    showModalBottomSheet(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => BottonSheetItem(
                  surah: surah,
                  verse: verse,
                  cumulativeNumber: cumulativeNumber,
                ),
          ),
    ).then((_) {
      setState(() {
        highlightedSurah = null;
        highlightedVerse = null;
      });
    });
  }

  @override
  void initState() {
    setIndex();
    _pageController = PageController(initialPage: index);
    // highlightVerseFunction();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    WakelockPlus.enable();

    super.initState();
  }

  @override
  void dispose() {
    // timer.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(
          context,
        ).copyWith(scrollbars: false, overscroll: true),
        child: PageView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          onPageChanged: (a) {
            setState(() {
              selectedSpan = "";
            });
            index = a;
            // print(index)  ;
          },
          controller: _pageController,
          // onPageChanged: _onPageChanged,
          itemCount:
              totalPagesCount + 1 /* specify the total number of pages */,
          itemBuilder: (context, index) {
            // bool isEvenPage = index.isEven;

            if (index == 0) {
              return Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: 1, // أو أي رقم صغير جدًا
                    height: double.infinity,
                    color: Colors.red,
                  ),
                ),
              );
            }
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0, left: 12),
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        CustomSurahFramWidget(
                          screenSize: screenSize,
                          widget: widget,
                          index: index,
                        ),
                        if ((index == 1 || index == 2))
                          SizedBox(height: (screenSize.height * .15)),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: RichText(
                              key: richTextKeys[index - 1],
                              textDirection: m.TextDirection.rtl,
                              textAlign:
                                  (index == 1 || index == 2 || index > 570)
                                      ? TextAlign.center
                                      : TextAlign.center,
                              softWrap: true,
                              locale: const Locale("ar"),
                              text: TextSpan(
                                style: TextStyle(
                                  color: Theme.of(context).primaryColorDark,
                                  fontSize: 23.toDouble(),
                                ),
                                children:
                                    getPageData(index).expand((e) {
                                      List<InlineSpan> spans = [];
                                      for (
                                        var i = e["start"];
                                        i <= e["end"];
                                        i++
                                      ) {
                                        // Header
                                        if (i == 1) {
                                          spans.add(
                                            WidgetSpan(
                                              child: HeaderWidget(
                                                e: e,
                                                jsonData: widget.jsonData,
                                              ),
                                            ),
                                          );
                                          if (index != 187 && index != 1) {
                                            spans.add(
                                              WidgetSpan(
                                                child: Basmallah(index: 0),
                                              ),
                                            );
                                          }
                                          if (index == 187) {
                                            spans.add(
                                              WidgetSpan(
                                                child: Container(height: 10),
                                              ),
                                            );
                                          }
                                        }

                                        // Verses
                                        spans.add(
                                          TextSpan(
                                            recognizer:
                                                LongPressGestureRecognizer()
                                                  ..onLongPress = () {
                                                    _handleVerseLongPress(
                                                      e["surah"],
                                                      i,
                                                    ); // استدعاء الدالة هنا
                                                  }
                                                  ..onLongPressDown = (
                                                    details,
                                                  ) {
                                                    setState(() {
                                                      selectedSpan =
                                                          " ${e["surah"]}$i";
                                                    });
                                                  }
                                                  ..onLongPressUp = () {
                                                    setState(() {
                                                      selectedSpan = "";
                                                    });
                                                  }
                                                  ..onLongPressCancel =
                                                      () => setState(() {
                                                        selectedSpan = "";
                                                      }),
                                            text:
                                                i == e["start"]
                                                    ? "${getVerseQCF(e["surah"], i).replaceAll(" ", "").substring(0, 1)}\u200A${getVerseQCF(e["surah"], i).replaceAll(" ", "").substring(1)}"
                                                    : getVerseQCF(
                                                      e["surah"],
                                                      i,
                                                    ).replaceAll(' ', ''),
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).primaryColorDark,
                                              height:
                                                  (index == 1 || index == 2)
                                                      ? 2
                                                      : 1.95,
                                              letterSpacing: 0,
                                              wordSpacing: 0,
                                              fontFamily:
                                                  "QCF_P${index.toString().padLeft(3, "0")}",
                                              fontSize:
                                                  index == 1 || index == 2
                                                      ? 28
                                                      : index == 145 ||
                                                          index == 201
                                                      ? index == 532 ||
                                                              index == 533
                                                          ? 22.5
                                                          : 22.4
                                                      : 23.1,
                                              backgroundColor:
                                                  (highlightedSurah ==
                                                              e["surah"] &&
                                                          highlightedVerse == i)
                                                      ? Colors.orange
                                                      : Colors.transparent,
                                            ),
                                            children: const <TextSpan>[],
                                          ),
                                        );
                                      }
                                      return spans;
                                    }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ); /* Your page content */
          },
        ),
      ),
    );
  }
}
