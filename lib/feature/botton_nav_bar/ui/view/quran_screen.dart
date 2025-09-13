import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami_app/core/widget/basmallah.dart';
import 'package:islami_app/core/widget/header_widget.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/sura.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/widget/botton_sheet_item.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/widget/custom_surah_fram_widget.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/reading_progress_cubit.dart';
import 'package:quran/quran.dart';
import 'package:quran/quran.dart' as quran;
import 'package:wakelock_plus/wakelock_plus.dart';

// Font loader for lazy loading QCF fonts
class FontLoader {
  static final Map<String, bool> _loadedFonts = {};
  static final Map<String, Future<void>> _loadingFutures = {};
  static final ValueNotifier<Set<String>> loadedFontsNotifier = ValueNotifier(
    {},
  );

  static Future<void> loadFont(int pageIndex) async {
    final fontFamily = "QCF_P${pageIndex.toString().padLeft(3, "0")}";

    if (_loadedFonts[fontFamily] == true) return;

    if (_loadingFutures[fontFamily] != null) {
      return _loadingFutures[fontFamily]!;
    }

    _loadingFutures[fontFamily] = _loadFontAsync(fontFamily);
    await _loadingFutures[fontFamily]!;
  }

  static Future<void> _loadFontAsync(String fontFamily) async {
    try {
      final pageIndex = int.parse(fontFamily.split("_P").last);
      final fileName = "p$pageIndex.woff";

      await rootBundle.load('assets/fonts/QCF2BSMLfonts/$fileName');

      _loadedFonts[fontFamily] = true;

      final currentLoaded = Set<String>.from(loadedFontsNotifier.value);
      currentLoaded.add(fontFamily);
      loadedFontsNotifier.value = currentLoaded;
    } catch (e) {
      debugPrint('Font loading failed for $fontFamily: $e');
      _loadedFonts[fontFamily] = false;
    }
  }

  static bool isFontLoaded(int pageIndex) {
    final fontFamily = "QCF_P${pageIndex.toString().padLeft(3, "0")}";
    return _loadedFonts[fontFamily] == true;
  }

  static void preloadAdjacentFonts(int currentPage) {
    // Preload previous and next page fonts
    for (int i = -1; i <= 1; i++) {
      final pageIndex = currentPage + i;
      if (pageIndex > 0 && pageIndex <= 604) {
        loadFont(pageIndex);
      }
    }
  }

  static void dispose() {
    // loadedFontsNotifier.dispose();
  }
}

// Optimized verse data structure
class VerseData {
  final int surah;
  final int verse;
  final String text;
  final bool isSurahStart;

  VerseData({
    required this.surah,
    required this.verse,
    required this.text,
    required this.isSurahStart,
  });
}

// Verse highlighting state with ValueNotifier
class VerseHighlighter {
  final ValueNotifier<String?> highlightedVerseNotifier = ValueNotifier(null);

  String? get _highlightKey => highlightedVerseNotifier.value;

  bool isHighlighted(int surahNum, int verseNum) {
    return _highlightKey == "$surahNum-$verseNum";
  }

  void highlight(int surahNum, int verseNum) {
    highlightedVerseNotifier.value = "$surahNum-$verseNum";
  }

  void clear() {
    highlightedVerseNotifier.value = null;
  }

  void dispose() {
    highlightedVerseNotifier.dispose();
  }
}

// App state management with ValueNotifiers
class QuranAppState {
  final ValueNotifier<int> currentPageNotifier = ValueNotifier(0);
  final ValueNotifier<String> selectedSpanNotifier = ValueNotifier("");
  final ValueNotifier<bool> isBottomSheetOpenNotifier = ValueNotifier(false);
  final VerseHighlighter verseHighlighter = VerseHighlighter();

  int get currentPage => currentPageNotifier.value;
  String get selectedSpan => selectedSpanNotifier.value;
  bool get isBottomSheetOpen => isBottomSheetOpenNotifier.value;

  void setCurrentPage(int page) => currentPageNotifier.value = page;
  void setSelectedSpan(String span) => selectedSpanNotifier.value = span;
  void setBottomSheetOpen(bool isOpen) =>
      isBottomSheetOpenNotifier.value = isOpen;

  void dispose() {
    currentPageNotifier.dispose();
    selectedSpanNotifier.dispose();
    isBottomSheetOpenNotifier.dispose();
    verseHighlighter.dispose();
  }
}

