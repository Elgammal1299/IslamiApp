import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qcf_quran/qcf_quran.dart';
import 'package:quran/quran.dart' as quran;
import 'package:wakelock_plus/wakelock_plus.dart';
import '../view_model/reading_progress_cubit.dart';
import 'widget/custom_surah_fram_widget.dart';

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

  @override
  void initState() {
    super.initState();
    _currentPage = widget.pageNumber;
    _controller = PageController(initialPage: widget.pageNumber - 1);

    WakelockPlus.enable();
    QuranPageIndex.ensureBuilt();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _controller.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) async {
    // PageviewQuran generates 1-based page numbers
    setState(() {
      _currentPage = page;
    });

    final pos = QuranPageIndex.firstAyahOnPage(page);
    final cubit = context.read<ReadingProgressCubit>();
    await cubit.updateReadingProgress(pos.surah, pos.ayah, page);
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
              top: 20.h,
              left: 0,
              right: 0,
              bottom: 0,
              child: PageviewQuran(
                pageBackgroundColor: const Color(0xffFFF8EE),
                controller: _controller,
                onPageChanged: _onPageChanged,
                initialPageNumber: widget.pageNumber,
                
                sp: 1.08.sp, // تقليل القيمة لتقليل المسافة الجانبية
                h: 1.h,
              
                textColor: Colors.black,
              ),
            ),
            if (_showUI)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: CustomSurahFramWidget(index: _currentPage),
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
