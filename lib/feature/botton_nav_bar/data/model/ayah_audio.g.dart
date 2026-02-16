// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ayah_audio.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AyahAudioResponse _$AyahAudioResponseFromJson(Map<String, dynamic> json) =>
    AyahAudioResponse(
      code: (json['code'] as num).toInt(),
      status: json['status'] as String,
      data: AyahAudioData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AyahAudioResponseToJson(AyahAudioResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'status': instance.status,
      'data': instance.data,
    };

AyahAudioData _$AyahAudioDataFromJson(Map<String, dynamic> json) =>
    AyahAudioData(
      number: (json['number'] as num).toInt(),
      audio: json['audio'] as String,
      audioSecondary: (json['audioSecondary'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      text: json['text'] as String,
      edition: EditionInfo.fromJson(json['edition'] as Map<String, dynamic>),
      surah: SurahInfo.fromJson(json['surah'] as Map<String, dynamic>),
      numberInSurah: (json['numberInSurah'] as num).toInt(),
      juz: (json['juz'] as num).toInt(),
      manzil: (json['manzil'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      ruku: (json['ruku'] as num).toInt(),
      hizbQuarter: (json['hizbQuarter'] as num).toInt(),
      sajda: json['sajda'] as bool,
    );

Map<String, dynamic> _$AyahAudioDataToJson(AyahAudioData instance) =>
    <String, dynamic>{
      'number': instance.number,
      'audio': instance.audio,
      'audioSecondary': instance.audioSecondary,
      'text': instance.text,
      'edition': instance.edition,
      'surah': instance.surah,
      'numberInSurah': instance.numberInSurah,
      'juz': instance.juz,
      'manzil': instance.manzil,
      'page': instance.page,
      'ruku': instance.ruku,
      'hizbQuarter': instance.hizbQuarter,
      'sajda': instance.sajda,
    };

EditionInfo _$EditionInfoFromJson(Map<String, dynamic> json) => EditionInfo(
      identifier: json['identifier'] as String,
      language: json['language'] as String,
      name: json['name'] as String,
      englishName: json['englishName'] as String,
      format: json['format'] as String,
      type: json['type'] as String,
      direction: json['direction'] as String?,
    );

Map<String, dynamic> _$EditionInfoToJson(EditionInfo instance) =>
    <String, dynamic>{
      'identifier': instance.identifier,
      'language': instance.language,
      'name': instance.name,
      'englishName': instance.englishName,
      'format': instance.format,
      'type': instance.type,
      'direction': instance.direction,
    };

SurahInfo _$SurahInfoFromJson(Map<String, dynamic> json) => SurahInfo(
      number: (json['number'] as num).toInt(),
      name: json['name'] as String,
      englishName: json['englishName'] as String,
      englishNameTranslation: json['englishNameTranslation'] as String,
      numberOfAyahs: (json['numberOfAyahs'] as num).toInt(),
      revelationType: json['revelationType'] as String,
    );

Map<String, dynamic> _$SurahInfoToJson(SurahInfo instance) => <String, dynamic>{
      'number': instance.number,
      'name': instance.name,
      'englishName': instance.englishName,
      'englishNameTranslation': instance.englishNameTranslation,
      'numberOfAyahs': instance.numberOfAyahs,
      'revelationType': instance.revelationType,
    };
