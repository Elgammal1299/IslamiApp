import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      margin: const EdgeInsets.symmetric(vertical: 8),
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
            child: SelectableText(
              hadithModel.arab,
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
              
              
                IconButton(
                  tooltip: 'مشاركة',
                  icon: Icon(
                    Icons.share,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    Share.share(hadithModel.arab);
                  },
                ),
                IconButton(
                  tooltip: 'نسخ',
                  icon: Icon(
                    Icons.copy,
                    color: Theme.of(context).primaryColorDark,
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
    )
      
    );
  }
}
