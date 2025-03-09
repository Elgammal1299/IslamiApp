import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter/services.dart';
import 'package:islami_app/core/services/bookmark_manager.dart';
import 'package:quran/quran.dart';
import 'package:quran/quran.dart' as quran;
import 'package:share_plus/share_plus.dart';

class BottonSheetItem extends m.StatelessWidget {
 final int verse;
  final int surah;


  const BottonSheetItem({
    super.key,
    required this.surah,
    required this.verse
  });

  @override
  m.Widget build(m.BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.copy),
            title: const Text('نسخ الآية'),
            onTap: () {
              Clipboard.setData(
                ClipboardData(text: quran.getVerse(surah, verse)),
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم نسخ الآية')),
              );
            },
          ),
          FutureBuilder<bool>(
            future: BookmarkManager.isBookmarked(surah, verse),
            builder: (context, snapshot) {
              bool isBookmarked = snapshot.data ?? false;
              return ListTile(
                leading: Icon(
                  isBookmarked
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                ),
                title: Text(
                  isBookmarked
                      ? 'إزالة من المفضلة'
                      : 'إضافة إلى المفضلة',
                ),
                onTap: () async {
                  if (isBookmarked) {
                    await BookmarkManager.removeBookmark(
                      surah,
                      verse,
                    );
                  } else {
                    await BookmarkManager.addBookmark(surah, verse);
                  }
                  Navigator.pop(context);
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
            leading: const Icon(Icons.share),
            title: const Text('مشاركة الآية'),
            onTap: () {
      Share.share(
          '${getVerse(surah, verse)}\n\n'
          'سورة ${getSurahNameArabic(surah)} - آية $verse',
        );
                 
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
