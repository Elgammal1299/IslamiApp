import 'package:islami_app/core/constant/app_image.dart';
import 'package:islami_app/core/router/app_routes.dart';

class HomeItemModel {
  final String name;
  final String image;
  final String route;

  HomeItemModel({required this.name, required this.image, required this.route});
}

final List<HomeItemModel> items =  [
  HomeItemModel(
    name: "القرآن الكريم",
    image: AppImage.quranImage,
    route: AppRoutes.navBarRoute,
  ),
  HomeItemModel(
    name: "الأحاديث",
    image: AppImage.hadithImage,

    route: AppRoutes.hadithRouter,
  ),

  HomeItemModel(
    name: "السبحة",
    image: AppImage.beadsImage,

    route: AppRoutes.sebhaPageRouter,
  ),
  HomeItemModel(
    name: "القبلة",
    image: AppImage.kaabaImage,
    route: AppRoutes.qiblahRouter,
  ),

  HomeItemModel(
    name: "ذكر يومي",
    image: AppImage.azkarImage,
    route: AppRoutes.azkarYawmiScreen,
  ),
  HomeItemModel(
    name: "حصن المؤمن",
    image: AppImage.prayingImage,
    route: AppRoutes.azkarPageRouter,
  ),
  HomeItemModel(
    name: "مواقيت الصلاة",
    image: AppImage.prayingImage,
    route: AppRoutes.prayertimesRouter,
  ),
  HomeItemModel(
    name: "ريكورد",
    image: AppImage.micImage,

    route: AppRoutes.audioRecordingRouter,
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

  // HomeItemModel(
  //   name: "التفسير",
  //   image: "assets/images/hadith.png",

  //   route: AppRoutes.tafsirByQuranPageRouter,
  // ),
];
