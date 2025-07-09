import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // ==== الحديث + الراوي (بنفس الخلفية) ====
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2B6777),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        supplication.body,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
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
                  decoration: const BoxDecoration(
                    color: Color(0xFFB2D1D8),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.white),
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
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.white),
                        tooltip: "مشاركة",
                        onPressed: () {
                          Share.share(supplication.body);
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
