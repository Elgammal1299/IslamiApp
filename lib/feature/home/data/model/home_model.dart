import 'package:islami_app/feature/botton_nav_bar/ui/view/bottom_navbar_page.dart';
import 'package:islami_app/feature/home/ui/view/audio_player_page.dart';
import 'package:islami_app/feature/home/ui/view/azkar_page.dart';
import 'package:islami_app/feature/home/ui/view/radio_page.dart';
import 'package:islami_app/feature/home/ui/view/sebha_page.dart';
import 'package:islami_app/feature/home/ui/view/tafsir_page.dart';

class HomeItemModel {
  final String name;
  final String image;
  final String route;

  HomeItemModel({
    required this.name,
    required this.image,
   required this.route,
  });
}


  final List<HomeItemModel> items = [
    HomeItemModel(
      name: "القرآن الكريم",
      image: "assets/images/quran.png",
      route: BottomNavbarPage.routeName,
    ),
      HomeItemModel(
      name: "الأحاديث",
            image: "assets/images/hadith.png",

      route: "/hadith",
    ),
   
    HomeItemModel(
      name: "السبحة",
            image: "assets/images/sebha.png",

      route: "",
    ),
    HomeItemModel(
      name: "القبلة",
            image: "assets/images/Qibla.png",

      route: QuranSurahList.routeName,
    ),
  
     HomeItemModel(
      name: "الأذكار",
      image: "assets/images/zikr.png",
      route: AzkarPage.routeName,

    ),
    HomeItemModel(
      name: "أوقات الصلاة",
           image: "assets/images/prayer_time.png",

      route: "/prayer",
    ),
    HomeItemModel(
      name: "الراديو",
          image: "assets/images/radio.png",

      route: RadioPage.routeName,
    ),
    HomeItemModel(
      name: "الصوتيات",
           image: "assets/images/audio.png",

            route: SebhaPage.routeName,


    ),
    HomeItemModel(
      name: "التفسير",
           image: "assets/images/audio.png",

          route: TafsirPage.routeName,

    ),
  ];
