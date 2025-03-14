
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/sura.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/widget/sura_list_view_item.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/surah/surah_cubit.dart';
import 'package:quran/quran.dart';

class SurahBlocBuilder extends StatelessWidget {
  const SurahBlocBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(   
          textAlign: TextAlign.end,             
        decoration: InputDecoration(
      hintText: '... البحث باسم السورة',
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color:orangeColor, width: 1),
        borderRadius: BorderRadius.circular(10),                  
      ),
        ),              
      ),
      SizedBox(height: 4,),
        Expanded(
                  child: BlocBuilder<SurahCubit, SurahState>(
         builder: (context, state) {
           if (state is SurahLoading) {
             return Center(child: CircularProgressIndicator());
           }
           if (state is SurahSuccess) {
             List<SurahModel> surahs = state.surahs;
             return ListView.separated(
               separatorBuilder:
                   (context, index) => Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
                     child: Divider(color: Colors.grey.withOpacity(.5)),
                   ),
               itemCount: state.surahs.length,
               itemBuilder: (context, index) {
                 int suraNumber = index + 1;
                 String suraName = state.surahs[index].name;
                 String suraNameEnglishTranslated =
                     state.surahs[index].englishNameTranslation;
                 int suraNumberInQuran = state.surahs[index].number;
                 // String suraNameTranslated = state.surahs[index].name.toString();
                 int ayahCount = getVerseCount(suraNumber);
                  
                 return SuraListViewItem(
                   suraNumber: suraNumber,
                   suraName: suraName,
                   suraNameEnglishTranslated: suraNameEnglishTranslated,
                   ayahCount: ayahCount,
                   suraNumberInQuran: suraNumberInQuran,
                   surahs: surahs,
                 );
               },
             );
           }
           if (state is SurahError) {
             return Center(child: Text(state.message));
           }
           return const SizedBox();
         },
                  ),
                ),
      ],
    );
  }
}
