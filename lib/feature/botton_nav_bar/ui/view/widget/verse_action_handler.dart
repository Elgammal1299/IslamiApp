import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/router/app_routes.dart';
import 'package:islami_app/core/services/bookmark_manager.dart';
import 'package:islami_app/core/services/setup_service_locator.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/widget/audio_bottom_sheet.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/quran_audio_cubit/quran_audio_cubit.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/verse_selection_cubit.dart';
import 'package:quran/quran.dart' as quran;
import 'package:share_plus/share_plus.dart';

class VerseActionHandler {
  static void handleAction({
    required int index,
    required BuildContext context,
    required int surah,
    required int ayah,
  }) async {
    final isBookmarked = await sl<BookmarkManager>().isBookmarked(surah, ayah);
    final cumulativeNumber = _getCumulativeAyahNumber(surah, ayah);

    if (context.mounted) {
      context.read<VerseSelectionCubit>().clearSelection();
    }

    switch (index) {
      case 0: // Play
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder:
              (_) => BlocProvider.value(
                value: sl<QuranAudioCubit>(),
                child: AudioBottomSheet(
                  ayahNumber: ayah,
                  ayahText: quran.getVerse(surah, ayah, verseEndSymbol: true),
                  surahNumber: surah,
                  surahName: quran.getSurahNameArabic(surah),
                ),
              ),
        );
        break;
      case 1: // Tafsir
        Navigator.pushNamed(
          context,
          AppRoutes.tafsirDetailsByAyahRouter,
          arguments: {
            "tafsirIdentifier": "ar.muyassar",
            "verse": cumulativeNumber,
            "text": quran.getVerse(surah, ayah),
          },
        );
        break;
      case 2: // Copy
        Clipboard.setData(ClipboardData(text: quran.getVerse(surah, ayah)));
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم نسخ الآية')));
        break;
      case 3: // Bookmark
        if (isBookmarked) {
          await sl<BookmarkManager>().removeBookmark(surah, ayah);
        } else {
          await sl<BookmarkManager>().addBookmark(surah, ayah);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isBookmarked ? 'تم إزالة المرجعية' : 'تمت إضافة المرجعية',
            ),
          ),
        );
        break;
      case 4: // Share Text
        Share.share(
          '${quran.getVerse(surah, ayah)}\n\nسورة ${quran.getSurahNameArabic(surah)} - آية $ayah',
        );
        break;
      case 5: // Share Image (Preview & Customize)
        Navigator.pushNamed(
          context,
          AppRoutes.verseSharePreviewRouter,
          arguments: {'surah': surah, 'ayah': ayah},
        );
        break;
    }
  }

  static int _getCumulativeAyahNumber(int surahNumber, int ayahNumber) {
    int cumulativeNumber = 0;
    for (int i = 1; i < surahNumber; i++) {
      cumulativeNumber += quran.getVerseCount(i);
    }
    return cumulativeNumber + ayahNumber;
  }
}
