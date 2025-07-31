import 'package:flutter/material.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final title = args?['title'] ?? 'لا يوجد عنوان';
    final body = args?['body'] ?? 'لا يوجد محتوى';

    return Scaffold(
      appBar: AppBar(title: Text('تفاصيل الإشعار')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'العنوان:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(title, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text(
              'النص:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(body, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
