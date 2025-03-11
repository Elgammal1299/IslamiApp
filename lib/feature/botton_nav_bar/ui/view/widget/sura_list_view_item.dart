
import 'package:flutter/material.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/sura.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/quran_page.dart';
import 'package:quran/quran.dart';

class SuraListViewItem extends StatelessWidget {
  const SuraListViewItem({
    super.key,
    required this.suraNumber,
    required this.suraName,
    required this.suraNameEnglishTranslated,
    required this.ayahCount,
    required this.suraNumberInQuran,
    required this.surahs,
  });

  final int suraNumber;
  final String suraName;
  final String suraNameEnglishTranslated;
  final int ayahCount;
  final int suraNumberInQuran;
  final List<SurahModel> surahs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        child: Row(
          children: [
            
            ListTile(
              
              leading: SizedBox(
                width: 45,
                height: 45,
                child: Center(
                  child: Text(
                    suraNumber.toString(),
                    style: const TextStyle(color: orangeColor, fontSize: 14),
                  ),
                ),
              ), //  Material(
              minVerticalPadding: 0,
              title: SizedBox(
                width: 90,
                child: Row(
                  children: [
                    Text(
                      suraName,
                      style: const TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: blueColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700, // Text color
                      ),
                    ),
                  ],
                ),
              ),
              subtitle: Text(
                "$suraNameEnglishTranslated ($ayahCount)",
                style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(.8)),
              ),
              trailing: RichText(
                text: TextSpan(
                  text: suraNumber.toString(),
            
                  style: const TextStyle(
                    fontFamily: "arsura",
                    fontSize: 22,
                    color: Colors.black,
                  ),
                ),
              ),
            
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (builder) => QuranViewPage(
                          jsonData: surahs,
                          pageNumber: getPageNumber(suraNumberInQuran, 1),
                        ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
