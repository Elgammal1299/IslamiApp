import 'package:equatable/equatable.dart';

class AzkarYawmiModel  extends Equatable {
  final String category;
  final String count;
  final String content;
  final String description;
  final String reference;

  const AzkarYawmiModel({
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
  @override
  List<Object?> get props => [
    category,
    count,
    content,
    description,
    reference,
  ];

}
