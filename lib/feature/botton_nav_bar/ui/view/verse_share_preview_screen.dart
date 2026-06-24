import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qcf_quran_plus/src/widgets/surah_header_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qcf_quran_plus/src/data/quran_data.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/verse_share_theme.dart';
import 'package:islami_app/feature/botton_nav_bar/data/repo/tafsir_repo.dart';
import 'package:islami_app/core/services/setup_service_locator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qcf_quran_plus/qcf_quran_plus.dart';
// import 'package:quran/quran.dart' as quran;
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gal/gal.dart';

class VerseSharePreviewScreen extends StatefulWidget {
  final int surah;
  final int ayah;

  const VerseSharePreviewScreen({
    super.key,
    required this.surah,
    required this.ayah,
  });

  @override
  State<VerseSharePreviewScreen> createState() =>
      _VerseSharePreviewScreenState();
}

class _VerseSharePreviewScreenState extends State<VerseSharePreviewScreen> {
  // Options
  double _fontSize = 24;
  VerseShareTheme _selectedTheme = VerseShareTheme.themes[0];
  bool _isThemeInitialized = false;

  bool _addTafsir = false;
  String? _tafsirText;
  bool _isLoadingTafsir = false;

  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isThemeInitialized) {
      if (Theme.of(context).brightness == Brightness.dark) {
        _selectedTheme = VerseShareTheme.themes[1];
      }
      _isThemeInitialized = true;
    }
  }

  @override
  void initState() {
    super.initState();
    // Pre-calculate QCF page font
    // quran.getPageNumber(widget.surah, widget.ayah);
  }

  Future<void> _fetchTafsir() async {
    if (_tafsirText != null) return;
    setState(() => _isLoadingTafsir = true);
    final repo = sl<TafsirByAyahRepository>();
    final result = await repo.getAyahTafsir(
      "${widget.surah}:${widget.ayah}",
      "ar.muyassar",
    );
    result.fold(
      (error) => debugPrint(error),
      (tafsir) => setState(() => _tafsirText = tafsir.data?.text),
    );
    setState(() => _isLoadingTafsir = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "تخصيص المشاركة",
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).cardColor,
        foregroundColor: Theme.of(context).primaryColorDark,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Preview Area
            Screenshot(
              controller: _screenshotController,
              child: _buildImageContent(),
            ),

            // Controls
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("سمات التصميم"),
                  SizedBox(height: 10.h),
                  _buildThemeSelector(),

                  SizedBox(height: 20.h),
                  _buildSectionTitle("حجم الخط"),
                  Slider(
                    value: _fontSize,
                    min: 18,
                    max: 40,
                    activeColor: Colors.grey,//_selectedTheme.secondaryColor,
                    // thumbColor: Colors.white,
                    inactiveColor: Theme.of(context).primaryColorDark,
                    onChanged: (v) => setState(() => _fontSize = v),
                  ),

                  SizedBox(height: 10.h),
                  SizedBox(height: 10.h),

                  SizedBox(height: 10.h),
                  _buildToggle("إضافة التفسير", _addTafsir, (v) {
                    setState(() => _addTafsir = v);
                    if (v) _fetchTafsir();
                  }),

                  if (_addTafsir && _isLoadingTafsir)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),

                  SizedBox(height: 30.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          label: "حفظ",
                          icon: Icons.download,
                          color: Colors.blueGrey,
                          onTap: _saveToGallery,
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: _buildActionButton(
                          label: "مشاركة",
                          icon: Icons.share,
                          color: const Color(0xff2B6777),
                          onTap: _shareImage,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Amiri',
        color: Theme.of(context).primaryColorDark,
      ),
    );
  }

  Widget _buildThemeSelector() {
    return SizedBox(
      height: 60.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: VerseShareTheme.themes.length,
        itemBuilder: (context, index) {
          final theme = VerseShareTheme.themes[index];
          final isSelected = _selectedTheme == theme;
          return GestureDetector(
            onTap: () => setState(() => _selectedTheme = theme),
            child: Container(
              width: 50.w,
              margin: EdgeInsets.only(left: 10.w),
              decoration: BoxDecoration(
                color: theme.backgroundColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? theme.secondaryColor : Colors.transparent,
                  width: 3,
                ),
                boxShadow: [
                  // ignore: prefer_const_constructors
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildToggle(String label, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Switch.adaptive(
          value: value,
          activeColor: _selectedTheme.secondaryColor,
          onChanged: onChanged,
        ),
        Text(label, style: TextStyle(fontFamily: 'Amiri', fontSize: 16.sp)),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 20.sp),
      label: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Amiri',
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
      ),
    );
  }

  Widget _buildImageContent() {
    final bool isDark = _selectedTheme == VerseShareTheme.themes[1];

    // ── نلف الكل في Theme محلي لإعطاء SurahHeaderWidget اللون الصح ──
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.copyWith(
          bodyLarge: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: _selectedTheme.primaryColor,
          ),
        ),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: _selectedTheme.backgroundColor),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 8.h),

            // ─── Header السورة من الباكدج ───
            SurahHeaderWidget(suraNumber: widget.surah),

            // ─── خط فاصل أنيق تحت الهيدر ───
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 20.w),
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: Divider(
            //           color: _selectedTheme.primaryColor.withValues(alpha: 0.2),
            //           thickness: 0.8,
            //         ),
            //       ),
            //       Padding(
            //         padding: EdgeInsets.symmetric(horizontal: 8.w),
            //         child: Icon(
            //           Icons.star,
            //           size: 10.sp,
            //           color: _selectedTheme.primaryColor.withValues(alpha: 0.35),
            //         ),
            //       ),
            //       Expanded(
            //         child: Divider(
            //           color: _selectedTheme.primaryColor.withValues(alpha: 0.2),
            //           thickness: 0.8,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            // SizedBox(height: 8.h),

            // ─── الآية بالنص العثماني ───
            _VerseOthmanicWidget(
              surah: widget.surah,
              ayah: widget.ayah,
              fontSize: _fontSize,
              
              isDark: isDark,
              primaryColor: _selectedTheme.primaryColor,
              secondaryColor: _selectedTheme.secondaryColor,
            ),

            // ─── التفسير إن وُجد ───
            if (_addTafsir && _tafsirText != null) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Divider(
                  height: 16,
                  color: _selectedTheme.primaryColor.withValues(alpha: 0.25),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  _tafsirText!,
                  textAlign: TextAlign.justify,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: (_fontSize * 0.58).sp,
                    color: _selectedTheme.primaryColor.withValues(alpha: 0.75),
                    fontFamily: 'Amiri',
                    height: 1.7,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
            ],

            // ─── شعار التطبيق في الأسفل ───
            _buildBottomBanner(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBanner() {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h, top: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 30.w,
            height: 0.8,
            color: _selectedTheme.primaryColor.withValues(alpha: 0.2),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              "تطبيق وارتَقِ",
              style: TextStyle(
                fontSize: 12.sp,
                fontFamily: 'Amiri',
                fontWeight: FontWeight.bold,
                color: _selectedTheme.primaryColor.withValues(alpha: 0.45),
                letterSpacing: 0.5,
              ),
            ),
          ),
          Container(
            width: 30.w,
            height: 0.8,
            color: _selectedTheme.primaryColor.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }

  Future<void> _shareImage() async {
    final image = await _screenshotController.capture();
    if (image == null) return;

    final tempDir = await getTemporaryDirectory();
    final file =
        await File(
          '${tempDir.path}/verse_${widget.surah}_${widget.ayah}.png',
        ).create();
    await file.writeAsBytes(image);

    await Share.shareXFiles(
      [XFile(file.path)],
      text:
          "سورة ${getSurahNameArabic(widget.surah)} آية ${widget.ayah}\nتمت المشاركة من تطبيق وارتَقِ",
    );
  }

  Future<void> _saveToGallery() async {
    final image = await _screenshotController.capture();
    if (image == null) return;

    try {
      // Check for permission first
      bool hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        hasAccess = await Gal.requestAccess();
      }

      if (hasAccess) {
        final tempDir = await getTemporaryDirectory();
        final path =
            '${tempDir.path}/verse_${widget.surah}_${widget.ayah}_${DateTime.now().millisecondsSinceEpoch}.png';
        final file = File(path);
        await file.writeAsBytes(image);

        await Gal.putImage(file.path, album: 'Islami App');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "تم حفظ الصورة في الاستوديو بنجاح",
                style: TextStyle(fontFamily: 'Cairo'),
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "نحتاج إلى إذن للوصول إلى الاستوديو لحفظ الصورة",
                style: TextStyle(fontFamily: 'Amiri'),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print(e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "حدث خطأ أثناء حفظ الصورة: $e",
              style: const TextStyle(fontFamily: 'Amiri'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/// Widget خاص بعرض آية واحدة بالخط العثماني الأصيل
/// يستخدم QuranSurahListView من الباكدج لكن بيعرض آية واحدة بس

class _VerseOthmanicWidget extends StatelessWidget {
  final int surah;
  final int ayah;
  final double fontSize;
  final bool isDark;
  final Color primaryColor;
  final Color secondaryColor;

  const _VerseOthmanicWidget({
    required this.surah,
    required this.ayah,
    required this.fontSize,
    required this.isDark,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final ayahData = quran.firstWhere(
      (e) => e['sora'] == surah && e['aya_no'] == ayah ,
    );

    final int pageNumber = ayahData['page'];

    final String othmanicText = ayahData['qcfData']
        .toString()
        .replaceAll('\n', '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trimRight();

    final String glyph = getaya_noQCF(surah, ayah);

    String textWithoutGlyph = othmanicText;

    final bool hasGlyph = othmanicText.endsWith(glyph);

    if (hasGlyph) {
      textWithoutGlyph = othmanicText.substring(
        0,
        othmanicText.length - glyph.length,
      
      );
    }

    final defaultStyle = QuranTextStyles.qcfStyle(

      pageNumber: pageNumber,
      height: 1.8,
      color: primaryColor,
    );

    final mainTextStyle = defaultStyle.copyWith(
      fontSize: fontSize,
      height: 1.8,
      
    );

    final numberTextStyle = defaultStyle.copyWith(
      fontSize: fontSize,
      height: 1.8,
      color: secondaryColor,
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: textWithoutGlyph,
              style: mainTextStyle,
            ),
            if (hasGlyph)
              TextSpan(
                text: glyph,
                style: numberTextStyle,
              ),
          ],
        ),
      ),
    );
  }
}