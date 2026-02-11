class QuranDuaModel {
  final String category;
  final String count;
  final String description;
  final String reference;
  final String content;

  QuranDuaModel({
    required this.category,
    required this.count,
    required this.description,
    required this.reference,
    required this.content,
  });

  factory QuranDuaModel.fromJson(Map<String, dynamic> json) {
    return QuranDuaModel(
      category: json['category'] ?? '',
      count: json['count'] ?? '',
      description: json['description'] ?? '',
      reference: json['reference'] ?? '',
      content: _cleanText(json['content'] ?? ''),
    );
  }

  static String _cleanText(String text) {
    return text
        .replaceAll("\\n", "")
        .replaceAll("', '", "")
        .replaceAll("'", "")
        .replaceAll('"', '')
        .trim();
  }
}
