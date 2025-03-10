
import 'package:json_annotation/json_annotation.dart';

part 'tafsir_by_ayah.g.dart';
@JsonSerializable()
class TafsirByAyah {
  int? code;
  String? status;
  Data? data;

  TafsirByAyah({this.code, this.status, this.data});

  
factory TafsirByAyah.fromJson(Map<String, dynamic> json) => 
      _$TafsirByAyahFromJson(json);
  Map<String, dynamic> toJson() => _$TafsirByAyahToJson(this);
}
@JsonSerializable()
class Data {
  int? number;
  String? text;
  Edition? edition;
  Surah? surah;
  int? numberInSurah;
  int? juz;
  int? manzil;
  int? page;
  int? ruku;
  int? hizbQuarter;
  bool? sajda;

  Data(
      {this.number,
      this.text,
      this.edition,
      this.surah,
      this.numberInSurah,
      this.juz,
      this.manzil,
      this.page,
      this.ruku,
      this.hizbQuarter,
      this.sajda});

  factory Data.fromJson(Map<String, dynamic> json) => 
      _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);
}
@JsonSerializable()
class Edition {
  String? identifier;
  String? language;
  String? name;
  String? englishName;
  String? format;
  String? type;
  String? direction;

  Edition(
      {this.identifier,
      this.language,
      this.name,
      this.englishName,
      this.format,
      this.type,
      this.direction});

 factory Edition.fromJson(Map<String, dynamic> json) => 
      _$EditionFromJson(json);
  Map<String, dynamic> toJson() => _$EditionToJson(this);
}
@JsonSerializable()
class Surah {
  int? number;
  String? name;
  String? englishName;
  String? englishNameTranslation;
  int? numberOfAyahs;
  String? revelationType;

  Surah(
      {this.number,
      this.name,
      this.englishName,
      this.englishNameTranslation,
      this.numberOfAyahs,
      this.revelationType});
factory Surah.fromJson(Map<String, dynamic> json) => 
      _$SurahFromJson(json);
  Map<String, dynamic> toJson() => _$SurahToJson(this);
}