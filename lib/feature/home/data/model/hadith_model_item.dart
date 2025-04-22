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
  final String name;
  final HadithType type;

  HadithModelItem({required this.name, required this.type});
}

final List<HadithModelItem> hadithItems = [
  HadithModelItem(name: "البخارى", type: HadithType.bukhari),
  HadithModelItem(name: "مسلم", type: HadithType.muslim),
  HadithModelItem(name: "ابو داود", type: HadithType.abuDaud),
  HadithModelItem(name: "الترمذي", type: HadithType.tirmidzi),
  HadithModelItem(name: "احمد", type: HadithType.ahmed),
  HadithModelItem(name: "ابن ماجا", type: HadithType.ibnuMajah),
  HadithModelItem(name: "داريمي", type: HadithType.darimi),
  HadithModelItem(name: "مالكي", type: HadithType.malik),
  HadithModelItem(name: "نسائي", type: HadithType.nasai),
];
