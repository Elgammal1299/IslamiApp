import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as m;
import 'package:islami_app/feature/botton_nav_bar/ui/view/quran_page.dart';
import 'package:quran/quran.dart';

class CustomSurahFramWidget extends m.StatelessWidget {
  const CustomSurahFramWidget({
    super.key,
    required this.screenSize,
    required this.widget,
    required this.index,
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
            width: (screenSize.width * .30),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 24,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                Text(
                  widget.jsonData[getPageData(index)[0]["surah"] - 1].name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          EasyContainer(
            borderRadius: 12,
            color: Theme.of(context).secondaryHeaderColor,
            showBorder: true,
            height: 25,
            width: 120,
            padding: 0,
            margin: 0,
            child: Center(
              child: Text(
                "${"صفحة"} $index ",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
