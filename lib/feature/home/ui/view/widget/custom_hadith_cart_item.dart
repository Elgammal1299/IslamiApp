import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/feature/home/data/model/hadith_model.dart';
import 'package:share_plus/share_plus.dart';

class CustomHadithCard extends StatelessWidget {
  final HadithModel hadithModel;
  const CustomHadithCard({super.key, required this.hadithModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
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
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: SelectableText(
                hadithModel.arab,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.titleLarge,
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
                      Share.share(hadithModel.arab);
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
                      Clipboard.setData(ClipboardData(text: hadithModel.arab));
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
