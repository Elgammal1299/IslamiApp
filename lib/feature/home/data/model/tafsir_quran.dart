
import 'package:islami_app/feature/botton_nav_bar/data/model/tafsir_by_ayah.dart' show Data;
import 'package:json_annotation/json_annotation.dart';
part 'tafsir_quran.g.dart';
@JsonSerializable()
class TafsirQuran {
  int? code;
  String? status;
  Data? data;

  TafsirQuran({this.code, this.status, this.data});

 factory TafsirQuran.fromJson(Map<String, dynamic> json) => 
      _$TafsirQuranFromJson(json);
  Map<String, dynamic> toJson() => _$TafsirQuranToJson(this);
}
@JsonSerializable()
class Ayahs {
  int? number;
  String? text;
  int? numberInSurah;
  int? juz;
  int? manzil;
  int? page;
  int? ruku;
  int? hizbQuarter;
  bool? sajda;

  Ayahs(
      {this.number,
      this.text,
      this.numberInSurah,
      this.juz,
      this.manzil,
      this.page,
      this.ruku,
      this.hizbQuarter,
      this.sajda});

 factory Ayahs.fromJson(Map<String, dynamic> json) => 
      _$AyahsFromJson(json);
  Map<String, dynamic> toJson() => _$AyahsToJson(this);
}
