import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AzanItem extends StatelessWidget {
  final String name;
  final DateTime time;

  const AzanItem({super.key, required this.name, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('hh:mm a', 'ar').format(time),
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
