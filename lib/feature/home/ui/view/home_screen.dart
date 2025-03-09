import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/bottom_navbar_page.dart';
import 'package:islami_app/feature/home/ui/view_model/surah/surah_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: quranPagesColor,
      body: Center(
        child: ElevatedButton(
            onPressed: () {
           context.read<SurahCubit>().getSurahs();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => const BottomNavbarPage()));
            },
            child: const Text("Go To Quran Page")),
      ),
    );
  }
}
