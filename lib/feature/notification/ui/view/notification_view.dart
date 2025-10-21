import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:share_plus/share_plus.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key, required this.title, required this.body});
  final String title, body;

  @override
  Widget build(BuildContext context) {
    // final args =
    //     ModalRoute.of(context)?.settings.arguments as Map<String, String>?;

    // final title = args?['title'] ?? 'لا يوجد عنوان';
    // final body = args?['body'] ?? 'لا يوجد محتوى';

    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الإشعار')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    title,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.justify,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Divider(color: AppColors.black),
                  SelectableText(
                    body,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.justify,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    tooltip: 'مشاركة',
                    icon: Icon(
                      Icons.share,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    onPressed: () {
                      // ignore: prefer_interpolation_to_compose_strings
                      Share.share(title + '\n' + body);
                    },
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    tooltip: 'نسخ',
                    icon: Icon(
                      Icons.copy,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    onPressed: () {
                      // ignore: prefer_interpolation_to_compose_strings
                      Clipboard.setData(ClipboardData(text: '$title\n$body'));
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
