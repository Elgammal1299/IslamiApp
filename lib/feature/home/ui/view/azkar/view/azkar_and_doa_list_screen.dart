import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/feature/home/ui/view/azkar/data/model/category_model.dart';
import 'package:islami_app/feature/home/ui/view/azkar/view/widget/custom_dialog_rawy.dart';
import 'package:share_plus/share_plus.dart';

class AzkarAndDoaListScreen extends StatelessWidget {
  final CategoryModel category;

  const AzkarAndDoaListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: category.supplications.length,
        itemBuilder: (context, index) {
          final supplication = category.supplications[index];

          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        supplication.body,
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (supplication.note != null &&
                          supplication.note!.trim().isNotEmpty)
                        CustomDialogRawy(supplication: supplication),
                    ],
                  ),
                ),

                // ==== أزرار النسخ والمشاركة ====
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).secondaryHeaderColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.share,
                          color: Theme.of(context).primaryColor,
                        ),
                        tooltip: "مشاركة",
                        onPressed: () {
                          Share.share(supplication.body);
                        },
                      ),
                      const SizedBox(width: 14),
                      IconButton(
                        icon: Icon(
                          Icons.copy,
                          color: Theme.of(context).primaryColor,
                        ),
                        tooltip: "نسخ",
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: supplication.body),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("✅ تم نسخ الذكر")),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
