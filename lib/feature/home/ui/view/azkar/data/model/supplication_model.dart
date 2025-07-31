import 'package:equatable/equatable.dart';

class SupplicationModel extends Equatable {
  final int id;
  final int repeat;
  final String body;
  final String bodyVocalized;
  final String? note;

  SupplicationModel({
    required this.id,
    required this.repeat,
    required this.body,
    required this.bodyVocalized,
    this.note,
  });

  factory SupplicationModel.fromJson(Map<String, dynamic> json) =>
      SupplicationModel(
        id: json['id'],
        repeat: json['repeat'],
        body: json['body'],
        bodyVocalized: json['bodyVocalized'],
        note: json['note'],
      );
@override
  List<Object?> get props => [id, repeat, body, bodyVocalized, note];
}
