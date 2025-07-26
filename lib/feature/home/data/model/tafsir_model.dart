import 'package:json_annotation/json_annotation.dart';
part 'tafsir_model.g.dart';

@JsonSerializable()
class TafsirModel {
  int? code;
  String? status;
  List<Data>? data;
  TafsirModel({this.code, this.status, this.data});
  factory TafsirModel.fromJson(Map<String, dynamic> json) =>
      _$TafsirModelFromJson(json);
  Map<String, dynamic> toJson() => _$TafsirModelToJson(this);
}

@JsonSerializable()
class Data {
  String? identifier;
  String? language;
  String? name;
  String? englishName;
  String? format;
  String? type;
  String? direction;

  Data({
    this.identifier,
    this.language,
    this.name,
    this.englishName,
    this.format,
    this.type,
    this.direction,
  });
  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);
}
