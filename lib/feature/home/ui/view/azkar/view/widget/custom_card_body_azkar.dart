import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            decoration: const BoxDecoration(
              color: Color(0xFF2B6777),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SelectableText(
              cleanContent(current.content),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                height: 1.7,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: const BoxDecoration(
              color: Color(0xFFB2D1D8),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  tooltip: 'نسخ',
                  icon: const Icon(Icons.copy, color: Colors.white),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: current.content));
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text("✅ تم النسخ")));
                  },
                ),
                IconButton(
                  tooltip: 'مشاركة',
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () {
                    Share.share(current.content);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
