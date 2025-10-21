import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/core/router/app_routes.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/sura.dart';
import 'package:quran/quran.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/widget/highlighted_text.dart';

class CustomAyatSearchResults extends StatelessWidget {
  const CustomAyatSearchResults({
    super.key,
    required this.searchedForAyats,
    required this.surahs,
    required this.searchQuery,
  });

  final dynamic searchedForAyats;
  final List<SurahModel> surahs;
  final String searchQuery;
  String _normalizeArabic(String text) {
    // إزالة التشكيل والرموز الخاصة
    return text
        .replaceAll(RegExp(r'[ًٌٍَُِّْـۚۛۗۙۚ۩ۖۜ۞]'), '')
        .replaceAll(RegExp(r'[^\u0600-\u06FF\s]'), '');
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: searchedForAyats["occurences"],
      itemBuilder: (context, index) {
        final result = searchedForAyats["result"][index];
        final verseText = getVerse(
          result["surah"],
          result["verse"],
          verseEndSymbol: true,
        );

        return Padding(
          padding: const EdgeInsets.all(6.0),
          child: EasyContainer(
            color: Theme.of(context).cardColor,
            borderRadius: 14,
            onTap: () async {
              final surah = result["surah"];
              final verse = result["verse"];
              final pageNumber = getPageNumber(surah, verse);
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.quranViewRouter,
                arguments: {"jsonData": surahs, "pageNumber": pageNumber},
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "سورة ${getSurahNameArabic(result["surah"])} - الآية ${result["verse"]}",
                  style: context.textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                HighlightedText(
                  text: _normalizeArabic(verseText),
                  query: searchQuery,
                  baseStyle: context.textTheme.bodyLarge ?? const TextStyle(),
                  highlightStyle: (context.textTheme.bodyLarge ??
                          const TextStyle())
                      .copyWith(
                        color: Colors.green,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                  caseSensitive: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
