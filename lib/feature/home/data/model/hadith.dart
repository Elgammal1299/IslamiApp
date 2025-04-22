// ignore_for_file: public_member_api_docs, sort_constructors_first

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

  factory HadithModel.fromMap(Map<String, dynamic> map) {
    return HadithModel(
      number: map['number'] as int,
      arab: map['arab'] as String,
      id: map['id'] as String,
    );
  }
}
