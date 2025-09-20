import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter/services.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/core/router/app_routes.dart';

import 'package:islami_app/core/services/bookmark_manager.dart';
import 'package:islami_app/core/services/setup_service_locator.dart';
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

  // Future<void> _shareAyahAsImage(
  //   String ayahText,
  //   String surahName,
  //   int verseNumber,
  //   int totalVerses,
  //   BuildContext context,
  // ) async {
  //   Navigator.pop(context);
  //   try {
  //     final recorder = ui.PictureRecorder();
  //     final canvas = Canvas(recorder);
  //     const double padding = 24.0;

  //     // إعدادات نص الآية
  //     const ayahStyle = TextStyle(
  //       fontSize: 35,
  //       color: Colors.black,
  //       fontWeight: FontWeight.bold,
  //       height: 2.0, // زيادة المسافة بين السطور
  //     );

  //     // إعدادات نص الفريم العلوي
  //     const headerStyle = TextStyle(
  //       fontSize: 22,
  //       fontWeight: FontWeight.bold,
  //       color: Colors.black87,
  //     );

  //     // رسم الفريم العلوي
  //     final headerText = 'سورة $surahName - آية $verseNumber';
  //     final headerSpan = TextSpan(text: headerText, style: headerStyle);
  //     final headerPainter = TextPainter(
  //       text: headerSpan,

  //       textAlign: TextAlign.right,
  //       textDirection: TextDirection.ltr,
  //     );
  //     headerPainter.layout(maxWidth: 800);

  //     // رسم نص الآية
  //     final ayahSpan = TextSpan(text: ayahText, style: ayahStyle);
  //     final ayahPainter = TextPainter(
  //       text: ayahSpan,
  //       textDirection: TextDirection.rtl,
  //       textAlign: TextAlign.justify,
  //     );
  //     ayahPainter.layout(maxWidth: 800);

  //     // حساب حجم الصورة
  //     final width =
  //         (ayahPainter.width > headerPainter.width
  //             ? ayahPainter.width
  //             : headerPainter.width) +
  //         padding * 2;
  //     final height = headerPainter.height + ayahPainter.height + padding * 5;

  //     // رسم الخلفية البيضاء
  //     final paint = Paint()..color = Colors.white;
  //     canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paint);

  //     // رسم الفريم العلوي (مثلاً باللون الرمادي الفاتح)
  //     final headerBgPaint = Paint()..color = Colors.grey.shade200;
  //     canvas.drawRect(
  //       Rect.fromLTWH(0, 0, width, headerPainter.height + padding * 1.2),
  //       headerBgPaint,
  //     );

  //     // رسم نص الفريم العلوي
  //     headerPainter.paint(canvas, const Offset(padding, padding / 2));

  //     // رسم نص الآية أسفل الفريم
  //     ayahPainter.paint(
  //       canvas,
  //       Offset(padding, headerPainter.height + padding * 2),
  //     );

  //     // تحويل الرسم إلى صورة
  //     final picture = recorder.endRecording();
  //     final img = await picture.toImage(width.toInt(), height.toInt());
  //     final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  //     final pngBytes = byteData!.buffer.asUint8List();

  //     // حفظ الصورة مؤقتًا
  //     final tempDir = await getTemporaryDirectory();
  //     final file = await File('${tempDir.path}/ayah.png').create();
  //     await file.writeAsBytes(pngBytes);

  //     // مشاركة الصورة
  //     await Share.shareXFiles([XFile(file.path)], text: 'الآية');
  //   } catch (e) {
  //     print('Error sharing ayah image: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('حدث خطأ أثناء مشاركة الآية')),
  //     );
  //   }
  // }

  @override
  m.Widget build(m.BuildContext context) {
    // final ayahText = quran.getVerse(widget.surah, widget.verse);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.play_arrow),
            title: Text("استماع ", style: context.textTheme.titleLarge),
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
            title: Text("التفسير", style: context.textTheme.titleLarge),
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
            title: Text('نسخ الآية', style: context.textTheme.titleLarge),
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
          // ListTile(
          //   leading: const Icon(Icons.image),
          //   title: const Text('مشاركة الآية كصورة'),
          //   onTap:
          //       () => _shareAyahAsImage(
          //         ayahText,
          //         quran.getSurahNameArabic(widget.surah),
          //         widget.verse,
          //         quran.getVerseCount(widget.surah),
          //         context,
          //       ),
          // ),
          FutureBuilder<bool>(
            future: sl<BookmarkManager>().isBookmarked(
              widget.surah,
              widget.verse,
            ),
            builder: (context, snapshot) {
              bool isBookmarked = snapshot.data ?? false;
              return ListTile(
                leading: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                ),
                title: Text(
                  isBookmarked ? 'إزالة من المرجعيات' : 'إضافة إلى المرجعيات',
                  style: context.textTheme.titleLarge,
                ),
                onTap: () async {
                  if (isBookmarked) {
                    await sl<BookmarkManager>().removeBookmark(
                      widget.surah,
                      widget.verse,
                    );
                  } else {
                    await sl<BookmarkManager>().addBookmark(
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
            title: Text('مشاركة الآية', style: context.textTheme.titleLarge),
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
