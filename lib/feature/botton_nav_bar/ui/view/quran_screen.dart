import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami_app/feature/khatmah/view/widget/khatmah_progress_tracker.dart';
import 'package:islami_app/feature/khatmah/view_model/khatmah_cubit.dart';
import 'package:qcf_quran_plus/qcf_quran_plus.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../view_model/reading_progress_cubit.dart';
import 'widget/custom_surah_fram_widget.dart';
import '../view_model/verse_selection_cubit.dart';
import 'widget/quran_drawer.dart';
import 'package:star_menu/star_menu.dart';
import 'package:islami_app/core/services/bookmark_manager.dart';
import 'package:islami_app/core/services/setup_service_locator.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/widget/verse_action_handler.dart';

// ─────────────────────────────────────────────
//  QuranViewScreen
// ─────────────────────────────────────────────

class QuranViewScreen extends StatefulWidget {
  final int pageNumber;
  final bool isKhatmah;
  final String? khatmahId;

  const QuranViewScreen({
    super.key,
    required this.pageNumber,
    this.isKhatmah = false,
    this.khatmahId,
  });

  @override
  State<QuranViewScreen> createState() => _QuranViewScreenState();
}

class _QuranViewScreenState extends State<QuranViewScreen> {
  late PageController _controller;

  // ─── UI visibility ───
  // ValueNotifier بدل setState لتجنب rebuild كاملة للـ tree
  final ValueNotifier<bool> _showUI = ValueNotifier(false);

  // ─── Current page كـ ValueNotifier مستقل ───
  // بيسمح للـ slider والـ AppBar يتحدثوا بدون rebuild للشجرة الكاملة
  late final ValueNotifier<int> _currentPageNotifier;

  int get _currentPage => _currentPageNotifier.value;

  final GlobalKey _pageViewKey = GlobalKey();

  // ─── Highlights كـ ValueNotifier ───
  // الهدف: منع rebuild الـ QuranPageView الكاملة عند كل تغيير في VerseSelectionCubit
  // بيتحدث فقط عند الضغط الطويل — مش أثناء التقليب بين الصفحات
  final ValueNotifier<List<HighlightVerse>> _highlightsNotifier =
      ValueNotifier(const []);

  // ─── Bookmark cache ───
  final Map<String, bool> _bookmarkCache = {};

  Timer? _debounce;

  // ─── isDark: محسوب مرة واحدة في didChangeDependencies ───
  // لتفادي استدعاء Theme.of(context) في كل build()
  late bool _isDark;

  @override
  void initState() {
    super.initState();
    _currentPageNotifier = ValueNotifier(widget.pageNumber);
    _controller = PageController(initialPage: widget.pageNumber - 1);

    WakelockPlus.enable();

    // بناء الـ index مرة واحدة عند أول استخدام
    QuranPageIndex.ensureBuilt();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _updateProgress(_currentPage);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // نحسب isDark هنا مش في build() لتفادي إعادة تمريره لـ wrapper عند كل rebuild
    _isDark = Theme.of(context).brightness == Brightness.dark;
  }

  void _updateProgress(int page) {
    if (widget.isKhatmah) {
      KhatmahProgressTracker.updateCurrentPage(
        context,
        pageNumber: page,
        khatmahId: widget.khatmahId,
      );
    } else {
      final pos = QuranPageIndex.firstAyahOnPage(page);
      context.read<ReadingProgressCubit>().updateReadingProgress(
            pos.surah,
            pos.ayah,
            page,
          );
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _showUI.dispose();
    _currentPageNotifier.dispose();
    _highlightsNotifier.dispose();
    WakelockPlus.disable();
    _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  // ─── Page changed ───
  // ❌ مفيش setState هنا خالص
  // ✅ بنستخدم ValueNotifiers فقط لتحديث الـ UI
  void _onPageChanged(int page) {
    debugPrint('PAGE CHANGED => $page');
    _currentPageNotifier.value = page;

    // مسح الـ highlight لما المستخدم يقلّب الصفحة
    if (_highlightsNotifier.value.isNotEmpty) {
      _highlightsNotifier.value = const [];
    }

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      _updateProgress(page);
    });
  }

  void _onSliderChanged(int page) {
    _controller.jumpToPage(page - 1);
    _currentPageNotifier.value = page;
  }

  // ─── Bookmark helpers ───
  Future<bool> _isBookmarked(int s, int a) async {
    final key = '$s:$a';
    if (_bookmarkCache.containsKey(key)) return _bookmarkCache[key]!;
    final val = await sl<BookmarkManager>().isBookmarked(s, a);
    _bookmarkCache[key] = val;
    return val;
  }

