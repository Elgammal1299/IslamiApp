// lib/feature/radio/data/model/radio_model.dart
import 'package:equatable/equatable.dart';

class RadioModel extends Equatable {
  final int id;
  final String name;
  final String url;

  RadioModel({
    required this.id,
    required this.name,
    required this.url,
  });

  factory RadioModel.fromJson(Map<String, dynamic> json) {
    return RadioModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      url: json['url'] ?? '',
    );
  }
  @override
  List<Object?> get props => [id, name, url];
}
