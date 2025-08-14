import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islami_app/core/widget/basmallah.dart';
import 'package:islami_app/core/widget/header_widget.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/sura.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/widget/botton_sheet_item.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/widget/custom_surah_fram_widget.dart';
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
  static const int totalPages = 604;
  static const Set<int> specialPages = {1, 2, 187};
  static const Set<int> centerAlignedPages = {1, 2};
  static const Set<int> largeFontPages = {1, 2};
  static const Set<int> mediumFontPages = {145, 201, 532, 533};

  static double getFontSize(int pageIndex) {
    if (largeFontPages.contains(pageIndex)) return 28.0;
    if (pageIndex == 145 || pageIndex == 201) return 22.4;
    if (pageIndex == 532 || pageIndex == 533) return 22.5;
    return 23.1;
  }

  static double getLineHeight(int pageIndex) {
    return largeFontPages.contains(pageIndex) ? 2.0 : 1.95;
  }

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
  }

  void _initializeApp() {
    _appState = QuranAppState();
    _appState.setCurrentPage(widget.pageNumber);
    _pageController = PageController(initialPage: widget.pageNumber);

    WidgetsBinding.instance.addObserver(this);
    _configureSystemUI();

    // Load initial font and preload adjacent fonts
    _loadFontsForPage(widget.pageNumber);
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

  void _handlePageChanged(int pageIndex) {
    if (_appState.currentPage != pageIndex) {
      _appState.setCurrentPage(pageIndex);
      _appState.setSelectedSpan("");
      _appState.verseHighlighter.clear();

      // Load fonts for new page
      _loadFontsForPage(pageIndex);
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
              textDirection: m.TextDirection.rtl,
              textAlign: PageConfig.getTextAlign(pageIndex),
              softWrap: true,
              locale: const Locale("ar"),
              text: TextSpan(
                style: TextStyle(
                  color: theme.primaryColorDark,
                  height: PageConfig.getLineHeight(pageIndex),
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
                          spans.add(
                            const WidgetSpan(child: SizedBox(height: 10)),
                          );
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
  Widget _buildPageContent(int pageIndex, double h, ThemeData them) {
    if (pageIndex == 0) {
      return _buildPlaceholderPage();
    }

    return RepaintBoundary(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
            child: CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                // Header section
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      CustomSurahFramWidget(widget: widget, index: pageIndex),
                      if (PageConfig.specialPages.contains(pageIndex))
                        SizedBox(height: h * 0.15),
                      const SizedBox(height: 30),
                      _buildHeaderWidgets(pageIndex),
                    ],
                  ),
                ),

                // Main Quran text
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: _buildOptimizedQuranText(pageIndex, them),
                    ),
                  ),
                ),

                // Bottom padding
                const SliverToBoxAdapter(child: SizedBox(height: 50)),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
    return Scaffold(
      body: ValueListenableBuilder<int>(
        valueListenable: _appState.currentPageNotifier,
        builder: (context, currentPage, child) {
          return PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            onPageChanged: _handlePageChanged,
            itemCount: PageConfig.totalPages + 1,
            itemBuilder:
                (context, index) => _buildPageContent(index, height, them),
          );
        },
      ),
    );
  }
}
