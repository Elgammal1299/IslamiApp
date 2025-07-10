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
  List<SurahModel> searchedForSurah = [];
  dynamic searchedForAyats;
  bool _isSearching = false;
  final _searchTextSurahController = TextEditingController();
  final _searchTextAyatController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchTextSurahController.dispose();
    _searchTextAyatController.dispose();
    _searchFocusNode.dispose();
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
        _searchTextSurahController.clear(); // لتفريغ البحث في السور
        addSearchedForAyatsToSearchedList(searchedCharacter);
      },
    );
  }

  void addSearchedForAyatsToSearchedList(String searchQuery) {
    if (searchQuery.isNotEmpty && searchQuery.length > 3 ||
        searchQuery.toString().contains(" ")) {
      setState(() {
        searchedForAyats = searchWords(searchQuery);
      });
    } else {
      setState(() {
        searchedForAyats = null;
      });
    }
  }

  void addSearchedForSurahToSearchedList(String searchQuery) {
    final surahCubit = BlocProvider.of<SurahCubit>(context).surahs;

    if (searchQuery.isNotEmpty) {
      _searchTextAyatController.clear(); // لتفريغ البحث في الآيات
      setState(() {
        searchedForSurah =
            surahCubit.where((sura) {
              final suraName = sura.englishName.toLowerCase();
              final suraNameTranslated =
                  getSurahNameArabic(sura.number).toLowerCase();

              return suraName.contains(searchQuery.toLowerCase()) ||
                  suraNameTranslated.contains(searchQuery.toLowerCase());
            }).toList();
        searchedForAyats = null;
      });
    } else {
      setState(() {
        searchedForSurah = [];
      });
    }
  }

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        IconButton(
          onPressed: () {
            _clearSearch();
            Navigator.pop(context);
          },
          icon: Icon(Icons.clear, color: AppColors.secondary),
        ),
      ];
    } else {
      return [
        IconButton(
          onPressed: _startSearch,
          icon: Icon(Icons.search, color: AppColors.secondary),
        ),
      ];
    }
  }

  void _startSearch() {
    ModalRoute.of(
      context,
    )!.addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
    Future.delayed(Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(_searchFocusNode);
    });
  }

  void _stopSearching() {
    _clearSearch();
    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchTextAyatController.clear();
      _searchTextSurahController.clear();
      searchedForAyats = null;
      searchedForSurah = [];
    });
  }

  Widget _buildAppBarTitle() {
    return const Text('القرآن الكريم');
  }

  Widget _buildVerseSearchResults(List<SurahModel> surahs) {
    if (searchedForAyats == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (searchedForAyats["occurences"] == 0) {
      return Center(
        child: Text(
          'لا توجد نتائج بحث',
          style: Theme.of(
            context,
          ).textTheme.titleLarge!.copyWith(color: AppColors.black),
        ),
      );
    }

    return CustomAyatSearchResults(
      searchedForAyats: searchedForAyats,
      surahs: surahs,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _isSearching ? BackButton(color: AppColors.secondary) : null,
        title: _isSearching ? _buildSearchField() : _buildAppBarTitle(),
        actions: _buildAppBarActions(),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (!_isSearching)
              TextField(
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
                    return searchedForAyats != null
                        ? _buildVerseSearchResults(state.surahs)
                        : CustomSurahItemListView(
                          surahs: state.surahs,
                          searchTextSurahController: _searchTextSurahController,
                          searchedForSurah: searchedForSurah,
                        );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
