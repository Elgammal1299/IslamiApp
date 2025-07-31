import 'package:equatable/equatable.dart';

class HadithNawawiModel extends Equatable {
  final String hadith;
  final String description;

 const HadithNawawiModel({required this.hadith, required this.description});

  factory HadithNawawiModel.fromJson(Map<String, dynamic> json) {
    return HadithNawawiModel(
      hadith: json['hadith'],
      description: json['description'],
    );
  }

  
  @override
  List<Object?> get props => [hadith, description];
}
