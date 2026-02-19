import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami_app/feature/home/ui/view/azkar/data/model/azkar_yawmi_model.dart';
import 'package:share_plus/share_plus.dart';

import 'package:islami_app/feature/home/ui/view/azkar/view/widget/custom_azkar_status_widget.dart';

class CustomCardBodyAzkar extends StatelessWidget {
  const CustomCardBodyAzkar({
    super.key,
    required this.current,
    required this.currentCount,
    required this.maxCount,
    this.onTap,
  });

  final AzkarYawmiModel current;
  final int currentCount;
  final int maxCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    String cleanContent(String raw) {
      return raw
          .replaceAll(
            RegExp(r"(\\n|',\s?'|,\s?'|',)"),
            '\n',
          ) // يحوّل كل أشكال الفواصل لأسطر
          .replaceAll(RegExp(r"[\\]+"), '') // يشيل الـ \ فقط
          .replaceAll('"', '') // يشيل علامات التنصيص المزدوجة
          .replaceAll(RegExp(r"\n{2,}"), '\n') // يمنع تكرار الأسطر الفارغة
          .trim();
    }

    final isFinished = currentCount >= maxCount;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
              decoration: const BoxDecoration(
                // Remove color from here to let InkWell splash show on the whole card
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: IgnorePointer(
                child: SelectableText(
                  cleanContent(current.content),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColorDark,
                    fontFamily: 'Amiri',
                    fontSize: 25.sp,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  CustomAzkarStatusWidget(isFinished: isFinished),
                  const Spacer(),
                
                  Text(
                    ' $currentCount من $maxCount',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColorDark,
                      fontFamily: 'Amiri',
                    ),
                  ),

                  const Spacer(),
                  IconButton(
                    tooltip: 'مشاركة',
                    icon: Icon(
                      Icons.share,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      Share.share(current.content);
                    },
                  ),
                  IconButton(
                    tooltip: 'نسخ',
                    icon: Icon(
                      Icons.copy,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: current.content));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("✅ تم النسخ")),
                      );
                    },
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
