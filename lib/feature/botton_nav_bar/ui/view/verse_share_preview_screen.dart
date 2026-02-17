import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:islami_app/feature/botton_nav_bar/data/model/verse_share_theme.dart';
import 'package:islami_app/feature/botton_nav_bar/data/repo/tafsir_repo.dart';
import 'package:islami_app/core/services/setup_service_locator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qcf_quran/qcf_quran.dart';
import 'package:quran/quran.dart' as quran;
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

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
  bool _showSuraHeader = true;
  bool _showBottomBar = true;
  bool _addTafsir = false;
  String? _tafsirText;
  bool _isLoadingTafsir = false;

  final ScreenshotController _screenshotController = ScreenshotController();

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
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        title: const Text(
          "تخصيص المشاركة",
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Preview Area
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Screenshot(
                controller: _screenshotController,
                child: _buildImageContent(),
              ),
            ),

            // Controls
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
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
                    activeColor: _selectedTheme.secondaryColor,
                    onChanged: (v) => setState(() => _fontSize = v),
                  ),

                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      _buildToggle(
                        "إظهار الهيدر",
                        _showSuraHeader,
                        (v) => setState(() => _showSuraHeader = v),
                      ),
                      const Spacer(),
                      _buildToggle(
                        "إظهار التذييل",
                        _showBottomBar,
                        (v) => setState(() => _showBottomBar = v),
                      ),
                    ],
                  ),

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
                          label: "حفظ في الاستوديو",
                          icon: Icons.download,
                          color: Colors.blueGrey,
                          onTap: _saveToGallery,
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: _buildActionButton(
                          label: "مشاركة الآن",
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
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Cairo',
        color: Colors.grey[700],
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
        Text(label, style: TextStyle(fontFamily: 'Cairo', fontSize: 13.sp)),
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
          fontFamily: 'Cairo',
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
    final pageNumber = quran.getPageNumber(widget.surah, widget.ayah);
    final pageFont = "QCF_P${pageNumber.toString().padLeft(3, '0')}";
    final verseText = getVerseQCF(
      widget.surah,
      widget.ayah,
      verseEndSymbol: false,
    );
    final verseNumberSymbol = getVerseNumberQCF(widget.surah, widget.ayah);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: _selectedTheme.backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_showSuraHeader) ...[
            HeaderWidget(suraNumber: widget.surah),
            SizedBox(height: 20.h),
          ],

          Directionality(
            textDirection: TextDirection.rtl,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text:
                        "${verseText.substring(0, 1)}\u200A${verseText.substring(1)}",
                    style: TextStyle(
                      fontFamily: pageFont,
                      package: 'qcf_quran',
                      fontSize: _fontSize.sp,
                      color: _selectedTheme.primaryColor,
                      height: 2.2,
                    ),
                  ),
                  TextSpan(
                    text: " $verseNumberSymbol",
                    style: TextStyle(
                      fontFamily: pageFont,
                      package: 'qcf_quran',
                      fontSize: _fontSize.sp,
                      color: _selectedTheme.secondaryColor,
                      height: 2.2,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              locale: const Locale("ar"),
            ),
          ),

          if (_addTafsir && _tafsirText != null) ...[
            const Divider(height: 30),
            Text(
              _tafsirText!,
              textAlign: TextAlign.justify,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: (_fontSize * 0.6).sp,
                color: _selectedTheme.primaryColor.withValues(alpha: 0.8),
                fontFamily: 'Cairo',
                height: 1.5,
              ),
            ),
          ],

          if (_showBottomBar) ...[SizedBox(height: 30.h), _buildBottomBanner()],
        ],
      ),
    );
  }

  Widget _buildBottomBanner() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 15.w),
      decoration: BoxDecoration(
        color: _selectedTheme.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "سورة ${quran.getSurahNameArabic(widget.surah)} | آية ${widget.ayah}",
            style: TextStyle(
              fontSize: 10.sp,
              fontFamily: 'Cairo',
              color: _selectedTheme.primaryColor.withValues(alpha: 0.6),
            ),
          ),
          Text(
            "تطبيق وارتَقِ",
            style: TextStyle(
              fontSize: 10.sp,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              color: _selectedTheme.secondaryColor.withValues(alpha: 0.7),
            ),
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
          "سورة ${quran.getSurahNameArabic(widget.surah)} آية ${widget.ayah}\nتمت المشاركة من تطبيق وارتَقِ",
    );
  }

  Future<void> _saveToGallery() async {
    // Note: Implementing gallery saving usually requires permission handling and gallery_saver or similar.
    // For this demonstration, we'll notify the user about the simulation.
    final image = await _screenshotController.capture();
    if (image == null) return;

    // Suggesting the use of a package like gallery_saver if this was a production app
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("جاري حفظ الصورة في الاستوديو... (تمت المحاكاة)"),
      ),
    );
  }
}
