import 'package:flutter/material.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/feature/home/ui/view/azkar/data/model/supplication_model.dart';

class CustomDialogRawy extends StatelessWidget {
  const CustomDialogRawy({super.key, required this.supplication});

  final SupplicationModel supplication;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Theme.of(context).cardColor,

                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      color: Theme.of(context).canvasColor,
                    ),
                    const SizedBox(width: 8),
                    Text("الراوي", style: context.textTheme.titleLarge),
                  ],
                ),
                content: SingleChildScrollView(
                  child: Text(
                    supplication.note!,
                    style: context.textTheme.titleLarge,
                  ),
                ),
                actions: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).canvasColor,
                      foregroundColor: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    label: const Text("إغلاق"),
                  ),
                ],
              ),
        );
      },
      child: Row(
        children: [
          Text(" الراوي", style: context.textTheme.titleMedium),
          const SizedBox(width: 8),
          Icon(Icons.person_rounded, color: Theme.of(context).primaryColorDark),
        ],
      ),
    );
  }
}
