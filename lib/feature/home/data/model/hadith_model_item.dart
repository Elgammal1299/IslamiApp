import 'package:equatable/equatable.dart';

class HadithModelItem extends Equatable {
  final String name;
  final String englishName;

  const HadithModelItem({required this.name, required this.englishName});
  @override
  List<Object?> get props => [name, englishName];
}

const List<HadithModelItem> hadithItems = [
  HadithModelItem(name: "صحيح البخاري", englishName: "bukhari"),
  HadithModelItem(name: "صحيح مسلم", englishName: "muslim"),
  HadithModelItem(name: "سنن أبي داود", englishName: "abu-daud"),
  HadithModelItem(name: "سنن الترمذي", englishName: "tirmidzi"),
  HadithModelItem(name: "مسند احمد", englishName: "ahmad"),
  HadithModelItem(name: "سنن ابن ماجه", englishName: "ibnu-majah"),
  HadithModelItem(name: "سنن الدارمي", englishName: "darimi"),
  HadithModelItem(name: "موطأ مالك", englishName: "malik"),
  HadithModelItem(name: "سنن النسائي", englishName: "nasai"),
];
