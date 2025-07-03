import 'package:flutter/material.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/feature/home/data/model/hadith.dart';

class HadithCard extends StatelessWidget {
  final HadithModel hadithModel;
  const HadithCard({super.key, required this.hadithModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Icon(Icons.book, color: Colors.blue[900]),
                const Spacer(),
                Text(
                  'حديث رقم  ${hadithModel.number}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: blueColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                hadithModel.arab,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontFamily: "arsura",
                  fontSize: 22,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: blueColor,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
