import 'package:equatable/equatable.dart';

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

class HadithModelItem extends Equatable {
  final String name;
  final String englishName;
  final HadithType type;

  const HadithModelItem({
    required this.name,
    required this.englishName,
    required this.type,
  });
  @override
  List<Object?> get props => [name, englishName, type];
}

const List<HadithModelItem> hadithItems = [
  HadithModelItem(
    name: "البخارى",
    type: HadithType.bukhari,
    englishName: "bukhari",
  ),
  HadithModelItem(name: "مسلم", type: HadithType.muslim, englishName: "muslim"),
  HadithModelItem(
    name: "ابو داود",
    type: HadithType.abuDaud,
    englishName: "abu-daud",
  ),
  HadithModelItem(
    name: "الترمذي",
    type: HadithType.tirmidzi,
    englishName: "tirmidzi",
  ),
  HadithModelItem(name: "احمد", type: HadithType.ahmed, englishName: "ahmad"),
  HadithModelItem(
    name: "ابن ماجا",
    type: HadithType.ibnuMajah,
    englishName: "ibnu-majah",
  ),
  HadithModelItem(
    name: "داريمي",
    type: HadithType.darimi,
    englishName: "darimi",
  ),
  HadithModelItem(name: "مالكي", type: HadithType.malik, englishName: "malik"),
  HadithModelItem(name: "نسائي", type: HadithType.nasai, englishName: "nasai"),
];
