import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:islami_app/feature/home/ui/view/azkar/data/model/azkar_yawmi_model.dart';

class AzkarYawmiRepo {
  Future<Map<String, List<AzkarYawmiModel>>> loadSupplications() async {
    final jsonString = await rootBundle.loadString('assets/json/azkar.json');
    final Map<String, dynamic> data = json.decode(jsonString);

    return data.map((key, value) {
      final list = value as List;
      final supplications =
          list
              .expand(
                (item) =>
                    item is List
                        ? item.map((e) => AzkarYawmiModel.fromJson(e))
                        : [AzkarYawmiModel.fromJson(item)],
              )
              .toList();
      return MapEntry(key, supplications);
    });
  }
}