// Configuration class for page-specific settings
class PageConfig {
  static const int totalPages = 604 + 1;
  static const Set<int> specialPages = {1, 2, 187};
  static const Set<int> centerAlignedPages = {1, 2};
  static const Set<int> largeFontPages = {1, 2};
  static const Set<int> mediumFontPages = {145, 201, 532, 533};

  static double getFontSize(int pageIndex) {
    if (largeFontPages.contains(pageIndex)) return 28.sp;
    if (pageIndex == 145 || pageIndex == 201) return 22.4.sp;
    if (pageIndex == 532 || pageIndex == 533) return 22.5.sp;
    return 23.sp;
  }

  static double getLineHeight(int pageIndex, double screenHeight) {
    // على الموبايلات الصغيرة نخليها زي ما هي
    if (screenHeight < 700) {
      return largeFontPages.contains(pageIndex) ? 2.0 : 1.8;
    }

    // على الموبايلات الكبيرة نزود المسافة بين السطور
    if (screenHeight < 900) {
      return largeFontPages.contains(pageIndex) ? 2 : 2.25;
    }

    // على التابلت أو الشاشات الكبيرة جدًا نزود أكتر
    return largeFontPages.contains(pageIndex) ? 2.4 : 2.2;
  }

  // static double getLineHeight(int pageIndex) {
  //   return largeFontPages.contains(pageIndex) ? 2.0.sp : 1.95.sp;
  // }

  static TextAlign getTextAlign(int pageIndex) {
    return TextAlign.center;
  }

  static String getFontFamily(int pageIndex) {
    return "QCF_P${pageIndex.toString().padLeft(3, "0")}";
  }
}

class QuranViewScreen extends StatefulWidget {
  final int pageNumber;
  final List<SurahModel> jsonData;

  const QuranViewScreen({
    super.key,
    required this.pageNumber,
    required this.jsonData,
  });

  @override
  State<QuranViewScreen> createState() => _QuranViewScreenState();
}

