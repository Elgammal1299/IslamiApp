// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reciter_edition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReciterEditionResponse _$ReciterEditionResponseFromJson(
        Map<String, dynamic> json) =>
    ReciterEditionResponse(
      code: (json['code'] as num).toInt(),
      status: json['status'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => ReciterEdition.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReciterEditionResponseToJson(
        ReciterEditionResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'status': instance.status,
      'data': instance.data,
    };

ReciterEdition _$ReciterEditionFromJson(Map<String, dynamic> json) =>
    ReciterEdition(
      identifier: json['identifier'] as String,
      language: json['language'] as String,
      name: json['name'] as String,
      englishName: json['englishName'] as String,
      format: json['format'] as String,
      type: json['type'] as String,
      direction: json['direction'] as String?,
    );

Map<String, dynamic> _$ReciterEditionToJson(ReciterEdition instance) =>
    <String, dynamic>{
      'identifier': instance.identifier,
      'language': instance.language,
      'name': instance.name,
      'englishName': instance.englishName,
      'format': instance.format,
      'type': instance.type,
      'direction': instance.direction,
    };
