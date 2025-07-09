class AzkarYawmiModel {
  final String category;
  final String count;
  final String content;
  final String description;
  final String reference;

  AzkarYawmiModel({
    required this.category,
    required this.count,
    required this.content,
    required this.description,
    required this.reference,
  });

  factory AzkarYawmiModel.fromJson(Map<String, dynamic> json) {
    return AzkarYawmiModel(
      category: json['category'] ?? '',
      count: json['count'] ?? '',
      content: json['content'] ?? '',
      description: json['description'] ?? '',
      reference: json['reference'] ?? '',
    );
  }
}
