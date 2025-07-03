import 'package:json_annotation/json_annotation.dart';

part 'reciters_model.g.dart';

@JsonSerializable()
class RecitersModel {
  List<Reciters>? reciters;

  RecitersModel({this.reciters});

  factory RecitersModel.fromJson(Map<String, dynamic> json) =>
      _$RecitersModelFromJson(json);
  Map<String, dynamic> toJson() => _$RecitersModelToJson(this);
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
  @JsonKey(name: 'surah_total')
  int? surahTotal;
  @JsonKey(name: 'moshaf_type')
  int? moshafType;
  @JsonKey(name: 'surah_list')
  String? surahList;

  Moshaf({
    this.id,
    this.name,
    this.server,
    this.surahTotal,
    this.moshafType,
    this.surahList,
  });

  factory Moshaf.fromJson(Map<String, dynamic> json) => _$MoshafFromJson(json);
  Map<String, dynamic> toJson() => _$MoshafToJson(this);
}
