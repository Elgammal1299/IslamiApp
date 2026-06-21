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
import 'widget/quran_page_slider.dart';
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
  // نستخدم ValueNotifier بدل setState لتجنب rebuild كاملة للـ tree
  final ValueNotifier<bool> _showUI = ValueNotifier(false);

  late int _currentPage;
  final GlobalKey _pageViewKey = GlobalKey();

  // ─── Bookmark cache ───
  // Cache بسيط: key = "surah:ayah", value = isBookmarked
  // يتحدث تلقائياً بعد أي تغيير من VerseActionHandler
  final Map<String, bool> _bookmarkCache = {};
  bool _cacheReady = false;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.pageNumber;
    _controller = PageController(initialPage: widget.pageNumber - 1);

    WakelockPlus.enable();

    // بناء الـ index مرة واحدة عند أول استخدام
    QuranPageIndex.ensureBuilt();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _updateProgress(_currentPage);
      // تحميل مسبق للـ bookmarks للصفحة الحالية
      _preloadBookmarksForPage(_currentPage);
    });
  }

  // ─── تحميل مسبق لـ bookmarks الصفحة الحالية والمجاورة ───
  Future<void> _preloadBookmarksForPage(int page) async {
    if (_cacheReady) return;
    // ما نحتاجش نعمل حاجة هنا لأن الـ bookmarks بتتحمل عند الـ long press
    // بس نحضّر الـ cache flag
    _cacheReady = true;
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
    WakelockPlus.disable();
    _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  // ─── Page changed ───
  // لا نعمل setState هنا إلا لو _showUI كانت true (الـ slider ظاهر)
  // لأن currentPage مش مستخدم في الـ UI المرئي أثناء الـ scroll
  void _onPageChanged(int page) {
    _currentPage = page;

    // لو الـ UI ظاهر، نحتاج rebuild عشان الـ slider يتحدث
    // لو مش ظاهر، مش محتاجين حاجة
    if (_showUI.value) {
      // بدل setState، نستخدم ValueNotifier لتحديث الـ slider فقط
      _showUI.notifyListeners();
    }

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      _updateProgress(page);
    });
  }

  void _onSliderChanged(int page) {
    _controller.jumpToPage(page - 1);
    _currentPage = page;
    _showUI.notifyListeners();
  }

  // ─── Bookmark helpers ───
  Future<bool> _isBookmarked(int s, int a) async {
    final key = '$s:$a';
    if (_bookmarkCache.containsKey(key)) return _bookmarkCache[key]!;
    final val = await sl<BookmarkManager>().isBookmarked(s, a);
    _bookmarkCache[key] = val;
    return val;
  }

  // إعادة تحميل الـ cache بعد تغيير bookmark
  void _invalidateBookmarkCache(int s, int a) {
    _bookmarkCache.remove('$s:$a');
  }

  // بناء قائمة الـ items للـ StarMenu
  // يتعمل مرة واحدة بناءً على حالة الـ bookmark الحالية
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).primaryColorLight,
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
              // استخدام _QuranPageViewWrapper لمنع rebuild من VerseSelectionCubit
              Positioned.fill(
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: const TextScaler.linear(1.0),
                  ),
                  child: _QuranPageViewWrapper(
                    pageViewKey: _pageViewKey,
                    controller: _controller,
                    isDark: isDark,
                    onPageChanged: _onPageChanged,
                    onLongPress: (surah, ayah, details) async {
                      // تحميل الـ items بشكل async (مرة واحدة)
                      final items = await _buildMenuItems(surah, ayah);
                      if (!context.mounted) return;

                      // تحديد الـ verse المختار
                      context
                          .read<VerseSelectionCubit>()
                          .selectVerse(surah, ayah);

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
                            // لو كان action هو bookmark، نعمل invalidate للـ cache
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
                  ),
                ),
              ),

              // ─── Slider: يتحدث بـ ValueListenableBuilder بدل setState ───
              ValueListenableBuilder<bool>(
                valueListenable: _showUI,
                builder: (_, show, child) => AnimatedPositioned(
                  duration: const Duration(milliseconds: 100),
                  bottom: show ? 40.h : -200.h,
                  left: 10.w,
                  right: 10.w,
                  child: QuranPageSlider(
                    currentPage: _currentPage,
                    totalPages: 604,
                    onPageChanged: _onSliderChanged,
                  ),
                ),
              ),

              // ─── AppBar: يتحدث بـ ValueListenableBuilder بدل setState ───
              ValueListenableBuilder<bool>(
                valueListenable: _showUI,
                builder: (_, show, child) => AnimatedPositioned(
                  duration: const Duration(milliseconds: 100),
                  top: show ? 0 : -120.h,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: CustomSurahFramWidget(index: _currentPage),
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
class _QuranPageViewWrapper extends StatelessWidget {
  final GlobalKey pageViewKey;
  final PageController controller;
  final bool isDark;
  final ValueChanged<int> onPageChanged;
  final void Function(int surah, int ayah, LongPressStartDetails details)
      onLongPress;

  const _QuranPageViewWrapper({
    required this.pageViewKey,
    required this.controller,
    required this.isDark,
    required this.onPageChanged,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    // نستخدم context.select هنا بدل في الـ parent
    // عشان الـ rebuild يتحصر في الـ wrapper ده بس
    final selectedVerseId =
        context.select((VerseSelectionCubit c) => c.state);

    final List<HighlightVerse> highlights;
    if (selectedVerseId != null) {
      final parts = selectedVerseId.split(':');
      final s = int.parse(parts[0]);
      final a = int.parse(parts[1]);
      highlights = [
        HighlightVerse(
          surah: s,
          verseNumber: a,
          page: getPageNumber(s, a),
          color: Colors.yellow.withValues(alpha: 0.3),
        ),
      ];
    } else {
      highlights = const [];
    }

    return QuranPageView(
    
      key: pageViewKey,
      pageController: controller,
      onPageChanged: onPageChanged,
      isDarkMode: isDark,
      isTajweed: false,
      highlights: highlights,
      onLongPress: onLongPress,
    );
  }
}


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