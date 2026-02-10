import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:islami_app/feature/botton_nav_bar/ui/view/widget/verse_action_handler.dart'; // Changed from botton_sheet_item.dart

class QuranViewScreen extends StatefulWidget {
  final int pageNumber;

  const QuranViewScreen({super.key, required this.pageNumber});

  @override
  State<QuranViewScreen> createState() => _QuranViewScreenState();
}

class _QuranViewScreenState extends State<QuranViewScreen> {
  late PageController _controller;
  bool _showUI = false;
  late int _currentPage;
  final GlobalKey _pageViewKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _currentPage = widget.pageNumber;
    _controller = PageController(initialPage: widget.pageNumber - 1);

    WakelockPlus.enable();
    QuranPageIndex.ensureBuilt();

    // Update reading progress for the initial page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final pos = QuranPageIndex.firstAyahOnPage(_currentPage);
        context.read<ReadingProgressCubit>().updateReadingProgress(
          pos.surah,
          pos.ayah,
          _currentPage,
        );
      }
    });
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _controller.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) async {
    setState(() {
      _currentPage = page;
    });

    final pos = QuranPageIndex.firstAyahOnPage(page);
    final cubit = context.read<ReadingProgressCubit>();
    await cubit.updateReadingProgress(pos.surah, pos.ayah, page);
  }

  void _onSliderChanged(int page) {
    _controller.jumpToPage(page - 1);
    setState(() {
      _currentPage = page;
    });
  }

  Widget _buildMenuItem(IconData icon, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: color.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
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
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xffFFF8EE),
      body: GestureDetector(
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
                child: BlocBuilder<VerseSelectionCubit, String?>(
                  builder: (context, selectedVerseId) {
                    Future<List<Widget>> getItems(int surah, int ayah) async {
                      final isBookmarked = await sl<BookmarkManager>()
                          .isBookmarked(surah, ayah);
                      return [
                        _buildMenuItem(Icons.play_arrow, "استماع", Colors.blue),
                        _buildMenuItem(
                          Icons.menu_book,
                          "التفسير",
                          Colors.green,
                        ),
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

                    return PageviewQuran(
                      key: _pageViewKey,
                      pageBackgroundColor: const Color(0xffFFF8EE),
                      controller: _controller,
                      onPageChanged: _onPageChanged,
                      initialPageNumber: widget.pageNumber,
                      selectedVerseId: selectedVerseId,
                      sp: 1..sp,
                      h: 1.4.h,
                      textColor: Colors.black,
                      fontWeight: FontWeight.w600,
                      onLongPressDown: (surah, ayah, details) async {
                        context.read<VerseSelectionCubit>().selectVerse(
                          surah,
                          ayah,
                        );

                        final items = await getItems(surah, ayah);
                        // final isBookmarked = await sl<BookmarkManager>()
                        //     .isBookmarked(surah, ayah); // No longer needed here

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
                              // Positioning the menu using centerOffset relative to screen center
                              centerOffset:
                                  details.globalPosition -
                                  Offset(
                                    MediaQuery.of(context).size.width / 2,
                                    MediaQuery.of(context).size.height / 2,
                                  ),
                              useScreenCenter: true,
                            ),
                            onItemTapped: (index, controller) {
                              controller.closeMenu!();
                              VerseActionHandler.handleAction(
                                index: index,
                                context: context,
                                surah: surah,
                                ayah: ayah,
                              );
                            },
                            items: items,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),

            // Top UI (App Bar)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              top: _showUI ? 0 : -120.h,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {}, // Prevent closing UI when clicking app bar
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: CustomSurahFramWidget(index: _currentPage),
                  ),
                ),
              ),
            ),

            // Bottom UI (Page Slider)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              bottom: _showUI ? 40.h : -200.h,
              left: 10.w,
              right: 10.w,
              child: GestureDetector(
                onTap: () {}, // Prevent closing UI when clicking slider area
                child: QuranPageSlider(
                  currentPage: _currentPage,
                  totalPages: 604,
                  onPageChanged: _onSliderChanged,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Data structures for indexing
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
      throw StateError(
        'Call QuranPageIndex.ensureBuilt() before using firstAyahOnPage',
      );
    }
    return idx[page] ?? const AyahPosition(1, 1);
  }
}
