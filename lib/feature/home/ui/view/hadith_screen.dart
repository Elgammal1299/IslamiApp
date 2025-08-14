import 'package:flutter/material.dart';
import 'package:islami_app/feature/home/data/model/hadith_model_item.dart';
import 'package:islami_app/feature/home/ui/view/widget/hadith_name_item.dart';

class HadithScreen extends StatelessWidget {
  const HadithScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('أحاديث نبوية')),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        itemCount: hadithItems.length,
        itemBuilder: (context, index) {
          return HadithNameItem(item: hadithItems[index]);
        },
      ),
    );
  }
}
