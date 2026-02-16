import 'package:json_annotation/json_annotation.dart';

part 'reciter_edition.g.dart';

@JsonSerializable()
class ReciterEditionResponse {
  final int code;
  final String status;
  final List<ReciterEdition> data;

  ReciterEditionResponse({
    required this.code,
    required this.status,
    required this.data,
  });

  factory ReciterEditionResponse.fromJson(Map<String, dynamic> json) =>
      _$ReciterEditionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ReciterEditionResponseToJson(this);
}

@JsonSerializable()
class ReciterEdition {
  final String identifier;
  final String language;
  final String name;
  final String englishName;
  final String format;
  final String type;
  final String? direction;

  ReciterEdition({
    required this.identifier,
    required this.language,
    required this.name,
    required this.englishName,
    required this.format,
    required this.type,
    this.direction,
  });

  factory ReciterEdition.fromJson(Map<String, dynamic> json) =>
      _$ReciterEditionFromJson(json);

  Map<String, dynamic> toJson() => _$ReciterEditionToJson(this);
}
