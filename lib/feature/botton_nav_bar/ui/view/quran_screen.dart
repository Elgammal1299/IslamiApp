import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami_app/feature/khatmah/view/widget/khatmah_progress_tracker.dart';
import 'package:islami_app/feature/khatmah/view_model/khatmah_cubit.dart';
import 'package:quran/quran.dart' as quran;
import 'package:wakelock_plus/wakelock_plus.dart';
import '../view_model/reading_progress_cubit.dart';
import 'widget/custom_surah_fram_widget.dart';
import '../view_model/verse_selection_cubit.dart';
import 'widget/pageview_quran.dart';
import 'widget/quran_page_slider.dart';
import 'package:star_menu/star_menu.dart';
import 'package:islami_app/core/services/bookmark_manager.dart';
import 'package:islami_app/core/services/setup_service_locator.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/widget/verse_action_handler.dart';

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
  bool _showUI = false;
  late int _currentPage;
  final GlobalKey _pageViewKey = GlobalKey();

  late double scale;

  final Map<String, bool> _bookmarkCache = {};
  Timer? _debounce;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // نحسب scale مرة واحدة فقط
    final screenWidth = MediaQuery.of(context).size.width ;
    scale = 396.72727272727275 / screenWidth;
    
  }

  @override
  void initState() {
    super.initState();

    _currentPage = widget.pageNumber;
    _controller = PageController(initialPage: widget.pageNumber - 1);

    WakelockPlus.enable();
    QuranPageIndex.ensureBuilt();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (widget.isKhatmah) {
        _updateKhatmahProgress(_currentPage);
      } else {
        final pos = QuranPageIndex.firstAyahOnPage(_currentPage);
        context.read<ReadingProgressCubit>().updateReadingProgress(
          pos.surah,
          pos.ayah,
          _currentPage,
        );
      }
    });
  }

  void _updateKhatmahProgress(int pageNumber) {
    if (widget.isKhatmah) {
      KhatmahProgressTracker.updateCurrentPage(
        context,
        pageNumber: pageNumber,
        khatmahId: widget.khatmahId,
      );
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    WakelockPlus.disable();
    _controller.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });

    if (_showUI) {
      setState(() {});
    }

    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      if (widget.isKhatmah) {
        _updateKhatmahProgress(page);
      } else {
        final pos = QuranPageIndex.firstAyahOnPage(page);
        context.read<ReadingProgressCubit>().updateReadingProgress(
          pos.surah,
          pos.ayah,
          page,
        );
      }
    });
  }

  void _onSliderChanged(int page) {
    _controller.jumpToPage(page - 1);
    setState(() => _currentPage = page);
  }

  Future<bool> _isBookmarked(int s, int a) async {
    final key = "$s-$a";
    if (_bookmarkCache.containsKey(key)) {
      return _bookmarkCache[key]!;
    }
    final val = await sl<BookmarkManager>().isBookmarked(s, a);
    _bookmarkCache[key] = val;
    return val;
  }

  Future<List<Widget>> _getItems(int surah, int ayah) async {
    final isBookmarked = await _isBookmarked(surah, ayah);

    return [
      _buildMenuItem(Icons.play_arrow, "استماع", Colors.blue),
      _buildMenuItem(Icons.menu_book, "التفسير", Colors.green),
      _buildMenuItem(Icons.copy, "نسخ", Colors.orange),
      _buildMenuItem(
        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
        isBookmarked ? "إزالة" : "حفظ",
        Colors.purple,
      ),
      _buildMenuItem(Icons.share, "نص", Colors.teal),
      _buildMenuItem(Icons.image, "صورة", Colors.redAccent),
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
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedVerseId = context.select((VerseSelectionCubit c) => c.state);

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
          onTap: () => setState(() => _showUI = !_showUI),
          child: Stack(
            children: [
              Positioned(
                top: 30.h,
                left: 0,
                right: 0,
                bottom: 0,
                child: MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: PageviewQuran(
                    key: _pageViewKey,
                    pageBackgroundColor: Theme.of(context).primaryColorLight,
                    controller: _controller,
                    onPageChanged: _onPageChanged,
                    initialPageNumber: widget.pageNumber,
                    selectedVerseId: selectedVerseId,
                    sp: scale,
                    h: scale,
                    textColor: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.normal,
                    onLongPressDown: (surah, ayah, details) async {
                      context.read<VerseSelectionCubit>().selectVerse(
                        surah,
                        ayah,
                      );

                      final items = await _getItems(surah, ayah);

                      if (!context.mounted) return;

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
                            centerOffset:
                                details.globalPosition -
                                Offset(
                                  MediaQuery.of(context).size.width / 2,
                                  MediaQuery.of(context).size.height / 2,
                                ),
                            useScreenCenter: true,
                          ),
                          items: items,
                          onItemTapped: (index, controller) {
                            controller.closeMenu!();
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

              AnimatedPositioned(
                duration: const Duration(milliseconds: 100),
                bottom: _showUI ? 40.h : -200.h,
                left: 10.w,
                right: 10.w,
                child: QuranPageSlider(
                  currentPage: _currentPage,
                  totalPages: 604,
                  onPageChanged: _onSliderChanged,
                ),
              ),

              AnimatedPositioned(
                duration: const Duration(milliseconds: 100),
                top: _showUI ? 0 : -120.h,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: CustomSurahFramWidget(index: _currentPage),
                  ),
                ),
              ),

              Positioned(
                bottom: 5.h,
                left: 10.w,
                right: 10.w,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'الجزء: ${getJuz(_currentPage)}',
                        style: TextStyle(fontSize: 18.sp, fontFamily: 'Amiri'),
                      ),
                      Text(
                        'الصفحة: $_currentPage',
                        style: TextStyle(fontSize: 18.sp, fontFamily: 'Amiri'),
                      ),
                      Text(
                        getHizb(_currentPage),
                        style: TextStyle(fontSize: 18.sp, fontFamily: 'Amiri'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // endDrawer: QuranDrawer(currentSurahIndex: _currentPage),
    );
  }

  int getJuz(int page) {
    final pos = QuranPageIndex.firstAyahOnPage(page);
    return quran.getJuzNumber(
      pos.surah,
      pos.ayah,
    ); // Fetch Juz using quran_package
  }

  String getHizb(int page) {
    if (page == 1) return '1';

    // في مصحف المدينة، كل حزب 10 صفحات، وكل ربع 2.5 صفحة تقريباً
    // الحزب الأول يبدأ من الصفحة 2
    int absoluteQuarter = (((page - 2) / 2.5).floor()) + 1;
    int hizbNumber = ((absoluteQuarter - 1) ~/ 4) + 1;
    int quarter = (absoluteQuarter - 1) % 4;

    if (quarter == 0) {
      return '$hizbNumber';
    } else if (quarter == 1) {
      return ' ربع الحزب $hizbNumber';
    } else if (quarter == 2) {
      return ' نصف الحزب $hizbNumber';
    } else {
      return ' ثلاثة أرباع الحزب $hizbNumber';
    }
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
      final ayahCount = quran.getVerseCount(s);
      for (int a = 1; a <= ayahCount; a++) {
        final p = quran.getPageNumber(s, a);
        map.putIfAbsent(p, () => AyahPosition(s, a));
      }
    }
    _firstAyahByPage = map;
  }

  static AyahPosition firstAyahOnPage(int page) {
    final idx = _firstAyahByPage;
    if (idx == null) {
      throw StateError('Call QuranPageIndex.ensureBuilt() first');
    }
    return idx[page] ?? const AyahPosition(1, 1);
  }
}
