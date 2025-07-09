import 'package:flutter/material.dart';
import 'package:islami_app/feature/home/ui/view/azkar/data/model/azkar_yawmi_model.dart';
import 'package:islami_app/feature/home/ui/view/azkar/view/supplication_reader_screen.dart';

class CustomAzkarYawmiListViewItem extends StatelessWidget {
  const CustomAzkarYawmiListViewItem({
    super.key,
    required this.items,
    required this.category,
  });

  final List<AzkarYawmiModel> items;
  final String category;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SupplicationReaderScreen(supplications: items),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FAF8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFB2D1D8), width: 1),
        ),
        child: Row(
          children: [
            // دائرة أيقونة
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFB2D1D8),
              ),
              child: const Icon(
                Icons.bookmark_border_rounded,
                size: 24,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),

            // الاسم وعدد الأذكار
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2B6777),
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${items.length} ذكر',
                    style: const TextStyle(fontSize: 14, color: Colors.teal),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
