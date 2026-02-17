import 'package:flutter/material.dart';
import 'package:islami_app/core/extension/theme_text.dart';

class DhikrDisplayWidget extends StatelessWidget {
  final String dhikrText;
  final int currentCount;
  final int targetCount;

  const DhikrDisplayWidget({
    super.key,
    required this.dhikrText,
    required this.currentCount,
    required this.targetCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColorDark,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // الذكر الحالي
          Text(
            dhikrText,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          // شريط التقدم
          if (targetCount > 0) ...[
            LinearProgressIndicator(
              value: currentCount / targetCount,
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              valueColor: AlwaysStoppedAnimation<Color>(
                currentCount >= targetCount
                    ? Colors.green
                    : Theme.of(context).primaryColor,
              ),
              minHeight: 8,
            ),
            const SizedBox(height: 10),
            Text(
              "$currentCount / $targetCount",
              style: context.textTheme.titleMedium?.copyWith(
                color:
                    currentCount >= targetCount
                        ? Colors.green
                        : Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          if (currentCount >= targetCount && targetCount > 0) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 20),
                  const SizedBox(width: 5),
                  Text(
                    "تم إكمال الذكر!",
                    style: context.textTheme.titleSmall?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
