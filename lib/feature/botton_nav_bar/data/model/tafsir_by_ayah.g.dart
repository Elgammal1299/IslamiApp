// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'tafsir_by_ayah.dart';

// // **************************************************************************
// // JsonSerializableGenerator
// // **************************************************************************

// TafsirByAyah _$TafsirByAyahFromJson(Map<String, dynamic> json) => TafsirByAyah(
//       code: (json['code'] as num?)?.toInt(),
//       status: json['status'] as String?,
//       data: json['data'] == null
//           ? null
//           : Data.fromJson(json['data'] as Map<String, dynamic>),
//     );

// Map<String, dynamic> _$TafsirByAyahToJson(TafsirByAyah instance) =>
//     <String, dynamic>{
//       'code': instance.code,
//       'status': instance.status,
//       'data': instance.data,
//     };

// Data _$DataFromJson(Map<String, dynamic> json) => Data(
//       number: (json['number'] as num?)?.toInt(),
//       text: json['text'] as String?,
//       edition: json['edition'] == null
//           ? null
//           : Edition.fromJson(json['edition'] as Map<String, dynamic>),
//       surah: json['surah'] == null
//           ? null
//           : Surah.fromJson(json['surah'] as Map<String, dynamic>),
//       numberInSurah: (json['numberInSurah'] as num?)?.toInt(),
//       juz: (json['juz'] as num?)?.toInt(),
//       manzil: (json['manzil'] as num?)?.toInt(),
//       page: (json['page'] as num?)?.toInt(),
//       ruku: (json['ruku'] as num?)?.toInt(),
//       hizbQuarter: (json['hizbQuarter'] as num?)?.toInt(),
//       sajda: json['sajda'] as bool?,
//     );

// Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
//       'number': instance.number,
//       'text': instance.text,
//       'edition': instance.edition,
//       'surah': instance.surah,
//       'numberInSurah': instance.numberInSurah,
//       'juz': instance.juz,
//       'manzil': instance.manzil,
//       'page': instance.page,
//       'ruku': instance.ruku,
//       'hizbQuarter': instance.hizbQuarter,
//       'sajda': instance.sajda,
//     };

// Edition _$EditionFromJson(Map<String, dynamic> json) => Edition(
//       identifier: json['identifier'] as String?,
//       language: json['language'] as String?,
//       name: json['name'] as String?,
//       englishName: json['englishName'] as String?,
//       format: json['format'] as String?,
//       type: json['type'] as String?,
//       direction: json['direction'] as String?,
//     );

// Map<String, dynamic> _$EditionToJson(Edition instance) => <String, dynamic>{
//       'identifier': instance.identifier,
//       'language': instance.language,
//       'name': instance.name,
//       'englishName': instance.englishName,
//       'format': instance.format,
//       'type': instance.type,
//       'direction': instance.direction,
//     };

// Surah _$SurahFromJson(Map<String, dynamic> json) => Surah(
//       number: (json['number'] as num?)?.toInt(),
//       name: json['name'] as String?,
//       englishName: json['englishName'] as String?,
//       englishNameTranslation: json['englishNameTranslation'] as String?,
//       numberOfAyahs: (json['numberOfAyahs'] as num?)?.toInt(),
//       revelationType: json['revelationType'] as String?,
//     );

// Map<String, dynamic> _$SurahToJson(Surah instance) => <String, dynamic>{
//       'number': instance.number,
//       'name': instance.name,
//       'englishName': instance.englishName,
//       'englishNameTranslation': instance.englishNameTranslation,
//       'numberOfAyahs': instance.numberOfAyahs,
//       'revelationType': instance.revelationType,
//     };
