
import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as m;
import 'package:islami_app/feature/home/ui/view/quran_page.dart';
import 'package:quran/quran.dart';

class CustomSurahFramWidget extends m.StatelessWidget {
  const CustomSurahFramWidget({
    super.key,
    required this.screenSize,
    required this.widget, required this.index,
  });

  final m.Size screenSize;
  final QuranViewPage widget;
  final int index;

  @override
  m.Widget build(m.BuildContext context) {
    return SizedBox(
      width: screenSize.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: (screenSize.width * .27),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 24,
                  ),
                ),
                Text(
                  widget
                      .jsonData[getPageData(
                            index,
                          )[0]["surah"] -
                          1]
                      .name,
                  style: const TextStyle(
                    fontFamily: "Taha",
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          EasyContainer(
            borderRadius: 12,
            color: Colors.orange.withOpacity(.5),
            showBorder: true,
            height: 20,
            width: 120,
            padding: 0,
            margin: 0,
            child: Center(
              child: Text(
                "${"page"} $index ",
                style: const TextStyle(
                  fontFamily: 'aldahabi',
                  fontSize: 12,
                ),
              ),
            ),
          ),
          SizedBox(
            width: (screenSize.width * .27),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.settings,
                    size: 24,
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
