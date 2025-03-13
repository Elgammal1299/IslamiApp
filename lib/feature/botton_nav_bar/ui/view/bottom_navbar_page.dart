import 'package:flutter/material.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/ayat_duea_page.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/bookmarks_page.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/quran_surah_page.dart';

class BottomNavbarPage extends StatefulWidget {
  static String routeName = '/bootom';

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
    QuranSurahPage(),
    BookmarksPage(),
    AyatDueaPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: quranPagesColor,
        appBar: AppBar(
        backgroundColor: quranPagesColor,
          title: Text('القرءان الكريم'),
          centerTitle: true,
          
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        body: bodyOptions.elementAt(selectedIndex),
       
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: onItemTapped,
    
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_outlined),
              label: 'المفضلة',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'الدعاء',
            ),
          ],
        ),
      ),
    );
  }
}
