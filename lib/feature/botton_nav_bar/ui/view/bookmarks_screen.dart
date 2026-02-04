import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/core/widget/error_widget.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/widget/bookmark_card.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/bookmarks/bookmark_cubit.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Load bookmarks when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookmarkCubit>().loadBookmarks();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh bookmarks when dependencies change (e.g., returning to this screen)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookmarkCubit>().loadBookmarks();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return Column(
      children: [
        Expanded(
          child: BlocBuilder<BookmarkCubit, BookmarkState>(
            builder: (context, state) {
              if (state is BookmarksLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is BookmarksError) {
                return customErrorWidget(
                  onPressed: () {
                    context.read<BookmarkCubit>().loadBookmarks();
                  },
                );
              }

              if (state is BookmarksLoaded) {
                if (state.bookmarks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.bookmark_outline_rounded,
                          color: AppColors.primary,
                          size: 120,
                        ),
                        Text(
                          'لا يوجد مرجعيات',
                          style: context.textTheme.titleLarge,
                        ),
                      ],
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<BookmarkCubit>().loadBookmarks();
                    },
                    child: ListView.builder(
                      itemCount: state.bookmarks.length,
                      itemBuilder: (context, index) {
                        List<String> parts = state.bookmarks[index].split(':');
                        int surah = int.parse(parts[0]);
                        int ayah = int.parse(parts[1]);

                        return BookmarkCard(surah: surah, ayah: ayah);
                      },
                    ),
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}
