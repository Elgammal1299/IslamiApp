// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surah_audio.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SurahAudioResponse _$SurahAudioResponseFromJson(Map<String, dynamic> json) =>
    SurahAudioResponse(
      code: (json['code'] as num).toInt(),
      status: json['status'] as String,
      data: SurahAudioData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SurahAudioResponseToJson(SurahAudioResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'status': instance.status,
      'data': instance.data,
    };

SurahAudioData _$SurahAudioDataFromJson(Map<String, dynamic> json) =>
    SurahAudioData(
      number: (json['number'] as num).toInt(),
      name: json['name'] as String,
      englishName: json['englishName'] as String,
      englishNameTranslation: json['englishNameTranslation'] as String,
      revelationType: json['revelationType'] as String,
      numberOfAyahs: (json['numberOfAyahs'] as num).toInt(),
      ayahs: (json['ayahs'] as List<dynamic>)
          .map((e) => AyahAudio.fromJson(e as Map<String, dynamic>))
          .toList(),
      edition:
          EditionInfoSurah.fromJson(json['edition'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SurahAudioDataToJson(SurahAudioData instance) =>
    <String, dynamic>{
      'number': instance.number,
      'name': instance.name,
      'englishName': instance.englishName,
      'englishNameTranslation': instance.englishNameTranslation,
      'revelationType': instance.revelationType,
      'numberOfAyahs': instance.numberOfAyahs,
      'ayahs': instance.ayahs,
      'edition': instance.edition,
    };

AyahAudio _$AyahAudioFromJson(Map<String, dynamic> json) => AyahAudio(
      number: (json['number'] as num).toInt(),
      audio: json['audio'] as String,
      audioSecondary: (json['audioSecondary'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      text: json['text'] as String,
      numberInSurah: (json['numberInSurah'] as num).toInt(),
      juz: (json['juz'] as num).toInt(),
      manzil: (json['manzil'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      ruku: (json['ruku'] as num).toInt(),
      hizbQuarter: (json['hizbQuarter'] as num).toInt(),
      sajda: json['sajda'] as bool,
    );

Map<String, dynamic> _$AyahAudioToJson(AyahAudio instance) => <String, dynamic>{
      'number': instance.number,
      'audio': instance.audio,
      'audioSecondary': instance.audioSecondary,
      'text': instance.text,
      'numberInSurah': instance.numberInSurah,
      'juz': instance.juz,
      'manzil': instance.manzil,
      'page': instance.page,
      'ruku': instance.ruku,
      'hizbQuarter': instance.hizbQuarter,
      'sajda': instance.sajda,
    };

EditionInfoSurah _$EditionInfoSurahFromJson(Map<String, dynamic> json) =>
    EditionInfoSurah(
      identifier: json['identifier'] as String,
      language: json['language'] as String,
      name: json['name'] as String,
      englishName: json['englishName'] as String,
      format: json['format'] as String,
      type: json['type'] as String,
      direction: json['direction'] as String?,
    );

Map<String, dynamic> _$EditionInfoSurahToJson(EditionInfoSurah instance) =>
    <String, dynamic>{
      'identifier': instance.identifier,
      'language': instance.language,
      'name': instance.name,
      'englishName': instance.englishName,
      'format': instance.format,
      'type': instance.type,
      'direction': instance.direction,
    };
