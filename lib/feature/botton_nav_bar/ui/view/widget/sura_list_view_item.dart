import 'package:flutter/material.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/core/router/app_routes.dart';
import 'package:quran/quran.dart';

class SuraListViewItem extends StatelessWidget {
  const SuraListViewItem({
    super.key,
    required this.suraNumber,
    required this.suraName,
    required this.suraNameEnglishTranslated,
    required this.ayahCount,
    required this.suraNumberInQuran,
  });

  final int suraNumber;
  final String suraName;
  final String suraNameEnglishTranslated;
  final int ayahCount;
  final int suraNumberInQuran;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 45,
        height: 45,
        child: Center(
          child: Text(
            suraNumber.toString(),
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(fontSize: 14),
          ),
        ),
      ), //  Material(
      minVerticalPadding: 0,
      title: RichText(
        text: TextSpan(
          text: suraNumber.toString(),

          style: TextStyle(
            fontFamily: "arsura",
            fontSize: 30,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
      ),
      trailing: Text(
        "( $ayahCount ) ",
        style: context.textTheme.titleMedium!.copyWith(fontSize: 14),
      ),

      onTap: () async {
        Navigator.pushNamed(
          context,
          AppRoutes.quranViewRouter,
          arguments: {"pageNumber": getPageNumber(suraNumberInQuran, 1)},
        );
      },
    );
  }
}
