import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/core/router/app_routes.dart';
import 'package:islami_app/core/widget/error_widget.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/sura.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/widget/custom_surah_item_list_view.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/surah/surah_cubit.dart';
import 'package:quran/quran.dart';

class QuranSurahScreen extends StatefulWidget {
  const QuranSurahScreen({super.key});

  @override
  State<QuranSurahScreen> createState() => _QuranSurahScreenState();
}

class _QuranSurahScreenState extends State<QuranSurahScreen> {
  final ValueNotifier<List<SurahModel>> searchedForSurah = ValueNotifier([]);
  final _searchTextSurahController = TextEditingController();

  @override
  void dispose() {
    _searchTextSurahController.dispose();
    searchedForSurah.dispose();
    super.dispose();
  }

  void addSearchedForSurahToSearchedList(String searchQuery) {
    final surahCubit = BlocProvider.of<SurahCubit>(context).surahs;
    if (searchQuery.isNotEmpty) {
      searchedForSurah.value =
          surahCubit.where((sura) {
            final suraName = sura.englishName.toLowerCase();
            final suraNameTranslated =
                getSurahNameArabic(sura.number).toLowerCase();
            return suraName.contains(searchQuery.toLowerCase()) ||
                suraNameTranslated.contains(searchQuery.toLowerCase());
          }).toList();
    } else {
      searchedForSurah.value = [];
    }
  }

  List<Widget> _buildAppBarActions() {
    return [
      IconButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.searchRouter);
        },
        icon: const Icon(Icons.search, color: AppColors.secondary),
      ),
    ];
  }

  Widget _buildAppBarTitle() => const Text('القرآن الكريم');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildAppBarTitle(),
        actions: _buildAppBarActions(),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
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
                    return customErrorWidget(
                      onPressed: () {
                        BlocProvider.of<SurahCubit>(context).surahs;
                      },
                    );
                  }
                  if (state is SurahSuccess) {
                    return ValueListenableBuilder<List<SurahModel>>(
                      valueListenable: searchedForSurah,
                      builder: (context, filteredSurahs, _) {
                        return CustomSurahItemListView(
                          surahs: state.surahs,
                          searchTextSurahController: _searchTextSurahController,
                          searchedForSurah: filteredSurahs,
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
