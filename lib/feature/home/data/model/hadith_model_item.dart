enum HadithType {
  bukhari,
  muslim,
  abuDaud,
  tirmidzi,
  ahmed,
  ibnuMajah,
  darimi,
  malik,
  nasai,
}

class HadithModelItem {
  final String image;
  final String name;
  final HadithType type;

  HadithModelItem({
    required this.name,
    required this.image,
    required this.type,
  });
}

final List<HadithModelItem> hadithItems = [
  HadithModelItem(
    name: "البخارى",
    image: "assets/images/quran.png",
    type: HadithType.bukhari,
  ),
  HadithModelItem(
    name: "مسلم",
    image: "assets/images/hadith.png",
    type: HadithType.muslim,
  ),
  HadithModelItem(
    name: "ابو داود",
    image: "assets/images/sebha.png",
    type: HadithType.abuDaud,
  ),
  HadithModelItem(
    name: "الترمذي",
    image: "assets/images/Qibla.png",
    type: HadithType.tirmidzi,
  ),
  HadithModelItem(
    name: "احمد",
    image: "assets/images/zikr.png",
    type: HadithType.ahmed,
  ),
  HadithModelItem(
    name: "ابن ماجا",
    image: "assets/images/prayer_time.png",
    type: HadithType.ibnuMajah,
  ),
  HadithModelItem(
    name: "داريمي",
    image: "assets/images/radio.png",
    type: HadithType.darimi,
  ),
  HadithModelItem(
    name: "مالكي",
    image: "assets/images/audio.png",
    type: HadithType.malik,
  ),
  HadithModelItem(
    name: "نسائي",
    image: "assets/images/hadith.png",
    type: HadithType.nasai,
  ),
];
