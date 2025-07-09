import 'package:flutter/material.dart';
import 'package:islami_app/feature/home/ui/view/azkar/data/model/category_model.dart';
import 'package:islami_app/feature/home/ui/view/azkar/view/azkar_and_doa_list_screen.dart';

class CustomAzkarAndDoaList extends StatelessWidget {
  const CustomAzkarAndDoaList({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        title: Text(
          category.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blueGrey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "${category.supplications.length} حديث",
            style: const TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AzkarAndDoaListScreen(category: category),
            ),
          );
        },
      ),
    );
  }
}