class _QuranViewScreenState extends State<QuranViewScreen>
    with WidgetsBindingObserver {
  late final PageController _pageController;
  late final QuranAppState _appState;

  // Cache for processed verse data to reduce TextSpan hierarchy
  final Map<int, List<VerseData>> _verseDataCache = {};

  @override
  void initState() {
    super.initState();
    _initializeApp();

    QuranPageIndex.ensureBuilt();
  }

  void _initializeApp() {
    _appState = QuranAppState();
    _appState.setCurrentPage(widget.pageNumber);
    _pageController = PageController(initialPage: widget.pageNumber);

    WidgetsBinding.instance.addObserver(this);
    _configureSystemUI();

    // Load initial font and preload adjacent fonts
    _loadFontsForPage(widget.pageNumber);

    // ✅ Record initial reading position when entering Quran screen
    _recordInitialReadingPosition();
  }

  void _configureSystemUI() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    WakelockPlus.enable();
  }

  Future<void> _loadFontsForPage(int pageIndex) async {
    await FontLoader.loadFont(pageIndex);
    FontLoader.preloadAdjacentFonts(pageIndex);
  }

  @override
  void dispose() {
    // ✅ Record final reading position before disposing
    _recordFinalReadingPosition();

    _cleanupResources();

    super.dispose();
  }

  void _cleanupResources() {
    WidgetsBinding.instance.removeObserver(this);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    WakelockPlus.disable();
    _pageController.dispose();
    _verseDataCache.clear();
    _appState.dispose();
    FontLoader.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      WakelockPlus.disable();
    } else if (state == AppLifecycleState.resumed) {
      WakelockPlus.enable();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ✅ Ensure reading progress is up to date when dependencies change
    // This helps when returning to the screen from other screens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _recordCurrentReadingPosition();
    });
  }

  // ✅ Record current reading position (helper method)
  Future<void> _recordCurrentReadingPosition() async {
    try {
      final currentPage = _appState.currentPage;
      final pos = QuranPageIndex.firstAyahOnPage(currentPage);

      final readingProgressCubit = BlocProvider.of<ReadingProgressCubit>(
        context,
        listen: false,
      );
      await readingProgressCubit.updateReadingProgress(
        pos.surah,
        pos.ayah,
        currentPage,
      );

      debugPrint(
        '✅ Current reading position recorded: Surah ${pos.surah}, Ayah ${pos.ayah}, Page $currentPage',
      );
    } catch (e) {
      debugPrint('❌ Error recording current reading position: $e');
    }
  }

  // ✅ Record final reading position when leaving Quran screen
  Future<void> _recordFinalReadingPosition() async {
    try {
      final currentPage = _appState.currentPage;
      final pos = QuranPageIndex.firstAyahOnPage(currentPage);

      final readingProgressCubit = BlocProvider.of<ReadingProgressCubit>(
        context,
        listen: false,
      );
      await readingProgressCubit.updateReadingProgress(
        pos.surah,
        pos.ayah,
        currentPage,
      );

      debugPrint(
        '✅ Final reading position recorded: Surah ${pos.surah}, Ayah ${pos.ayah}, Page $currentPage',
      );
    } catch (e) {
      debugPrint('❌ Error recording final reading position: $e');
    }
  }

  // ✅ Record initial reading position when entering Quran screen
  Future<void> _recordInitialReadingPosition() async {
    try {
      // Get the first ayah on the initial page
      final pos = QuranPageIndex.firstAyahOnPage(widget.pageNumber);

      // Update reading progress using the cubit
      final readingProgressCubit = BlocProvider.of<ReadingProgressCubit>(
        context,
        listen: false,
      );
      await readingProgressCubit.updateReadingProgress(
        pos.surah,
        pos.ayah,
        widget.pageNumber,
      );

      debugPrint(
        '✅ Initial reading position recorded: Surah ${pos.surah}, Ayah ${pos.ayah}, Page ${widget.pageNumber}',
      );
    } catch (e) {
      debugPrint('❌ Error recording initial reading position: $e');
    }
  }

  // Utility methods
  int _getCumulativeAyahNumber(int surahNumber, int ayahNumber) {
    try {
      int cumulativeNumber = 0;
      for (int i = 1; i < surahNumber; i++) {
        cumulativeNumber += quran.getVerseCount(i);
      }
      return cumulativeNumber + ayahNumber;
    } catch (e) {
      debugPrint('Error calculating cumulative ayah number: $e');
      return 0;
    }
  }

  void _handlePageChanged(int pageIndex) async {
    if (_appState.currentPage != pageIndex) {
      _appState.setCurrentPage(pageIndex);
      _appState.setSelectedSpan("");
      _appState.verseHighlighter.clear();

      _loadFontsForPage(pageIndex);

      // ✅ احسب رقم صفحة المصحف الفعلي
      final pageNumber = pageIndex; // عدّلها لو عندك ترقيم مختلف

      // ✅ هات أول آية في الصفحة دي من الفهرس
      final pos = QuranPageIndex.firstAyahOnPage(pageNumber);

      // ✅ خزّن آخر قراءة باستخدام الكيوبت
      try {
        final readingProgressCubit = BlocProvider.of<ReadingProgressCubit>(
          context,
          listen: false,
        );
        await readingProgressCubit.updateReadingProgress(
          pos.surah,
          pos.ayah,
          pageNumber,
        );

        debugPrint(
          '✅ Page change recorded: Surah ${pos.surah}, Ayah ${pos.ayah}, Page $pageNumber',
        );
      } catch (e) {
        debugPrint('❌ Error recording page change: $e');
      }
    }
  }

  void _handleVerseLongPress(int surah, int verse) {
    if (_appState.isBottomSheetOpen) return;

    _appState.verseHighlighter.highlight(surah, verse);
    _appState.setBottomSheetOpen(true);

    final cumulativeNumber = _getCumulativeAyahNumber(surah, verse);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setModalState) => BottonSheetItem(
                  surah: surah,
                  verse: verse,
                  cumulativeNumber: cumulativeNumber,
                ),
          ),
    ).then((_) {
      _appState.verseHighlighter.clear();
      _appState.setBottomSheetOpen(false);
    });
  }

  // Cache and process verse data to reduce TextSpan hierarchy
  List<VerseData> _getVerseData(int pageIndex) {
    if (_verseDataCache.containsKey(pageIndex)) {
      return _verseDataCache[pageIndex]!;
    }

    try {
      final List<VerseData> verses = [];

      // التأكد من وجود البيانات قبل المعالجة
      List<dynamic> pageData;
      try {
        pageData = getPageData(pageIndex);
      } catch (e) {
        debugPrint('Error getting page data for page $pageIndex: $e');
        return [];
      }

      for (final data in pageData) {
        if (data == null || data is! Map) continue;

        final surah = data["surah"];
        final start = data["start"];
        final end = data["end"];

        if (surah == null || start == null || end == null) continue;

        for (int verseNumber = start; verseNumber <= end; verseNumber++) {
          String verseText;
          try {
            verseText = getVerseQCF(surah, verseNumber);
            if (verseText.isEmpty) continue;
            verseText = verseText.replaceAll(' ', '');
          } catch (e) {
            debugPrint('Error getting verse $surah:$verseNumber: $e');
            continue;
          }

          // Add special formatting for first verse on the page segment
          if (verseNumber == start && verseText.isNotEmpty) {
            verseText =
                "${verseText.substring(0, 1)}\u200A${verseText.substring(1)}";
          }

          verses.add(
            VerseData(
              surah: surah,
              verse: verseNumber,
              text: verseText,
              // Mark if this is the first ayah of the Surah (ayah 1)
              isSurahStart: verseNumber == 1,
            ),
          );
        }
      }

      _verseDataCache[pageIndex] = verses;
      return verses;
    } catch (e) {
      debugPrint('Error processing verse data for page $pageIndex: $e');
      return [];
    }
  }

  // Build optimized verse text with reduced TextSpan hierarchy
  Widget _buildOptimizedQuranText(int pageIndex, ThemeData theme) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: FontLoader.loadedFontsNotifier,
      builder: (context, loadedFonts, child) {
        final fontFamily = PageConfig.getFontFamily(pageIndex);

        if (!loadedFonts.contains(fontFamily)) {
          return const Center(child: CircularProgressIndicator());
        }

        final verses = _getVerseData(pageIndex);
        if (verses.isEmpty) {
          return Text(
            "خطأ في تحميل النص",
            style: TextStyle(color: theme.colorScheme.error),
          );
        }

        return ValueListenableBuilder<String?>(
          valueListenable: _appState.verseHighlighter.highlightedVerseNotifier,
          builder: (context, highlightedVerse, child) {
            return RichText(
              // textAlign: TextAlign.justify,
              textDirection: m.TextDirection.rtl,
              textAlign: PageConfig.getTextAlign(pageIndex),
              softWrap: true,
              locale: const Locale("ar"),
              text: TextSpan(
                style: TextStyle(
                  color: theme.primaryColorDark,
                  height: PageConfig.getLineHeight(
                    pageIndex,
                    MediaQuery.of(context).size.height,
                  ),

                  // height: PageConfig.getLineHeight(pageIndex),
                  letterSpacing: 0,
                  wordSpacing: 0,
                  fontFamily: fontFamily,
                  fontSize: PageConfig.getFontSize(pageIndex),
                ),
                children:
                    verses.expand((verse) {
                      final List<InlineSpan> spans = [];

                      // Insert Header and Basmallah at Surah start within the text
                      if (verse.isSurahStart) {
                        spans.add(
                          WidgetSpan(
                            child: HeaderWidget(
                              e: {"surah": verse.surah},
                              jsonData: widget.jsonData,
                            ),
                          ),
                        );
                        if (pageIndex != 187 && pageIndex != 1) {
                          spans.add(
                            const WidgetSpan(child: Basmallah(index: 0)),
                          );
                        }
                        if (pageIndex == 187) {
                          spans.add(WidgetSpan(child: SizedBox(height: 10.h)));
                        }
                      }

                      final isHighlighted = _appState.verseHighlighter
                          .isHighlighted(verse.surah, verse.verse);

                      spans.add(
                        TextSpan(
                          text: verse.text,
                          style: TextStyle(
                            backgroundColor:
                                isHighlighted
                                    ? Colors.orange.withValues(alpha: 0.6)
                                    : Colors.transparent,
                          ),
                          recognizer: () {
                            final recognizer = LongPressGestureRecognizer();
                            recognizer.onLongPress =
                                () => _handleVerseLongPress(
                                  verse.surah,
                                  verse.verse,
                                );
                            recognizer.onLongPressDown = (_) {
                              _appState.setSelectedSpan(
                                "${verse.surah}${verse.verse}",
                              );
                            };
                            recognizer.onLongPressUp = () {
                              _appState.setSelectedSpan("");
                            };
                            recognizer.onLongPressCancel = () {
                              _appState.setSelectedSpan("");
                            };
                            return recognizer;
                          }(),
                        ),
                      );

                      return spans;
                    }).toList(),
              ),
            );
          },
        );
      },
    );
  }

  // Header widgets are now inserted inline within the Quran text where a Surah starts.
  Widget _buildHeaderWidgets(int pageIndex) {
    return const SizedBox.shrink();
  }

  // Build page content with RepaintBoundary and CustomScrollView
  // Widget _buildPageContent(
  //   int pageIndex,
  //   double screenHeight,
  //   ThemeData theme,
  // ) {
  //   if (pageIndex == 0) return _buildPlaceholderPage();

  //   return RepaintBoundary(
  //     child: Scaffold(
  //       resizeToAvoidBottomInset: false,
  //       body: SafeArea(
  //         child: Padding(
  //           padding: const EdgeInsets.all(10),
  //           child: Column(
  //             children: [
  //               CustomSurahFramWidget(widget: widget, index: pageIndex),
  //               SizedBox(height: 20.h),
  //               _buildHeaderWidgets(pageIndex),
  //               Expanded(
  //                 child: Padding(
  //                   padding: EdgeInsets.symmetric(horizontal: 8.w),
  //                   child: SizedBox(
  //                     width: double.infinity,
  //                     child: _buildOptimizedQuranText(pageIndex, theme),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  bool _showAppBar = false; // تعريف في الكلاس

  Widget _buildPageContent(
    int pageIndex,
    double screenHeight,
    ThemeData theme,
  ) {
    if (pageIndex == 0) return _buildPlaceholderPage();

    return RepaintBoundary(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          bottom: false,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _showAppBar = !_showAppBar; // toggle
              });
            },
            child: Stack(
              children: [
                // النص والمحتوى
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 10.h,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      if (PageConfig.specialPages.contains(pageIndex))
                        SizedBox(height: 20.h),
                      _buildHeaderWidgets(pageIndex),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8.w),
                          child: SizedBox(
                            width: double.infinity,
                            child: _buildOptimizedQuranText(pageIndex, theme),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // الـ AppBar يطفو فوق
                if (_showAppBar)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomSurahFramWidget(
                        widget: widget,
                        index: pageIndex,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildPageContent(
  //   int pageIndex,
  //   double screenHeight,
  //   ThemeData theme,
  // ) {
  //   if (pageIndex == 0) return _buildPlaceholderPage();

  //   return RepaintBoundary(
  //     child: Scaffold(
  //       resizeToAvoidBottomInset: false,
  //       body: SafeArea(
  //         child: Padding(
  //           padding: EdgeInsets.symmetric(
  //             horizontal: 10.w, // متناسب مع العرض
  //             vertical: 10.h, // متناسب مع الطول
  //           ),
  //           child: Column(
  //             children: [
  //               CustomSurahFramWidget(widget: widget, index: pageIndex),
  //               if (PageConfig.specialPages.contains(pageIndex))
  //                 SizedBox(height: 20.h),
  //               _buildHeaderWidgets(pageIndex),
  //               Expanded(
  //                 child: Padding(
  //                   padding: EdgeInsets.all(8.w),
  //                   child: SizedBox(
  //                     width: double.infinity,
  //                     child: _buildOptimizedQuranText(pageIndex, theme),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildPlaceholderPage() {
    return RepaintBoundary(
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: 1,
            height: double.infinity,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final them = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        // ✅ Record reading position before navigating back
        await _recordFinalReadingPosition();
        return true;
      },
      child: Scaffold(
        body: ValueListenableBuilder<int>(
          valueListenable: _appState.currentPageNotifier,
          builder: (context, currentPage, child) {
            return PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              onPageChanged: _handlePageChanged,
              itemCount: PageConfig.totalPages,
              itemBuilder:
                  (context, index) => _buildPageContent(index, height, them),
            );
          },
        ),
      ),
    );
  }
}

