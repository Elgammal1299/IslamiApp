// lib/feature/bookmarks/ui/view/bookmarks_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/widget/bookmark_card.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/bookmarks/bookmark_cubit.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
child: Text("المفضلة", style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: blueColor,
                          fontSize: 20,
                        ), ),
        ),
        Expanded(
          child: BlocProvider(
            create: (context) => BookmarkCubit()..loadBookmarks(),
            child:  BlocBuilder<BookmarkCubit, BookmarkState>(
                builder: (context, state) {
                  if (state is BookmarksLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
          
                  if (state is BookmarksError) {
                    return Center(child: Text(state.message));
                  }
          
                  if (state is BookmarksLoaded) {
                    if (state.bookmarks.isEmpty) {
                      return Center(
                        child: Column(
                          children: [
                            Icon(Icons.bookmark_remove,color: Colors.red,size: 150,),
                            const Text(
                              'لا توجد آيات محفوظة',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      );
                    }
          
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: state.bookmarks.length,
                        itemBuilder: (context, index) {
                          List<String> parts = state.bookmarks[index].split(':');
                          int surah = int.parse(parts[0]);
                          int ayah = int.parse(parts[1]);
          
                          return BookmarkCard(
                            surah: surah,
                            ayah: ayah,
                          );
                        },
                      ),
                    );
                  }
          
                  return const SizedBox();
                },
              ),
          ),
        ),
      ],
    );
  }
}
