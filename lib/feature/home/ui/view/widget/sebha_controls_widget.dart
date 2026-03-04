import 'package:flutter/material.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/core/extension/theme_text.dart';

class SebhaControlsWidget extends StatelessWidget {
  final VoidCallback onReset;
  final VoidCallback onSettings;
  final bool hasCustomDhikr;

  const SebhaControlsWidget({
    super.key,
    required this.onReset,
    required this.onSettings,
    this.hasCustomDhikr = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // زر إعادة التعيين
        Expanded(
          child: GestureDetector(
            onTap: onReset,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).cardColor,
                // boxShadow: [
                //   BoxShadow(
                //     color: Theme.of(context).shadowColor.withValues(alpha: 0.2),
                //     blurRadius: 8,
                //     offset: const Offset(0, 4),
                //   ),
                // ],
              ),
              child: Row(
                // mainAxisSize: MainAxisSize.min,
                 mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(
                    Icons.refresh_rounded,
                    color: Theme.of(context).primaryColorDark,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "إعادة التعيين",
                    style: context.textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).primaryColorDark,
fontFamily: 'Amiri',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // زر الإعدادات
        Expanded(
          child: GestureDetector(
            onTap: onSettings,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color:
                    hasCustomDhikr
                        ? Theme.of(context).cardColor
                        : Theme.of(context).cardColor,
                // boxShadow: [
                //   BoxShadow(
                //     color: Theme.of(context).shadowColor.withValues(alpha: 0.2),
                //     blurRadius: 8,
                //     offset: const Offset(0, 4),
                //   ),
                // ],
              ),
              child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Icon(
                    hasCustomDhikr ? Icons.edit : Icons.add,
                    color: Theme.of(context).primaryColorDark,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    hasCustomDhikr ? "تعديل الذكر" : "إضافة ذكر",
                    style: context.textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).primaryColorDark,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Amiri',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