// quran_page_index.dart
class AyahPosition {
  final int surah;
  final int ayah;
  const AyahPosition(this.surah, this.ayah);
}

class QuranPageIndex {
  static Map<int, AyahPosition>? _firstAyahByPage;

  /// ابني خريطة: رقم الصفحة -> أول (سورة/آية) بتبدأ فيها الصفحة
  static void ensureBuilt() {
    if (_firstAyahByPage != null) return;

    final map = <int, AyahPosition>{};
    for (int s = 1; s <= 114; s++) {
      // لو مكتبتك ما فيهاش getVerseCount(s) استخدم طول آيات السورة من surahs بدل السطر ده
      final ayahCount = quran.getVerseCount(s);
      for (int a = 1; a <= ayahCount; a++) {
        final p = quran.getPageNumber(s, a);
        // بنسجّل أول آية تظهر في الصفحة p فقط
        map.putIfAbsent(p, () => AyahPosition(s, a));
      }
    }
    _firstAyahByPage = map;
  }

  static AyahPosition firstAyahOnPage(int page) {
    final idx = _firstAyahByPage;
    if (idx == null) {
      throw StateError(
        'Call QuranPageIndex.ensureBuilt() before using firstAyahOnPage',
      );
    }
    return idx[page] ?? const AyahPosition(1, 1);
  }
}
