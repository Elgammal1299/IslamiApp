import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:islami_app/feature/home/ui/view/azkar/data/model/category_model.dart';
import 'package:islami_app/feature/home/ui/view/azkar/data/model/section_model.dart';
import 'package:islami_app/feature/home/ui/view/azkar/data/model/supplication_model.dart';

class AzkarRepo {
  Future<List<SupplicationModel>> loadSupplications() async {
    final data = await rootBundle.loadString(
      'assets/json/Azkar/Supplication.json',
    );
    final decoded = json.decode(data) as List;
    return decoded.map((e) => SupplicationModel.fromJson(e)).toList();
  }

  Future<List<CategoryModel>> loadCategories(
    List<SupplicationModel> allSupplications,
  ) async {
    final data = await rootBundle.loadString('assets/json/Azkar/Category.json');
    final decoded = json.decode(data) as List;
    return decoded
        .map((e) => CategoryModel.fromJson(e, allSupplications))
        .toList();
  }

  Future<List<SectionModel>> loadSections() async {
    final supplications = await loadSupplications();
    final categories = await loadCategories(supplications);

    final data = await rootBundle.loadString('assets/json/Azkar/Section.json');
    final decoded = json.decode(data) as List;
    return decoded.map((e) => SectionModel.fromJson(e, categories)).toList();
  }
}
