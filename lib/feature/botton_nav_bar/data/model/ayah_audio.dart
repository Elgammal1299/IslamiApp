import 'package:json_annotation/json_annotation.dart';

part 'ayah_audio.g.dart';

@JsonSerializable()
class AyahAudioResponse {
  final int code;
  final String status;
  final AyahAudioData data;

  AyahAudioResponse({
    required this.code,
    required this.status,
    required this.data,
  });

  factory AyahAudioResponse.fromJson(Map<String, dynamic> json) =>
      _$AyahAudioResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AyahAudioResponseToJson(this);
}

@JsonSerializable()
class AyahAudioData {
  final int number;
  final String audio;
  final List<String> audioSecondary;
  final String text;
  final EditionInfo edition;
  final SurahInfo surah;
  final int numberInSurah;
  final int juz;
  final int manzil;
  final int page;
  final int ruku;
  final int hizbQuarter;
  final bool sajda;

  AyahAudioData({
    required this.number,
    required this.audio,
    required this.audioSecondary,
    required this.text,
    required this.edition,
    required this.surah,
    required this.numberInSurah,
    required this.juz,
    required this.manzil,
    required this.page,
    required this.ruku,
    required this.hizbQuarter,
    required this.sajda,
  });

  factory AyahAudioData.fromJson(Map<String, dynamic> json) =>
      _$AyahAudioDataFromJson(json);

  Map<String, dynamic> toJson() => _$AyahAudioDataToJson(this);
}

@JsonSerializable()
class EditionInfo {
  final String identifier;
  final String language;
  final String name;
  final String englishName;
  final String format;
  final String type;
  final String? direction;

  EditionInfo({
    required this.identifier,
    required this.language,
    required this.name,
    required this.englishName,
    required this.format,
    required this.type,
    this.direction,
  });

  factory EditionInfo.fromJson(Map<String, dynamic> json) =>
      _$EditionInfoFromJson(json);

  Map<String, dynamic> toJson() => _$EditionInfoToJson(this);
}

@JsonSerializable()
class SurahInfo {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final int numberOfAyahs;
  final String revelationType;

  SurahInfo({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.numberOfAyahs,
    required this.revelationType,
  });

  factory SurahInfo.fromJson(Map<String, dynamic> json) =>
      _$SurahInfoFromJson(json);

  Map<String, dynamic> toJson() => _$SurahInfoToJson(this);
}
