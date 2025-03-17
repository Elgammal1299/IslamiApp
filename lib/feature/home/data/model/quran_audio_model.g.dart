// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_audio_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuranAudioModel _$QuranAudioModelFromJson(Map<String, dynamic> json) =>
    QuranAudioModel(
      reciters:
          (json['reciters'] as List<dynamic>?)
              ?.map((e) => Reciters.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$QuranAudioModelToJson(QuranAudioModel instance) =>
    <String, dynamic>{'reciters': instance.reciters};

Reciters _$RecitersFromJson(Map<String, dynamic> json) => Reciters(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  letter: json['letter'] as String?,
  date: json['date'] as String?,
  moshaf:
      (json['moshaf'] as List<dynamic>?)
          ?.map((e) => Moshaf.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$RecitersToJson(Reciters instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'letter': instance.letter,
  'date': instance.date,
  'moshaf': instance.moshaf,
};

Moshaf _$MoshafFromJson(Map<String, dynamic> json) => Moshaf(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  server: json['server'] as String?,
  surahTotal: (json['surahTotal'] as num?)?.toInt(),
  moshafType: (json['moshafType'] as num?)?.toInt(),
  surahList: json['surahList'] as String?,
);

Map<String, dynamic> _$MoshafToJson(Moshaf instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'server': instance.server,
  'surahTotal': instance.surahTotal,
  'moshafType': instance.moshafType,
  'surahList': instance.surahList,
};
