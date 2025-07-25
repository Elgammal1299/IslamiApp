import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter/services.dart';
import 'package:islami_app/core/router/app_routes.dart';

import 'package:islami_app/core/services/bookmark_manager.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/widget/audio_bottom_sheet.dart';

import 'package:islami_app/feature/home/data/model/tafsir_model.dart';
import 'package:quran/quran.dart';
import 'package:quran/quran.dart' as quran;
import 'package:share_plus/share_plus.dart';

class BottonSheetItem extends StatefulWidget {
  final int verse;
  final int surah;
  final int cumulativeNumber;
  const BottonSheetItem({
    super.key,
    required this.verse,
    required this.surah,
    required this.cumulativeNumber,
  });

  @override
  State<BottonSheetItem> createState() => _BottonSheetItemState();
}

class _BottonSheetItemState extends State<BottonSheetItem> {
  // int getCumulativeAyahNumber(int surahNumber, int ayahNumber) {
  //   int cumulativeNumber = 0;

  //   for (int i = 1; i < surahNumber; i++) {
  //     cumulativeNumber += Quran.getVerseCount(i);
  //   }

  //   return cumulativeNumber + ayahNumber;
  // }

  final List<Data> tafsirIdentifiers = [];
  late String audioURL;
  late AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    audioURL =
        "https://cdn.islamic.network/quran/audio/128/ar.alafasy/${widget.cumulativeNumber}.mp3";
    audioPlayer = AudioPlayer();
    debugPrint('$audioURL ==========');
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  m.Widget build(m.BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.play_arrow),
            title: Text(
              "استماع ",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            onTap: () {
              // await audioPlayer.play(UrlSource(audioURL));
              Navigator.pop(context);
              showModalBottomSheet(
                scrollControlDisabledMaxHeightRatio: 1,
                context: context,
                builder:
                    (_) => AudioBottomSheet(
                      audioUrl: audioURL,
                      ayah: quran.getVerse(widget.surah, widget.verse),
                    ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.menu_book),
            title: Text(
              "التفسير",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            onTap: () {
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.tafsirDetailsByAyahRouter,
                arguments: {
                  "tafsirIdentifier": "ar.muyassar",
                  "verse": widget.cumulativeNumber,
                  "text": quran.getVerse(widget.surah, widget.verse),
                },
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.copy),
            title: Text(
              'نسخ الآية',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            onTap: () {
              Clipboard.setData(
                ClipboardData(text: quran.getVerse(widget.surah, widget.verse)),
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('تم نسخ الآية')));
            },
          ),
          FutureBuilder<bool>(
            future: BookmarkManager.isBookmarked(widget.surah, widget.verse),
            builder: (context, snapshot) {
              bool isBookmarked = snapshot.data ?? false;
              return ListTile(
                leading: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                ),
                title: Text(
                  isBookmarked ? 'إزالة من المرجعيات' : 'إضافة إلى المرجعيات',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                onTap: () async {
                  if (isBookmarked) {
                    await BookmarkManager.removeBookmark(
                      widget.surah,
                      widget.verse,
                    );
                  } else {
                    await BookmarkManager.addBookmark(
                      widget.surah,
                      widget.verse,
                    );
                  }
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isBookmarked
                            ? 'تم إزالة الآية من المرجعيات'
                            : 'تمت إضافة الآية إلى المرجعيات',
                      ),
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: Text(
              'مشاركة الآية',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            onTap: () {
              Share.share(
                '${getVerse(widget.surah, widget.verse)}\n\n'
                'سورة ${getSurahNameArabic(widget.surah)} - آية ${widget.verse}',
              );

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
