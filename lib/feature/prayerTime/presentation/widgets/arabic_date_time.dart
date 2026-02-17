import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ArabicDateTimeWidget extends StatefulWidget {
  const ArabicDateTimeWidget({super.key});

  @override
  State<ArabicDateTimeWidget> createState() => _ArabicDateTimeWidgetState();
}

class _ArabicDateTimeWidgetState extends State<ArabicDateTimeWidget> {
  late String formattedDate, formattedTime;
  @override
  void initState() {
    formattedDate = DateFormat('d MMMM yyyy', 'ar').format(DateTime.now());
    formattedTime = DateFormat('hh:mm a', 'ar').format(DateTime.now());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$formattedDate - $formattedTime',
      style: const TextStyle(
        fontSize: 20,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    );
  }
}
