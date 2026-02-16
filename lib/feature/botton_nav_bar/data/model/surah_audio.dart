import 'package:json_annotation/json_annotation.dart';

part 'surah_audio.g.dart';

@JsonSerializable()
class SurahAudioResponse {
  final int code;
  final String status;
  final SurahAudioData data;

  SurahAudioResponse({
    required this.code,
    required this.status,
    required this.data,
  });

  factory SurahAudioResponse.fromJson(Map<String, dynamic> json) =>
      _$SurahAudioResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SurahAudioResponseToJson(this);
}

@JsonSerializable()
class SurahAudioData {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final int numberOfAyahs;
  final List<AyahAudio> ayahs;
  final EditionInfoSurah edition;

  SurahAudioData({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.numberOfAyahs,
    required this.ayahs,
    required this.edition,
  });

  factory SurahAudioData.fromJson(Map<String, dynamic> json) =>
      _$SurahAudioDataFromJson(json);

  Map<String, dynamic> toJson() => _$SurahAudioDataToJson(this);
}

@JsonSerializable()
class AyahAudio {
  final int number;
  final String audio;
  final List<String> audioSecondary;
  final String text;
  final int numberInSurah;
  final int juz;
  final int manzil;
  final int page;
  final int ruku;
  final int hizbQuarter;
  final bool sajda;

  AyahAudio({
    required this.number,
    required this.audio,
    required this.audioSecondary,
    required this.text,
    required this.numberInSurah,
    required this.juz,
    required this.manzil,
    required this.page,
    required this.ruku,
    required this.hizbQuarter,
    required this.sajda,
  });

  factory AyahAudio.fromJson(Map<String, dynamic> json) =>
      _$AyahAudioFromJson(json);

  Map<String, dynamic> toJson() => _$AyahAudioToJson(this);
}

@JsonSerializable()
class EditionInfoSurah {
  final String identifier;
  final String language;
  final String name;
  final String englishName;
  final String format;
  final String type;
  final String? direction;

  EditionInfoSurah({
    required this.identifier,
    required this.language,
    required this.name,
    required this.englishName,
    required this.format,
    required this.type,
    this.direction,
  });

  factory EditionInfoSurah.fromJson(Map<String, dynamic> json) =>
      _$EditionInfoSurahFromJson(json);

  Map<String, dynamic> toJson() => _$EditionInfoSurahToJson(this);
}
