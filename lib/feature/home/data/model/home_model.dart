import 'package:islami_app/core/router/app_routes.dart';

class HomeItemModel {
  final String name;
  final String image;
  final String route;

  HomeItemModel({required this.name, required this.image, required this.route});
}

final List<HomeItemModel> items = [
  HomeItemModel(
    name: "القرآن الكريم",
    image: "assets/images/quran.png",
    route: AppRoutes.navBarRoute,
  ),
  HomeItemModel(
    name: "الأحاديث",
    image: "assets/images/hadith.png",

    route: AppRoutes.hadithRouter,
  ),

  HomeItemModel(
    name: "السبحة",
    image: "assets/images/sebha.png",

    route: AppRoutes.sebhaPageRouter,
  ),
  HomeItemModel(name: "القبلة", image: "assets/images/Qibla.png", route: ''),

  HomeItemModel(
    name: "الأذكار",
    image: "assets/images/zikr.png",
    route: AppRoutes.azkarPageRouter,
  ),
  HomeItemModel(
    name: "أوقات الصلاة",
    image: "assets/images/prayer_time.png",

    route: "/prayer",
  ),
  HomeItemModel(
    name: "الراديو",
    image: "assets/images/radio.png",

    route: AppRoutes.radioPageRouter,
  ),
  HomeItemModel(
    name: "الصوتيات",
    image: "assets/images/audio.png",

    route: AppRoutes.quranAudioSurahListRouter,
  ),
  HomeItemModel(
    name: "التفسير",
    image: "assets/images/hadith.png",

    route: AppRoutes.tafsirByQuranPageRouter,
  ),
  HomeItemModel(
    name: "المكتبة الصوتية",
    image: "assets/images/hadith.png",

    route: AppRoutes.recitersPageRouter,
  ),
];
