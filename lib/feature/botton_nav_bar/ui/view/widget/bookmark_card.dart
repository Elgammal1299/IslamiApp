
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/bookmarks/bookmark_cubit.dart';
import 'package:quran/quran.dart' as quran;

class BookmarkCard extends StatelessWidget {
  final int surah;
  final int ayah;

  const BookmarkCard({
    super.key,
    required this.surah,
    required this.ayah,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.bookmark_remove,
                      color: Colors.red,
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
                  const Spacer(),
                  Text(
                    'سورة ${quran.getSurahNameArabic(surah)}',
                   style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color:AppColors.accent,// blueColor,
                      fontSize: 16,
                    
                  ),
                  ),
                ],
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  quran.getVerse(surah, ayah),
                  textAlign: TextAlign.right,
                 style: const TextStyle(
                  fontFamily: "arsura",
                  fontSize: 22,
                  color: Colors.black,
                ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'آية $ayah',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      
    );
  }
}
