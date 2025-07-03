import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;

class RecitersSurahList extends StatelessWidget {
  final String surahList;
  final String server;
  const RecitersSurahList({
    super.key,
    required this.surahList,
    required this.server,
  });

  @override
  Widget build(BuildContext context) {
    List<int> numberSurahList =
        surahList
            .split(",")
            .map((e) => e.trim()) // إزالة الفراغات
            .where((e) => e.isNotEmpty) // إزالة العناصر الفارغة
            .map(int.parse) // تحويل إلى int
            .toList();
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: numberSurahList.length,
              itemBuilder: (context, index) {
                final surahNumber = numberSurahList[index];
                final formattedNumber = surahNumber.toString().padLeft(3, '0');
                // log('$surahNumber');
                // log('$numberSurahList');
                return InkWell(
                  onTap: () => print('$server$formattedNumber.mp3'),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'سورة ${quran.getSurahNameArabic(surahNumber)}',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
