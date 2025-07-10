import 'package:flutter/material.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/sura.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/widget/sura_list_view_item.dart';
import 'package:quran/quran.dart';

class CustomSurahItemListView extends StatelessWidget {
  const CustomSurahItemListView({
    super.key,
    required TextEditingController searchTextSurahController,
    required this.searchedForSurah,
    required this.surahs,
  }) : _searchTextSurahController = searchTextSurahController;

  final TextEditingController _searchTextSurahController;
  final List<SurahModel> searchedForSurah;
  final List<SurahModel> surahs;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount:
          _searchTextSurahController.text.isEmpty
              ? surahs.length
              : searchedForSurah.length,
      itemBuilder: (context, index) {
        final surah =
            _searchTextSurahController.text.isEmpty
                ? surahs[index]
                : searchedForSurah[index];

        return SuraListViewItem(
          suraNumber: index + 1,
          suraName: surah.name,
          suraNameEnglishTranslated: surah.englishNameTranslation,
          ayahCount: getVerseCount(surah.number),
          suraNumberInQuran: surah.number,
          surahs: surahs,
        );
      },
    );
  }
}