  void _invalidateBookmarkCache(int s, int a) {
    _bookmarkCache.remove('$s:$a');
  }

  Future<List<Widget>> _buildMenuItems(int surah, int ayah) async {
    final isBookmarked = await _isBookmarked(surah, ayah);
    return [
      _buildMenuItem(Icons.play_arrow, 'استماع', Colors.blue),
      _buildMenuItem(Icons.menu_book, 'التفسير', Colors.green),
      _buildMenuItem(Icons.copy, 'نسخ', Colors.orange),
      _buildMenuItem(
        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
        isBookmarked ? 'إزالة' : 'حفظ',
        Colors.purple,
      ),
      _buildMenuItem(Icons.share, 'نص', Colors.teal),
      _buildMenuItem(Icons.image, 'صورة', Colors.redAccent),
    ];
  }

  Widget _buildMenuItem(IconData icon, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 24.sp),
        ),
        SizedBox(height: 4.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Amiri',
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).primaryColorLight,
      endDrawer: ValueListenableBuilder<int>(
        valueListenable: _currentPageNotifier,
        builder: (context, page, child) {
          final pos = QuranPageIndex.firstAyahOnPage(page);
          return QuranDrawer(
            currentSurahIndex: pos.surah,
            onSurahSelected: (surahIndex) {
              final pageNum = getPageNumber(surahIndex, 1);
              Navigator.pop(context);
              if (pageNum != _currentPageNotifier.value) {
                _onSliderChanged(pageNum);
              }
            },
          );
        },
      ),
      body: BlocListener<KhatmahCubit, KhatmahState>(
        listener: (context, state) {
          if (state is KhatmahDailyCompleted) {
            KhatmahProgressTracker.showCompletionDialog(
              context,
              dayNumber: state.dayNumber,
              khatmahId: state.khatmahId,
              cubit: context.read<KhatmahCubit>(),
            );
          }
        },
        child: GestureDetector(
          onTap: () => _showUI.value = !_showUI.value,
          child: Stack(
            children: [
              // ─── QuranPageView: معزول تماماً عن باقي الـ tree ───
              // الـ _QuranPageViewWrapper:
              //  ✅ لا يستمع لـ VerseSelectionCubit مباشرة (مصدر الـ lag القديم)
              //  ✅ يستمع فقط لـ _highlightsNotifier (يتغير عند الضغط الطويل فقط)
              //  ✅ محاط بـ RepaintBoundary لعزل الـ repaints
              _QuranPageViewWrapper(
                pageViewKey: _pageViewKey,
                controller: _controller,
                isDark: _isDark,
                highlightsNotifier: _highlightsNotifier,
                onPageChanged: _onPageChanged,
                onLongPress: (surah, ayah, details) async {
                  final items = await _buildMenuItems(surah, ayah);
                  if (!context.mounted) return;
                          
                  // تحديث الـ highlights عبر ValueNotifier بدل Cubit
                  // ده بيمنع rebuild الـ QuranPageView كاملة
                  context
                      .read<VerseSelectionCubit>()
                      .selectVerse(surah, ayah);
                  final selected =
                      context.read<VerseSelectionCubit>().state;
                  if (selected != null) {
                    final parts = selected.split(':');
                    final s = int.parse(parts[0]);
                    final a = int.parse(parts[1]);
                    _highlightsNotifier.value = [
                      HighlightVerse(
                        surah: s,
                        verseNumber: a,
                        page: getPageNumber(s, a),
                        color: Colors.yellow.withValues(alpha: 0.3),
                      ),
                    ];
                  } else {
                    _highlightsNotifier.value = const [];
                  }
                          
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
                        centerOffset: details.globalPosition -
                            Offset(
                              MediaQuery.of(context).size.width / 2,
                              MediaQuery.of(context).size.height / 2,
                            ),
                        useScreenCenter: true,
                      ),
                      items: items,
                      onItemTapped: (index, controller) {
                        controller.closeMenu!();
                        if (index == 3) {
                          _invalidateBookmarkCache(surah, ayah);
                        }
                        VerseActionHandler.handleAction(
                          index: index,
                          context: context,
                          surah: surah,
                          ayah: ayah,
                        );
                      },
                    ),
                  );
                },
                currentPageNotifier: _currentPageNotifier,
              ),

              // ─── Slider (Removed as per requirements) ───

              // ─── AppBar ───
              ValueListenableBuilder<bool>(
                valueListenable: _showUI,
                builder: (_, show, __) => AnimatedPositioned(
                  duration: const Duration(milliseconds: 100),
                  top: show ? 0 : -120.h,
                  left: 0,
                  right: 0,
                  child: ValueListenableBuilder<int>(
                    valueListenable: _currentPageNotifier,
                    builder: (_, page, __) => SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: CustomSurahFramWidget(index: page),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  _QuranPageViewWrapper
// ─────────────────────────────────────────────
// تم تحويله من StatelessWidget إلى StatefulWidget
//
// السبب:
//  - الكود القديم: كان يستخدم context.select(VerseSelectionCubit) مباشرة
//    → كل تغيير في state الـ Cubit كان يعيد بناء QuranPageView كاملة
//    → QuranPageView.constructor يُشغّل _loadQuranData() مرة ثانية
//    → هذا كان يسبب الـ lag والتقطيع
//
//  - الكود الجديد: يستمع فقط لـ ValueNotifier<List<HighlightVerse>>
//    → الـ rebuild يحدث فقط عند الضغط الطويل على آية
//    → أثناء التقليب بين الصفحات: zero rebuilds للـ QuranPageView
class _QuranPageViewWrapper extends StatefulWidget {
  final GlobalKey pageViewKey;
  final PageController controller;
  final bool isDark;
  final ValueNotifier<List<HighlightVerse>> highlightsNotifier;
  final ValueChanged<int> onPageChanged;
  final void Function(int surah, int ayah, LongPressStartDetails details)
      onLongPress;
  final ValueNotifier<int> currentPageNotifier;

  const _QuranPageViewWrapper({
    required this.pageViewKey,
    required this.controller,
    required this.isDark,
    required this.highlightsNotifier,
    required this.onPageChanged,
    required this.onLongPress,
    required this.currentPageNotifier,
  });

  @override
  State<_QuranPageViewWrapper> createState() => _QuranPageViewWrapperState();
}

class _QuranPageViewWrapperState extends State<_QuranPageViewWrapper> {
  late List<HighlightVerse> _highlights;

  @override
  void initState() {
    super.initState();
    _highlights = widget.highlightsNotifier.value;
    widget.highlightsNotifier.addListener(_onHighlightsChanged);
  }

  void _onHighlightsChanged() {
    if (mounted) {
      setState(() {
        _highlights = widget.highlightsNotifier.value;
      });
    }
  }

  @override
  void dispose() {
    widget.highlightsNotifier.removeListener(_onHighlightsChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('QuranPageViewWrapper BUILD');
    return QuranPageView(
      key: widget.pageViewKey,
      pageController: widget.controller,
      onPageChanged: widget.onPageChanged,
      isDarkMode: widget.isDark,
 
      isTajweed: false,
      highlights: _highlights,
      onLongPress: widget.onLongPress,
      bottomBar: ValueListenableBuilder<int>(
        valueListenable: widget.currentPageNotifier,
        builder: (context, page, _) {
          
          final pos = QuranPageIndex.firstAyahOnPage(page);
          final juz = getJuzNumber(pos.surah, pos.ayah);
          final hizb = getHizbTextByPage(page);

          return Container(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textDirection: TextDirection.rtl,
              children: [
                Text(
                  'الجزء $juz',
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 16.sp,
                    color: widget.isDark ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  '$page',
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 16.sp,
                    color: widget.isDark ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  hizb,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 16.sp,
                    color: widget.isDark ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  AyahPosition & QuranPageIndex
// ─────────────────────────────────────────────

class AyahPosition {
  final int surah;
  final int ayah;
  const AyahPosition(this.surah, this.ayah);
}

class QuranPageIndex {
  static Map<int, AyahPosition>? _firstAyahByPage;

  static void ensureBuilt() {
    if (_firstAyahByPage != null) return;
    final map = <int, AyahPosition>{};
    for (int s = 1; s <= 114; s++) {
      final ayahCount = getVerseCount(s);
      for (int a = 1; a <= ayahCount; a++) {
        final p = getPageNumber(s, a);
        map.putIfAbsent(p, () => AyahPosition(s, a));
      }
    }
    _firstAyahByPage = map;
  }

  static AyahPosition firstAyahOnPage(int page) {
    final idx = _firstAyahByPage;
    if (idx == null) throw StateError('Call QuranPageIndex.ensureBuilt() first');
    return idx[page] ?? const AyahPosition(1, 1);
  }
}