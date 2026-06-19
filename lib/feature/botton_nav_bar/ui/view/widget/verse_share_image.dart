import 'package:flutter/material.dart';
import 'package:qcf_quran_plus/src/widgets/surah_header_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:quran/quran.dart' as quran;
import 'package:qcf_quran_plus/qcf_quran_plus.dart';

class VerseShareImage extends StatelessWidget {
  final int surah;
  final int ayah;

  const VerseShareImage({super.key, required this.surah, required this.ayah});

  @override
  Widget build(BuildContext context) {
    final pageNumber = getPageNumber(surah, ayah);
    final pageFont = "QCF_P${pageNumber.toString().padLeft(3, '0')}";
    final verseText = getVerse(surah, ayah, verseEndSymbol: false);
    final verseNumberSymbol = getaya_noQCF(surah, ayah);

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
      decoration: const BoxDecoration(color: Color(0xffFFF8EE)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Use the EXACT HeaderWidget from qcf_quran package
          SurahHeaderWidget(suraNumber: surah),

          SizedBox(height: 15.h),

          // The Verse formatted as Mushaf Page
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: verseText,
                      style: TextStyle(
                        fontFamily: pageFont,
                        package: 'qcf_quran_plus',
                        fontSize: 20.sp,
                        color: Colors.black,
                        height: 2.2, // Mushaf height
                      ),
                    ),
                    TextSpan(
                      text: verseNumberSymbol,
                      style: TextStyle(
                        fontFamily: pageFont,
                        package: 'qcf_quran_plus',
                        fontSize: 18.sp,
                        color: Colors.brown,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),

          SizedBox(height: 10.h),

          // Institutional Branding
          Text(
            "تطبيق وارتَقِ",
            style: TextStyle(
              fontSize: 10.sp,
              color: const Color(0xff2B6777).withValues(alpha: 0.5),
              fontWeight: FontWeight.bold,
              fontFamily: 'Amiri',
            ),
          ),
        ],
      ),
    );
  }
}
