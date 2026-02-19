import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAzkarStatusWidget extends StatelessWidget {
  final bool isFinished;

  const CustomAzkarStatusWidget({super.key, required this.isFinished});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'وَارْتَقِ ',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontSize: 22.sp,
            fontFamily: 'Amiri',
            color: isFinished ? Colors.green : null,
            fontWeight: isFinished ? FontWeight.bold : null,
          ),
        ),
        if (isFinished)
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
      ],
    );
  }
}
