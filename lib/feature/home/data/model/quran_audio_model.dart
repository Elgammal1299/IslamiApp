
import 'package:json_annotation/json_annotation.dart';

part 'quran_audio_model.g.dart';
@JsonSerializable()
class QuranAudioModel {
  List<Reciters>? reciters;

  QuranAudioModel({this.reciters});

  factory QuranAudioModel.fromJson(Map<String, dynamic> json) => 
      _$QuranAudioModelFromJson(json);
  Map<String, dynamic> toJson() => _$QuranAudioModelToJson(this);

  
}

@JsonSerializable()
class Reciters {
  int? id;
  String? name;
  String? letter;
  String? date;
  List<Moshaf>? moshaf;

  Reciters({this.id, this.name, this.letter, this.date, this.moshaf});

   factory Reciters.fromJson(Map<String, dynamic> json) => 
      _$RecitersFromJson(json);
  Map<String, dynamic> toJson() => _$RecitersToJson(this);

  
}

@JsonSerializable()
class Moshaf {
  int? id;
  String? name;
  String? server;
  int? surahTotal;
  int? moshafType;
  String? surahList;

  Moshaf(
      {this.id,
      this.name,
      this.server,
      this.surahTotal,
      this.moshafType,
      this.surahList});

   factory Moshaf.fromJson(Map<String, dynamic> json) => 
      _$MoshafFromJson(json);
  Map<String, dynamic> toJson() => _$MoshafToJson(this);

}