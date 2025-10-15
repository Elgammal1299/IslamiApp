// import 'package:easy_container/easy_container.dart';
// import 'package:flutter/material.dart';
// import 'package:islami_app/core/extension/theme_text.dart';
// import 'package:islami_app/core/router/app_routes.dart';
// import 'package:islami_app/feature/botton_nav_bar/data/model/sura.dart';
// import 'package:quran/quran.dart';

// class CustomAyatSearchResults extends StatelessWidget {
//   const CustomAyatSearchResults({
//     super.key,
//     required this.searchedForAyats,
//     required this.surahs,
//   });

//   final dynamic searchedForAyats;
//   final List<SurahModel> surahs;

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: searchedForAyats["occurences"],
//       itemBuilder: (context, index) {
//         final result = searchedForAyats["result"][index];
//         return Padding(
//           padding: const EdgeInsets.all(6.0),
//           child: EasyContainer(
//             color: Theme.of(context).cardColor,
//             borderRadius: 14,
//             onTap: () async {
//               final surah = result["surah"];
//               final verse = result["verse"];
//               final pageNumber = getPageNumber(surah, verse);
//               Navigator.pushReplacementNamed(
//                 context,
//                 AppRoutes.quranViewRouter,
//                 arguments: {"jsonData": surahs, "pageNumber": pageNumber},
//               );
//             },

//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "سورة ${getSurahNameArabic(result["surah"])} - الآية ${result["verse"]}",
//                   style: context.textTheme.titleLarge,
//                 ),
//                 const SizedBox(height: 4),

//                 Text(
//                   getVerse(
//                     result["surah"],
//                     result["verse"],
//                     verseEndSymbol: true,
//                   ),
//                   style: context.textTheme.bodyLarge,
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/core/router/app_routes.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/sura.dart';
import 'package:quran/quran.dart';

// Import the highlighter widget
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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: searchedForAyats["occurences"],
      itemBuilder: (context, index) {
        final result = searchedForAyats["result"][index];
        final verseText = getVerse(result["surah"], result["verse"], verseEndSymbol: true);

        return Padding(
          padding: const EdgeInsets.all(6.0),
          child: EasyContainer(
            color: Theme.of(context).cardColor,
            borderRadius: 14,
            onTap: () async {
              final surah = result["surah"];
              final verse = result["verse"];
              final pageNumber = getPageNumber(surah, verse);
              Navigator.pushNamed(
                context,
                AppRoutes.quranViewRouter,
                arguments: {"jsonData": surahs, "pageNumber": pageNumber},
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Surah name and verse number (without highlighting)
                Text(
                  "سورة ${getSurahNameArabic(result["surah"])} - الآية ${result["verse"]}",
                  style: context.textTheme.titleLarge,
                ),
                const SizedBox(height: 4),

                // Verse text with highlighted search query
                HighlightedText(
                  text: verseText,
                  query: searchQuery,
                  baseStyle: context.textTheme.bodyLarge ?? const TextStyle(),
                  highlightStyle: (context.textTheme.bodyLarge ?? const TextStyle()).copyWith(
                    backgroundColor: Colors.amber.withValues(alpha: 0.5),
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                  caseSensitive: false,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}