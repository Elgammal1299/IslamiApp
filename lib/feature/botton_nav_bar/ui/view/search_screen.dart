import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/widget/custom_ayat_search_results.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/surah/surah_cubit.dart';
import 'package:quran/quran.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ValueNotifier<dynamic> searchedForAyats = ValueNotifier(null);
  final _searchTextAyatController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_searchFocusNode);
    });
  }

  @override
  void dispose() {
    _searchTextAyatController.dispose();
    _searchFocusNode.dispose();
    searchedForAyats.dispose();
    super.dispose();
  }

  void addSearchedForAyatsToSearchedList(String searchQuery) {
    if (searchQuery.isNotEmpty &&
        (searchQuery.length > 1 || searchQuery.contains(" "))) {
      searchedForAyats.value = searchWords(searchQuery);
    } else {
      searchedForAyats.value = null;
    }
  }

  Widget _buildVerseSearchResults() {
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
    return CustomAyatSearchResults(
      searchedForAyats: ayats,
      searchQuery: _searchTextAyatController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: AppColors.secondary),
        title: const Text('البحث عن الايات'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              focusNode: _searchFocusNode,
              controller: _searchTextAyatController,
              cursorColor: Theme.of(context).primaryColorDark,
              decoration: InputDecoration(
                hintText: 'ابحث في الآيات...',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Theme.of(context).cardColor,
                  fontSize: 18,
                ),
              ),
              onChanged: (searchedCharacter) {
                addSearchedForAyatsToSearchedList(searchedCharacter);
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<SurahCubit, SurahState>(
                builder: (context, state) {
                  if (state is SurahSuccess) {
                    return ValueListenableBuilder<dynamic>(
                      valueListenable: searchedForAyats,
                      builder: (context, value, _) {
                        if (value == null) {
                          return const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 50,
                                color: AppColors.primary,
                              ),
                              SizedBox(height: 10),
                              const Text(
                                'ابدأ البحث عن الآيات',
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          );
                        }
                        return _buildVerseSearchResults();
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
