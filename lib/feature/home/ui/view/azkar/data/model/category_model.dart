import 'package:islami_app/feature/home/ui/view/azkar/data/model/supplication_model.dart';

class CategoryModel {
  final int id;
  final int weight;
  final String name;
  final String nameSearch;
  final bool favorite;
  final List<SupplicationModel> supplications;

  CategoryModel({
    required this.id,
    required this.weight,
    required this.name,
    required this.nameSearch,
    required this.favorite,
    required this.supplications,
  });

  factory CategoryModel.fromJson(
    Map<String, dynamic> json,
    List<SupplicationModel> allSupplications,
  ) {
    final supplications = (json['supplications'] as List)
        .map((s) => allSupplications.firstWhere((a) => a.id == s['id']))
        .toList();

    return CategoryModel(
      id: json['id'],
      weight: json['weight'],
      name: json['name'],
      nameSearch: json['nameSearch'],
      favorite: json['favorite'],
      supplications: supplications,
    );
  }
  }