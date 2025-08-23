import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/core/router/app_routes.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/sura.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/bookmarks/bookmark_cubit.dart';
import 'package:quran/quran.dart' as quran;

class BookmarkCard extends StatelessWidget {
  final int surah;
  final int ayah;
  final List<SurahModel> surahs;

  const BookmarkCard({
    super.key,
    required this.surah,
    required this.ayah,
    required this.surahs,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final pageNumber = quran.getPageNumber(surah, ayah);
        Navigator.pushNamed(
          context,
          AppRoutes.quranViewRouter,
          arguments: {"jsonData": surahs, "pageNumber": pageNumber},
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Text(
                    
                    'سورة ${quran.getSurahNameArabic(surah)} ($ayah)',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge!.copyWith(color: AppColors.white),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.bookmark_remove,
                      color: AppColors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      context.read<BookmarkCubit>().removeBookmark(surah, ayah);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تم إزالة الآية من المفضلة'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).secondaryHeaderColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Text(
                
                quran.getVerse(surah, ayah),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge!.copyWith(color: AppColors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
