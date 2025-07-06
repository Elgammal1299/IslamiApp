class HadithNawawiModel {
  final String hadith;
  final String description;

  HadithNawawiModel({required this.hadith, required this.description});

  factory HadithNawawiModel.fromJson(Map<String, dynamic> json) {
    return HadithNawawiModel(
      hadith: json['hadith'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
    'hadith': hadith,
    'description': description,
  };
}
