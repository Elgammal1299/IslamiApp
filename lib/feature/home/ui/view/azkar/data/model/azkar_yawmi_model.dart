import 'package:equatable/equatable.dart';

class AzkarCategoryModel extends Equatable {
  final int id;
  final String category;
  final String audio;
  final String filename;
  final List<AzkarYawmiModel> array;

  const AzkarCategoryModel({
    required this.id,
    required this.category,
    required this.audio,
    required this.filename,
    required this.array,
  });

  factory AzkarCategoryModel.fromJson(Map<String, dynamic> json) {
    return AzkarCategoryModel(
      id: json['id'] ?? 0,
      category: json['category'] ?? '',
      audio: json['audio'] ?? '',
      filename: json['filename'] ?? '',
      array:
          (json['array'] as List<dynamic>?)
              ?.map((e) => AzkarYawmiModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [id, category, audio, filename, array];
}

class AzkarYawmiModel extends Equatable {
  final int id;
  final String content; // Mapped from 'text'
  final int count; // Changed to int
  final String audio;
  final String filename;

  const AzkarYawmiModel({
    required this.id,
    required this.content,
    required this.count,
    required this.audio,
    required this.filename,
  });

  factory AzkarYawmiModel.fromJson(Map<String, dynamic> json) {
    return AzkarYawmiModel(
      id: json['id'] ?? 0,
      content: json['text'] ?? '',
      count: json['count'] ?? 1,
      audio: json['audio'] ?? '',
      filename: json['filename'] ?? '',
    );
  }
  @override
  List<Object?> get props => [id, content, count, audio, filename];
}
