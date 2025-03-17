import 'package:flutter/material.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/widget/surah_blocbuilder.dart';

class QuranSurahPage extends StatelessWidget {
  const QuranSurahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: const EdgeInsets.all(8.0),
        child: SurahBlocBuilder(),
      
    );
  }
}
