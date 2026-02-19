import 'package:islami_app/core/constant/app_image.dart';
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
    image: AppImage.quranImage,
    route: AppRoutes.navBarRoute,
  ),
  HomeItemModel(
    name: "ختماتي",
    image: AppImage.khatimaImage,
    route: AppRoutes.khatmahListRouter,
  ),
  HomeItemModel(
    name: "الأحاديث",
    image: AppImage.hadithImage,

    route: AppRoutes.hadithRouter,
  ),

  

  HomeItemModel(
    name: "ذكر يومي",
    image: AppImage.azkarImage,
    route: AppRoutes.azkarYawmiScreen,
  ),
  HomeItemModel(
    name: "مواقيت الصلاة",
    image: AppImage.prayerTimesImages,
    route: AppRoutes.prayertimesRouter,
  ),
  HomeItemModel(
    name: "السبحة",
    image: AppImage.beadsImage,

    route: AppRoutes.sebhaPageRouter,
  ),
  HomeItemModel(
    name: "حصن المؤمن",
    image: AppImage.prayingImage,
    route: AppRoutes.azkarPageRouter,
  ),
  HomeItemModel(
    name: "القبلة",
    image: AppImage.kaabaImage,
    route: AppRoutes.qiblahRouter,
  ),

 
  HomeItemModel(
    name: "صوتيات",
    image: AppImage.audioImage,

    route: AppRoutes.recitersPageRouter,
  ),
  HomeItemModel(
    name: "الراديو",
    image: AppImage.radioImage,

    route: AppRoutes.radioPageRouter,
  ),
  HomeItemModel(
    name: "البث المباشر",
    image: AppImage.radioImage,

    route: AppRoutes.radioPage2Router,
  ),

  // HomeItemModel(
  //   name: "التفسير",
  //   image: "assets/images/hadith.png",

  //   route: AppRoutes.tafsirByQuranPageRouter,
  // ),
];
