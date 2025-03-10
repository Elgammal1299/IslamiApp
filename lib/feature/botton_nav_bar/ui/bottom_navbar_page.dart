import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/core/services/api/api_service.dart';
import 'package:islami_app/feature/home/data/repo/tafsir_repo.dart';
import 'package:islami_app/feature/home/ui/view/bookmarks_page.dart';
import 'package:islami_app/feature/home/ui/view/quran_surah_screen.dart';
import 'package:islami_app/feature/home/ui/view_model/tafsir_cubit/tafsir_cubit.dart';

class BottomNavbarPage extends StatefulWidget {
  const BottomNavbarPage({super.key});

  @override
  State<BottomNavbarPage> createState() => _BottomNavbarPageState();
}

class _BottomNavbarPageState extends State<BottomNavbarPage> {
  int selectedIndex = 0;
  void onItemTapped(int newIndex) {
    setState(() {
      selectedIndex = newIndex;
    });
  }

  List<Widget> bodyOptions = <Widget>[
    QuranSurahScreen(),
    BookmarksScreen(),
    Center(child: Text('Person')),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: quranPagesColor,
        appBar: AppBar(
          title: Text('Quran App'),
          backgroundColor: Colors.grey[100],
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: bodyOptions.elementAt(selectedIndex),
        drawer: Drawer(child: Center(child: Text('Ahmed'))),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: onItemTapped,
    
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_outlined),
              label: 'Bookmark',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Person',
            ),
          ],
        ),
      ),
    );
  }
}
