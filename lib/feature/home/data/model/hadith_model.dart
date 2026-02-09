// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'hadith_model.g.dart';

@HiveType(typeId: 103)
// ignore: must_be_immutable
class HadithModel extends HiveObject with EquatableMixin {
  @HiveField(0)
  final int number;

  @HiveField(1)
  final String arab;

  @HiveField(2)
  final String id;

  HadithModel({required this.number, required this.arab, required this.id});

  HadithModel copyWith({int? number, String? arab, String? id}) {
    return HadithModel(
      number: number ?? this.number,
      arab: arab ?? this.arab,
      id: id ?? this.id,
    );
  }

  factory HadithModel.fromJson(Map<String, dynamic> json) {
    return HadithModel(
      number: json['number'] as int,
      arab: json['arab'] as String,
      id: json['id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'number': number, 'arab': arab, 'id': id};
  }

  @override
  List<Object?> get props => [number, arab, id];
}
