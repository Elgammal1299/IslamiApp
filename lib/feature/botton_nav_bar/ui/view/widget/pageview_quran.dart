import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:qcf_quran/qcf_quran.dart';

/// A horizontally swipeable Quran mushaf using internal QCF fonts.
///
/// - Uses `pageData` to determine surah/verse ranges for each page.
/// - Renders each verse with `QcfVerse`, which applies the correct per-page font.
/// - Supports RTL page order via `reverse: true` and `Directionality.rtl`.
class PageviewQuran extends StatefulWidget {
  /// 1-based initial page number (1..604)
  final int initialPageNumber;

  /// Optional external controller. If not provided, an internal one is created.
  final PageController? controller;

  //sp (adding 1.sp to get the ratio of screen size for responsive font design)
  final double sp;

  //h (adding 1.h to get the ratio of screen size for responsive font design)
  final double h;

  /// Optional callback when page changes. Provides 1-based page number.
  final ValueChanged<int>? onPageChanged;

  /// Optional override font size passed to each `QcfVerse`.
  final double? fontSize;

  /// Verse text color.
  final Color textColor;

  /// Background color for the whole page container.
  final Color pageBackgroundColor;

  final FontWeight? fontWeight;

  /// Long-press callbacks that include the pressed verse info.
  final void Function(int surahNumber, int verseNumber)? onLongPress;
  final void Function(int surahNumber, int verseNumber)? onLongPressUp;
  final void Function(int surahNumber, int verseNumber)? onLongPressCancel;
  final void Function(
    int surahNumber,
    int verseNumber,
    LongPressStartDetails details,
  )?
  onLongPressDown;

  /// The currently selected verse ID (format: "surah:verse")
  final String? selectedVerseId;

  const PageviewQuran({
    super.key,
    this.initialPageNumber = 1,
    this.controller,
    this.selectedVerseId,
    this.onPageChanged,
    this.fontSize,
    this.sp = 1,
    this.h = 1,
    this.textColor = const Color(0xFF000000),
    this.pageBackgroundColor = const Color(0xFFFFFFFF),
    this.fontWeight,
    this.onLongPress,
    this.onLongPressUp,
    this.onLongPressCancel,
    this.onLongPressDown,
  }) : assert(initialPageNumber >= 1 && initialPageNumber <= totalPagesCount);

  @override
  State<PageviewQuran> createState() => _PageviewQuranState();
}

class _PageviewQuranState extends State<PageviewQuran> {
  PageController? _internalController;

  PageController get _controller => widget.controller ?? _internalController!;

  bool get _ownsController => widget.controller == null;

  @override
  void initState() {
    super.initState();
    if (_ownsController) {
      _internalController = PageController(
        initialPage: widget.initialPageNumber - 1,
      );
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _internalController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: widget.pageBackgroundColor,
        child: PageView.builder(
          controller: _controller,
          reverse: false, // right-to-left paging order
          itemCount: totalPagesCount,
          onPageChanged:
              (index) => widget.onPageChanged?.call(index + 1), // 1-based
          itemBuilder: (context, index) {
            final pageNumber = index + 1; // 1-based page
            return _PageContent(
              pageNumber: pageNumber,
              fontSize: widget.fontSize,
              textColor: widget.textColor,
              fontWeight: widget.fontWeight,
              onLongPress: widget.onLongPress,
              onLongPressUp: widget.onLongPressUp,
              onLongPressCancel: widget.onLongPressCancel,
              onLongPressDown: widget.onLongPressDown,
              selectedVerseId: widget.selectedVerseId,
              sp: widget.sp,
              h: widget.h,
            );
          },
        ),
      ),
    );
  }
}

class _PageContent extends StatefulWidget {
  final int pageNumber;
  final double? fontSize;
  final Color textColor;
  final FontWeight? fontWeight;
  final void Function(int surahNumber, int verseNumber)? onLongPress;
  final void Function(int surahNumber, int verseNumber)? onLongPressUp;
  final void Function(int surahNumber, int verseNumber)? onLongPressCancel;

  //sp (adding 1.sp to get the ratio of screen size for responsive font design)
  final double sp;

  //h (adding 1.h to get the ratio of screen size for responsive font design)
  final double h;

  final void Function(
    int surahNumber,
    int verseNumber,
    LongPressStartDetails details,
  )?
  onLongPressDown;

  final String? selectedVerseId;

  const _PageContent({
    required this.pageNumber,
    required this.fontSize,
    required this.textColor,
    this.fontWeight,
    required this.onLongPress,
    required this.onLongPressUp,
    required this.onLongPressCancel,
    required this.onLongPressDown,
    this.selectedVerseId,
    required this.sp,
    required this.h,
  });

  @override
  State<_PageContent> createState() => _PageContentState();
}

