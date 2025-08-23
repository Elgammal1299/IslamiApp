import 'package:equatable/equatable.dart';

class HadithModelItem extends Equatable {
  final String name;
  final String englishName;

  const HadithModelItem({required this.name, required this.englishName});
  @override
  List<Object?> get props => [name, englishName];
}

const List<HadithModelItem> hadithItems = [
  HadithModelItem(name: "البخارى", englishName: "bukhari"),
  HadithModelItem(name: "مسلم", englishName: "muslim"),
  HadithModelItem(name: "أبي داود", englishName: "abu-daud"),
  HadithModelItem(name: "الترمذي", englishName: "tirmidzi"),
  HadithModelItem(name: "احمد", englishName: "ahmad"),
  HadithModelItem(name: "ابن ماجه", englishName: "ibnu-majah"),
  HadithModelItem(name: "الدارمي", englishName: "darimi"),
  HadithModelItem(name: "مالك", englishName: "malik"),
  HadithModelItem(name: "النسائي", englishName: "nasai"),
];
