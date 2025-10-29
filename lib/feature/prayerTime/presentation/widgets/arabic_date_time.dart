import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ArabicDateTimeWidget extends StatelessWidget {
  const ArabicDateTimeWidget({super.key});

  

  @override
  Widget build(BuildContext context) {
    
    final formattedDate = DateFormat('d MMMM yyyy', 'ar').format( DateTime.now());
    final formattedTime = DateFormat('hh:mm a', 'ar').format(DateTime.now());

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