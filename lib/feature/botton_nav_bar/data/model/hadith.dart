// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class HadithModel {
  final int number;
  final String arab;
  final String id;

  const HadithModel({
    required this.number,
    required this.arab,
    required this.id,
  });

  HadithModel copyWith({int? number, String? arab, String? id}) {
    return HadithModel(
      number: number ?? this.number,
      arab: arab ?? this.arab,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'number': number, 'arab': arab, 'id': id};
  }

  factory HadithModel.fromMap(Map<String, dynamic> map) {
    return HadithModel(
      number: map['number'] as int,
      arab: map['arab'] as String,
      id: map['id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory HadithModel.fromJson(String source) =>
      HadithModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SurahModel(number: $number, arab: $arab, id: $id)';

  @override
  bool operator ==(covariant HadithModel other) {
    if (identical(this, other)) return true;

    return other.number == number && other.arab == arab && other.id == id;
  }

  @override
  int get hashCode => number.hashCode ^ arab.hashCode ^ id.hashCode;
}
