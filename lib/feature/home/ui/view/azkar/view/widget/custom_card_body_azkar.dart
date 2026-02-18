import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami_app/feature/home/ui/view/azkar/data/model/azkar_yawmi_model.dart';
import 'package:share_plus/share_plus.dart';

class CustomCardBodyAzkar extends StatelessWidget {
  const CustomCardBodyAzkar({super.key, required this.current});

  final AzkarYawmiModel current;

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

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
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
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
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
                const SizedBox(width: 16),
                IconButton(
                  tooltip: 'نسخ',
                  icon: Icon(
                    Icons.copy,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: current.content));
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text("✅ تم النسخ")));
                  },
                ),
              ],
            ),
          
        ],
      ),
    );
  }
}
