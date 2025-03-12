import 'package:islami_app/feature/botton_nav_bar/ui/view/bottom_navbar_page.dart';
import 'package:islami_app/feature/home/ui/view/azkar_page.dart';
import 'package:islami_app/feature/home/ui/view/sebha_page.dart';

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
      name: "الأذكار",
      image: "assets/images/beads.png",
      route: AzkarPage.routeName,

    ),
    HomeItemModel(
      name: "السبحة",
            image: "assets/images/beads.png",

      route: SebhaPage.routeName,
    ),
    HomeItemModel(
      name: "القبلة",
            image: "assets/images/beads.png",

      route: "/qibla",
    ),
    HomeItemModel(
      name: "الأحاديث",
            image: "assets/images/quran.png",

      route: "/hadith",
    ),
    HomeItemModel(
      name: "أوقات الصلاة",
           image: "assets/images/beads.png",

      route: "/prayer",
    ),
    HomeItemModel(
      name: "الراديو",
          image: "assets/images/quran.png",

      route: "/radio",
    ),
    HomeItemModel(
      name: "المفضلة",
           image: "assets/images/beads.png",

      route: "/bookmarks",
    ),
  ];
