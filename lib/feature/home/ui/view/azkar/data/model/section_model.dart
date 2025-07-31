import 'package:equatable/equatable.dart';
import 'package:islami_app/feature/home/ui/view/azkar/data/model/category_model.dart';

class SectionModel extends Equatable {
  final int id;
  final int weight;
  final String name;
  final String icon;
  final List<CategoryModel> categories;

   const SectionModel({
    required this.id,
    required this.weight,
    required this.name,
    required this.icon,
    required this.categories,
  });

  factory SectionModel.fromJson(
    Map<String, dynamic> json,
    List<CategoryModel> allCategories,
  ) {
    final categories =
        (json['categories'] as List)
            .map((c) => allCategories.firstWhere((a) => a.id == c['id']))
            .toList();

    return SectionModel(
      id: json['id'],
      weight: json['weight'],
      name: json['name'],
      icon: json['icon'],
      categories: categories,
    );
  }
  @override
  List<Object?> get props => [
    id,
    weight,
    name,
    icon,
    categories,
  ];
}
