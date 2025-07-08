import 'package:flutter/material.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/quran_veres.dart';

class AyatDueaPage extends StatelessWidget {
  const AyatDueaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
child: Text("دعاء من  القرءان الكريم", style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,//blueColor,
                          fontSize: 20,
                        ), ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: verses.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'سورة ${verses[index].surahName}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,//blueColor,
                          fontSize: 16,
                        ),
                      ),
          
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          verses[index].text,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontFamily: "arsura",
                            fontSize: 22,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          verses[index].number.toString(),
          
                          style: const TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
