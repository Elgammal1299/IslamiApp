import 'package:flutter/material.dart';
import 'package:islami_app/core/constant/app_image.dart';

class Basmallah extends StatefulWidget {
  final int index;
  const Basmallah({super.key, required this.index});

  @override
  State<Basmallah> createState() => _BasmallahState();
}

class _BasmallahState extends State<Basmallah> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return SizedBox(
      width: screenSize.width,
      child: Padding(
        padding: EdgeInsets.only(
          left: (screenSize.width * .2),
          right: (screenSize.width * .2),
          bottom: 0,
          top: 0,
        ),
        child: Image.asset(
          AppImage.basmalaImage,
          color: Theme.of(context).primaryColorDark,
          width: MediaQuery.sizeOf(context).width * .4,
        ),
      ),
    );
  }
}
