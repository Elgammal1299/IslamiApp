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
        contentPadding: EdgeInsets.all(14),
        title: Text(
          category.name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).secondaryHeaderColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "${category.supplications.length} حديث",
            style: TextStyle(
              color: Theme.of(context).canvasColor,
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
