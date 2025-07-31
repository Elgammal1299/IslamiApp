import 'package:equatable/equatable.dart';

class TafsirByAyah extends Equatable {
  final int? code;
  final String? status;
  final Data? data;

  const TafsirByAyah({this.code, this.status, this.data});
  factory TafsirByAyah.fromJson(Map<String, dynamic> json) {
    return TafsirByAyah(
      code: json['code'],
      status: json['status'],
      data:
          json['data'] == null
              ? null
              : Data.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  @override
  List<Object?> get props => [code, status, data];
}

class Data extends Equatable {
  final int? number;
  final String? text;
  final Edition? edition;
  final Surah? surah;
  final int? numberInSurah;
  final int? juz;
  final int? manzil;
  final int? page;
  final int? ruku;
  final int? hizbQuarter;
  final bool? sajda;

  const Data({
    this.number,
    this.text,
    this.edition,
    this.surah,
    this.numberInSurah,
    this.juz,
    this.manzil,
    this.page,
    this.ruku,
    this.hizbQuarter,
    this.sajda,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    number: (json['number'] as num?)?.toInt(),
    text: json['text'] as String?,
    edition:
        json['edition'] == null
            ? null
            : Edition.fromJson(json['edition'] as Map<String, dynamic>),
    surah:
        json['surah'] == null
            ? null
            : Surah.fromJson(json['surah'] as Map<String, dynamic>),
    numberInSurah: (json['numberInSurah'] as num?)?.toInt(),
    juz: (json['juz'] as num?)?.toInt(),
    manzil: (json['manzil'] as num?)?.toInt(),
    page: (json['page'] as num?)?.toInt(),
    ruku: (json['ruku'] as num?)?.toInt(),
    hizbQuarter: (json['hizbQuarter'] as num?)?.toInt(),
    sajda: json['sajda'] as bool?,
  );

  @override
  List<Object?> get props => [
    number,
    text,
    edition,
    surah,
    numberInSurah,
    juz,
    manzil,
    page,
    ruku,
    hizbQuarter,
    sajda,
  ];
}

class Edition extends Equatable {
  final String? identifier;
  final String? language;
  final String? name;
  final String? englishName;
  final String? format;
  final String? type;
  final String? direction;

  const Edition({
    this.identifier,
    this.language,
    this.name,
    this.englishName,
    this.format,
    this.type,
    this.direction,
  });

  factory Edition.fromJson(Map<String, dynamic> json) => Edition(
    identifier: json['identifier'] as String?,
    language: json['language'] as String?,
    name: json['name'] as String?,
    englishName: json['englishName'] as String?,
    format: json['format'] as String?,
    type: json['type'] as String?,
    direction: json['direction'] as String?,
  );

  @override
  List<Object?> get props {
    return [identifier, language, name, englishName, format, type, direction];
  }
}

class Surah extends Equatable {
  final int? number;
  final String? name;
  final String? englishName;
  final String? englishNameTranslation;
  final int? numberOfAyahs;
  final String? revelationType;

  const Surah({
    this.number,
    this.name,
    this.englishName,
    this.englishNameTranslation,
    this.numberOfAyahs,
    this.revelationType,
  });
  factory Surah.fromJson(Map<String, dynamic> json) => Surah(
    number: (json['number'] as num?)?.toInt(),
    name: json['name'] as String?,
    englishName: json['englishName'] as String?,
    englishNameTranslation: json['englishNameTranslation'] as String?,
    numberOfAyahs: (json['numberOfAyahs'] as num?)?.toInt(),
    revelationType: json['revelationType'] as String?,
  );
  @override
  List<Object?> get props => [
    number,
    name,
    englishName,
    englishNameTranslation,
    numberOfAyahs,
    revelationType,
  ];
}