class _PageContentState extends State<_PageContent>
    with AutomaticKeepAliveClientMixin {
  final List<LongPressGestureRecognizer> _recognizers = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Clear old recognizers when rebuilding (if any exist from a previous build that wasn't disposed,
    // though usually build overwrites or widget is recreated.
    // Ideally we should reuse them or dispose them if we are rebuilding this State.
    // Since we are creating new TextSpans, we must create new recognizers or rebind them.
    // Disposal of old ones is tricky inside build unless we track them.
    // For simplicity in this optimization: dispose all previous recognizers before creating new ones.
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    _recognizers.clear();

    final ranges = getPageData(widget.pageNumber);
    final pageFont = "QCF_P${widget.pageNumber.toString().padLeft(3, '0')}";
    final baseFontSize = getFontSize(widget.pageNumber, context) / widget.sp;

    final verseSpans = <InlineSpan>[];
    if (widget.pageNumber == 2 || widget.pageNumber == 1) {
      verseSpans.add(
        WidgetSpan(
          child: SizedBox(height: MediaQuery.of(context).size.height * .175),
        ),
      );
    }
    for (final r in ranges) {
      final surah = int.parse(r['surah'].toString());
      final start = int.parse(r['start'].toString());
      final end = int.parse(r['end'].toString());

      for (int v = start; v <= end; v++) {
        if (v == start && v == 1) {
          verseSpans.add(WidgetSpan(child: HeaderWidget(suraNumber: surah)));
          if (widget.pageNumber != 1 && widget.pageNumber != 187) {
            if (surah != 97) {
              verseSpans.add(
                TextSpan(
                  text: " ﱁ  ﱂﱃﱄ\n",
                  style: TextStyle(
                    fontFamily: "QCF_P001",
                    package: 'qcf_quran',
                    fontSize:
                        getScreenType(context) == ScreenType.large
                            ? 13.2 / widget.sp
                            : 24 / widget.sp,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
              );
            } else {
              verseSpans.add(
                TextSpan(
                  text: "齃𧻓𥳐龎\n",
                  style: TextStyle(
                    fontFamily: "QCF_BSML",
                    package: 'qcf_quran',
                    fontSize:
                        getScreenType(context) == ScreenType.large
                            ? 13.2 / widget.sp
                            : 18 / widget.sp,
                    color: Colors.black,
                  ),
                ),
              );
            }
          }
        }

        final spanRecognizer = LongPressGestureRecognizer();
        _recognizers.add(spanRecognizer); // Track for disposal

        spanRecognizer.onLongPress = () => widget.onLongPress?.call(surah, v);
        spanRecognizer.onLongPressStart =
            (LongPressStartDetails d) =>
                widget.onLongPressDown?.call(surah, v, d);
        spanRecognizer.onLongPressUp =
            () => widget.onLongPressUp?.call(surah, v);
        spanRecognizer.onLongPressEnd =
            (LongPressEndDetails d) => widget.onLongPressCancel?.call(surah, v);

        final isSelected = widget.selectedVerseId == "$surah:$v";

        verseSpans.add(
          TextSpan(
            text:
                v == ranges[0]['start']
                    ? "${getVerseQCF(surah, v, verseEndSymbol: false).substring(0, 1)}\u200A${getVerseQCF(surah, v, verseEndSymbol: false).substring(1, getVerseQCF(surah, v, verseEndSymbol: false).length)}"
                    : getVerseQCF(surah, v, verseEndSymbol: false),
            recognizer: spanRecognizer,
            style: TextStyle(
              backgroundColor:
                  isSelected ? Colors.yellow.withValues(alpha: 0.3) : null,
            ),
            children: [
              TextSpan(
                text: getVerseNumberQCF(surah, v),
                style: TextStyle(
                  fontFamily: pageFont,
                  package: 'qcf_quran',
                  color: Theme.of(context).primaryColorDark,//Colors.white,
                  height: 1.35 / widget.h,
                  backgroundColor:
                      isSelected ? Colors.yellow.withValues(alpha: 0.3) : null,
                ),
              ),
            ],
          ),
        );
      }
    }

    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      color: Colors.transparent,
      child: Text.rich(
        TextSpan(children: verseSpans),
        locale: const Locale("ar"),
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontFamily: pageFont,
          package: 'qcf_quran',
          fontSize: baseFontSize,
          fontWeight: widget.fontWeight ?? FontWeight.w600,
          color: widget.textColor,
          height:
              (widget.pageNumber == 1 || widget.pageNumber == 2)
                  ? 2.2
                  : MediaQuery.of(context).systemGestureInsets.left > 0 == false
                  ? 2.2
                  : MediaQuery.of(context).viewPadding.top > 0
                  ? 2.2
                  : 2.2,
        ),
      ),
    );
  }
}
