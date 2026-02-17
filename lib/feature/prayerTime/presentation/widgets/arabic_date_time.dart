import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ArabicDateTimeWidget extends StatefulWidget {
  const ArabicDateTimeWidget({super.key});

  @override
  State<ArabicDateTimeWidget> createState() => _ArabicDateTimeWidgetState();
}

class _ArabicDateTimeWidgetState extends State<ArabicDateTimeWidget> {
  late DateTime _now;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('d MMMM yyyy', 'ar').format(_now);
    final formattedTime = DateFormat('hh:mm a', 'ar').format(_now);

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
