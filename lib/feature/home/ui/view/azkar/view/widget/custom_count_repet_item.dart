import 'package:flutter/material.dart';
import 'package:islami_app/core/extension/theme_text.dart';
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الذكر ${currentIndex + 1} من ${widget.supplications.length}',
          style: context.textTheme.titleLarge,
        ),
        const SizedBox(height: 16),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).secondaryHeaderColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).canvasColor,
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.repeat,
                color: Theme.of(context).canvasColor,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                'التكرار: $maxCount مرة',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).canvasColor,
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
