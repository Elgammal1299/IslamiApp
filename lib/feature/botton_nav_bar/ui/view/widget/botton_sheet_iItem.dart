import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter/services.dart';
import 'package:islami_app/core/services/bookmark_manager.dart';
import 'package:islami_app/feature/home/data/model/tafsir_model.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/tafsir_details_page.dart';
import 'package:quran/quran.dart';
import 'package:quran/quran.dart' as quran;
import 'package:quran/quran.dart' as Quran;
import 'package:share_plus/share_plus.dart';

class BottonSheetItem extends StatefulWidget {
  final int verse;
  final int surah;



  const BottonSheetItem({super.key, required this.verse, required this.surah});

  @override
  State<BottonSheetItem> createState() => _BottonSheetItemState();
}

class _BottonSheetItemState extends State<BottonSheetItem> {
  int getCumulativeAyahNumber(int surahNumber, int ayahNumber) {
    int cumulativeNumber = 0;

    for (int i = 1; i < surahNumber; i++) {
      cumulativeNumber += Quran.getVerseCount(i);
    }

    return cumulativeNumber + ayahNumber;
  }

  final List<Data> tafsirIdentifiers = [];

  @override
  m.Widget build(m.BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
               ListTile(
                trailing: Icon(Icons.menu_book),
                title: Text(
                  
                  "التفسير",style:  TextStyle(
                fontFamily: "arsura",
                fontSize: 20,
                color: Colors.black,
                
              ),
              textAlign: TextAlign.end,
              ),
                onTap: () {
                   Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => TafsirDetailsPage(
                            tafsirIdentifier: "ar.muyassar",
                            verse: getCumulativeAyahNumber(
                              widget.surah,
                              widget.verse,
                            ),
                            text: quran.getVerse(widget.surah, widget.verse), 
                          ),
                    ),
                  );
                },
             
          ),

          ListTile(
            trailing: const Icon(Icons.copy),
            title: const Text(
              'نسخ الآية',
              style: TextStyle(
                fontFamily: "arsura",
                fontSize: 20,
                color: Colors.black,
              ),
              textAlign: TextAlign.end,

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
                trailing: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                ),
                title: Text(
                  isBookmarked ? 'إزالة من المفضلة' : 'إضافة إلى المفضلة',
                  style: TextStyle(
                    fontFamily: "arsura",
                    fontSize: 20,
                    color: Colors.black,
                  ),
              textAlign: TextAlign.end,

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
                            ? 'تم إزالة الآية من المفضلة'
                            : 'تمت إضافة الآية إلى المفضلة',
                      ),
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            trailing: const Icon(Icons.share),
            title: const Text(
              'مشاركة الآية',
              style: TextStyle(
                fontFamily: "arsura",
                fontSize: 20,
                color: Colors.black,
              ),
              textAlign: TextAlign.end,

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
