import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/sura.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/widget/custom_ayat_search_results.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/widget/custom_surah_item_list_view.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/surah/surah_cubit.dart';
import 'package:quran/quran.dart';

class QuranSurahPage extends StatefulWidget {
  const QuranSurahPage({super.key});

  @override
  State<QuranSurahPage> createState() => _QuranSurahPageState();
}

class _QuranSurahPageState extends State<QuranSurahPage> {
  final ValueNotifier<List<SurahModel>> searchedForSurah = ValueNotifier([]);
  final ValueNotifier<dynamic> searchedForAyats = ValueNotifier(null);
  final ValueNotifier<bool> isSearching = ValueNotifier(false);

  final _searchTextSurahController = TextEditingController();
  final _searchTextAyatController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchTextSurahController.dispose();
    _searchTextAyatController.dispose();
    _searchFocusNode.dispose();
    searchedForSurah.dispose();
    searchedForAyats.dispose();
    isSearching.dispose();
    super.dispose();
  }

  Widget _buildSearchField() {
    return TextField(
      focusNode: _searchFocusNode,
      controller: _searchTextAyatController,
      cursorColor: Theme.of(context).primaryColorDark,
      decoration: InputDecoration(
        hintText: 'ابحث في الآيات...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Theme.of(context).cardColor, fontSize: 18),
      ),
      style: TextStyle(color: AppColors.black, fontSize: 18),
      onChanged: (searchedCharacter) {
        _searchTextSurahController.clear();
        addSearchedForAyatsToSearchedList(searchedCharacter);
      },
    );
  }

  void addSearchedForAyatsToSearchedList(String searchQuery) {
    if (searchQuery.isNotEmpty && searchQuery.length > 3 ||
        searchQuery.contains(" ")) {
      searchedForAyats.value = searchWords(searchQuery);
    } else {
      searchedForAyats.value = null;
    }
  }

  void addSearchedForSurahToSearchedList(String searchQuery) {
    final surahCubit = BlocProvider.of<SurahCubit>(context).surahs;
    if (searchQuery.isNotEmpty) {
      _searchTextAyatController.clear();
      searchedForSurah.value =
          surahCubit.where((sura) {
            final suraName = sura.englishName.toLowerCase();
            final suraNameTranslated =
                getSurahNameArabic(sura.number).toLowerCase();
            return suraName.contains(searchQuery.toLowerCase()) ||
                suraNameTranslated.contains(searchQuery.toLowerCase());
          }).toList();
      searchedForAyats.value = null;
    } else {
      searchedForSurah.value = [];
    }
  }

  List<Widget> _buildAppBarActions() {
    return [
      ValueListenableBuilder<bool>(
        valueListenable: isSearching,
        builder: (context, value, _) {
          return IconButton(
            onPressed: value ? _clearSearch : _startSearch,
            icon: Icon(
              value ? Icons.clear : Icons.search,
              color: AppColors.secondary,
            ),
          );
        },
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(
      context,
    )!.addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    isSearching.value = true;
    Future.delayed(Duration(milliseconds: 100), () {
      if (mounted) {
        FocusScope.of(context).requestFocus(_searchFocusNode);
      }
    });
  }

  void _stopSearching() {
    _clearSearch();
    isSearching.value = false;
  }

  void _clearSearch() {
    _searchTextAyatController.clear();
    _searchTextSurahController.clear();
    searchedForAyats.value = null;
    searchedForSurah.value = [];
  }

  Widget _buildAppBarTitle() => const Text('القرآن الكريم');

  Widget _buildVerseSearchResults(List<SurahModel> surahs) {
    final ayats = searchedForAyats.value;
    if (ayats == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (ayats["occurences"] == 0) {
      return Center(
        child: Text(
          'لا توجد نتائج بحث',
          style: Theme.of(
            context,
          ).textTheme.titleLarge!.copyWith(color: AppColors.black),
        ),
      );
    }
    return CustomAyatSearchResults(searchedForAyats: ayats, surahs: surahs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ValueListenableBuilder<bool>(
          valueListenable: isSearching,
          builder:
              (context, value, _) =>
                  value
                      ? BackButton(color: AppColors.secondary)
                      : SizedBox.shrink(),
        ),
        title: ValueListenableBuilder<bool>(
          valueListenable: isSearching,
          builder:
              (context, value, _) =>
                  value ? _buildSearchField() : _buildAppBarTitle(),
        ),
        actions: _buildAppBarActions(),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: isSearching,
              builder: (context, value, _) {
                return !value
                    ? TextField(
                      controller: _searchTextSurahController,
                      cursorColor: AppColors.black,
                      style: const TextStyle(color: AppColors.black),
                      decoration: const InputDecoration(
                        hintText: 'ابحث عن سورة...',
                        border: InputBorder.none,
                      ),
                      onChanged: (searchedSurah) {
                        addSearchedForSurahToSearchedList(searchedSurah);
                      },
                    )
                    : SizedBox.shrink();
              },
            ),
            Expanded(
              child: BlocBuilder<SurahCubit, SurahState>(
                builder: (context, state) {
                  if (state is SurahLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is SurahError) {
                    return Center(child: Text(state.message));
                  }
                  if (state is SurahSuccess) {
                    return ValueListenableBuilder<dynamic>(
                      valueListenable: searchedForAyats,
                      builder: (context, value, _) {
                        return value != null
                            ? _buildVerseSearchResults(state.surahs)
                            : ValueListenableBuilder<List<SurahModel>>(
                              valueListenable: searchedForSurah,
                              builder: (context, filteredSurahs, _) {
                                return CustomSurahItemListView(
                                  surahs: state.surahs,
                                  searchTextSurahController:
                                      _searchTextSurahController,
                                  searchedForSurah: filteredSurahs,
                                );
                              },
                            );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
