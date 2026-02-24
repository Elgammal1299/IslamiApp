/// Model يمثل رد API لتفاسير صفحة كاملة
/// GET /page/{pageNumber}/{editionIdentifier}
class TafsirPageModel {
  final int? code;
  final String? status;
  final TafsirPageData? data;

  const TafsirPageModel({this.code, this.status, this.data});

  factory TafsirPageModel.fromJson(Map<String, dynamic> json) {
    return TafsirPageModel(
      code: json['code'] as int?,
      status: json['status'] as String?,
      data:
          json['data'] == null
              ? null
              : TafsirPageData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class TafsirPageData {
  final int? number;
  final List<TafsirAyahItem> ayahs;

  const TafsirPageData({this.number, required this.ayahs});

  factory TafsirPageData.fromJson(Map<String, dynamic> json) {
    final ayahsJson = json['ayahs'] as List<dynamic>? ?? [];
    return TafsirPageData(
      number: json['number'] as int?,
      ayahs:
          ayahsJson
              .map((e) => TafsirAyahItem.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}

class TafsirAyahItem {
  /// الرقم التراكمي (1-6236)
  final int? number;

  /// نص التفسير
  final String? text;

  /// رقم السورة
  final int? surahNumber;

  /// اسم السورة
  final String? surahName;

  /// رقم الآية داخل السورة
  final int? numberInSurah;

  const TafsirAyahItem({
    this.number,
    this.text,
    this.surahNumber,
    this.surahName,
    this.numberInSurah,
  });

  factory TafsirAyahItem.fromJson(Map<String, dynamic> json) {
    final surah = json['surah'] as Map<String, dynamic>?;
    return TafsirAyahItem(
      number: json['number'] as int?,
      text: json['text'] as String?,
      surahNumber: surah?['number'] as int?,
      surahName: surah?['name'] as String?,
      numberInSurah: json['numberInSurah'] as int?,
    );
  }
}
