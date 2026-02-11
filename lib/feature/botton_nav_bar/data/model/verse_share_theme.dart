import 'package:flutter/material.dart';

class VerseShareTheme {
  final Color backgroundColor;
  final Color primaryColor;
  final Color secondaryColor;
  final String name;

  const VerseShareTheme({
    required this.backgroundColor,
    required this.primaryColor,
    required this.secondaryColor,
    required this.name,
  });

  static const List<VerseShareTheme> themes = [
    VerseShareTheme(
      backgroundColor: Color(0xffFFF8EE),
      primaryColor: Colors.black,
      secondaryColor: Color(0xff2B6777),
      name: "الأصيل",
    ),
    VerseShareTheme(
      backgroundColor: Color(0xff1E1E1E),
      primaryColor: Colors.white,
      secondaryColor: Color(0xffD4AF37),
      name: "ليلي مذهب",
    ),
    VerseShareTheme(
      backgroundColor: Color(0xffFDF6E3),
      primaryColor: Color(0xff586E75),
      secondaryColor: Color(0xffB58900),
      name: "ورقي قديم",
    ),
    VerseShareTheme(
      backgroundColor: Color(0xffE0F2F1),
      primaryColor: Color(0xff004D40),
      secondaryColor: Color(0xff80CBC4),
      name: "تركواز هادئ",
    ),
    VerseShareTheme(
      backgroundColor: Color(0xffFFFDE7),
      primaryColor: Color(0xff3E2723),
      secondaryColor: Color(0xffFBC02D),
      name: "شمس الضحى",
    ),
    VerseShareTheme(
      backgroundColor: Color(0xffF3E5F5),
      primaryColor: Color(0xff4A148C),
      secondaryColor: Color(0xffCE93D8),
      name: "بنفسجي ملكي",
    ),
  ];
}
