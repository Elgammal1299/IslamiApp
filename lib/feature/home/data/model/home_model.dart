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
    image: "assets/images/quran_10360836.png",
    route: AppRoutes.navBarRoute,
  ),
  HomeItemModel(
    name: "الأحاديث",
    image: "assets/images/images2.jpeg",

    route: AppRoutes.hadithRouter,
  ),

  HomeItemModel(
    name: "السبحة",
    image: "assets/images/6668725.jpg",

    route: AppRoutes.sebhaPageRouter,
  ),
  HomeItemModel(
    name: "القبلة",
    image: "assets/images/kaaba.png",
    route: AppRoutes.qiblahRouter,
  ),

  HomeItemModel(
    name: "ذكر يومي",
    image: "assets/images/download.png",
    route: AppRoutes.azkarYawmiScreen,
  ),
  HomeItemModel(
    name: "دعاء وذكر",
    image: "assets/images/praying.png",
    route: AppRoutes.azkarPageRouter,
  ),
  HomeItemModel(
    name: "تسجيل ريكورد",
    image:
        "assets/images/wired-flat-188-microphone-recording-hover-recording.png",

    route: AppRoutes.audioRecordingRouter,
  ),
  HomeItemModel(
    name: "المكتبة الصوتية",
    image: "assets/images/audio.png",

    route: AppRoutes.recitersPageRouter,
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
];
