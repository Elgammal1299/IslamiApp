import 'package:flutter/material.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/sura.dart';
import 'package:quran/quran.dart' show getVerseCount;

class HeaderWidget extends StatelessWidget {
  final dynamic e;
  final List<SurahModel> jsonData;

  const HeaderWidget({super.key, required this.e, required this.jsonData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              "assets/images/surah_fram.png",
              width: MediaQuery.of(context).size.width,
              height: 50,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.7, vertical: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  textAlign: TextAlign.center,
                  "اياتها\n${getVerseCount(e["surah"])}",
                  style: TextStyle(
                    fontSize: 7,
                    fontFamily: "UthmanicHafs13",
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: e["surah"].toString(),

                      // textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "arsura",
                        fontSize: 22,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ),
                ),
                Text(
                  "ترتيبها\n${e["surah"]}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 7,
                    fontFamily: "UthmanicHafs13",
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
