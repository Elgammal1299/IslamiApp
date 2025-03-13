import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/services/api/surah_db.dart';
import 'package:islami_app/feature/botton_nav_bar/data/repo/surah_repository.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/widget/surah_blocbuilder.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/surah/surah_cubit.dart';

class QuranSurahPage extends StatelessWidget {
  const QuranSurahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return 
        BlocProvider(
          create:
              (context) =>
                  SurahCubit(JsonRepository(SurahJsonServer()))..getSurahs(),
      
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SurahBlocBuilder(),
      ),
    );
  }
}
