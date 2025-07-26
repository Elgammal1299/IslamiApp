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
    final isSearching = _searchTextSurahController.text.isNotEmpty;
    final currentList = isSearching ? searchedForSurah : surahs;

    return ListView.builder(
      cacheExtent: 200,

      itemCount: currentList.length,
      itemBuilder: (context, index) {
        final surah = currentList[index];

        return SuraListViewItem(
          suraNumber: surah.number,
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
