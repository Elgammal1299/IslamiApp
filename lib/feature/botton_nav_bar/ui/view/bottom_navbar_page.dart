import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/bookmarks_page.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/quran_surah_page.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/nav_bar_cubit.dart';

class BottomNavbarPage extends StatelessWidget {
  const BottomNavbarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavBarCubit, int>(
      builder: (context, state) {
        return Scaffold(
          appBar:
              state == 1
                  ? AppBar(title: const Text("المرجعيات"), centerTitle: true)
                  : null,

          body: IndexedStack(
            index: state,
            children: [const QuranSurahPage(), const BookmarksPage()],
          ),

          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state,
            onTap: (value) {
              BlocProvider.of<NavBarCubit>(context).changeTab(value);
            },
            items: [
              _buildBottomNavigationBarItem(
                label: 'الرئيسية',
                icon: Icons.menu_book_outlined,
              ),
              _buildBottomNavigationBarItem(
                label: 'المرجعيات',
                icon: Icons.bookmark_outlined,
              ),
            ],
          ),
        );
      },
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required String label,
    required IconData icon,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      activeIcon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(icon, color: AppColors.white),
      ),
      label: label,
    );
  }
}
