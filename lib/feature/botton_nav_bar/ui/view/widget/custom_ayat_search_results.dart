import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:quran/quran.dart';

class CustomAyatSearchResults extends StatelessWidget {
  const CustomAyatSearchResults({super.key, required this.searchedForAyats});

  final dynamic searchedForAyats;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: searchedForAyats["occurences"],
      itemBuilder: (context, index) {
        final result = searchedForAyats["result"][index];
        return Padding(
          padding: const EdgeInsets.all(6.0),
          child: EasyContainer(
            color: Colors.white70,
            borderRadius: 14,
            onTap: () {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "سورة ${getSurahNameArabic(result["surah"])} - الآية ${result["verse"]}",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  getVerse(
                    result["surah"],
                    result["verse"],
                    verseEndSymbol: true,
                  ),
                  textDirection: TextDirection.rtl,
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
