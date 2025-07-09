import 'package:flutter/material.dart';
import 'package:islami_app/feature/home/ui/view/azkar/view/supplication_reader_screen.dart';

class CustomCountRepetItem extends StatelessWidget {
  const CustomCountRepetItem({
    super.key,
    required this.currentIndex,
    required this.widget,
    required this.maxCount,
  });

  final int currentIndex;
  final SupplicationReaderScreen widget;
  final int maxCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'الذكر ${currentIndex + 1} من ${widget.supplications.length}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2F1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.teal, width: 1.2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.repeat, color: Colors.teal, size: 20),
              const SizedBox(width: 6),
              Text(
                'التكرار: $maxCount مرة',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.teal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
