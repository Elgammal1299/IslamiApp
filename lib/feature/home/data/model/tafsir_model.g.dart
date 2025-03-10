// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tafsir_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TafsirModel _$TafsirModelFromJson(Map<String, dynamic> json) => TafsirModel(
  code: (json['code'] as num?)?.toInt(),
  status: json['status'] as String?,
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$TafsirModelToJson(TafsirModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'status': instance.status,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  identifier: json['identifier'] as String?,
  language: json['language'] as String?,
  name: json['name'] as String?,
  englishName: json['englishName'] as String?,
  format: json['format'] as String?,
  type: json['type'] as String?,
  direction: json['direction'] as String?,
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'identifier': instance.identifier,
  'language': instance.language,
  'name': instance.name,
  'englishName': instance.englishName,
  'format': instance.format,
  'type': instance.type,
  'direction': instance.direction,
};
