class Hadith40Model {
  final String category;
  final String description;
  final String hadith;

  Hadith40Model({
    required this.category,
    required this.description,
    required this.hadith,
  });

  factory Hadith40Model.fromJson(Map<String, dynamic> json) {
    return Hadith40Model(
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      hadith: json['hadith'] ?? '',
    );
  }
}
