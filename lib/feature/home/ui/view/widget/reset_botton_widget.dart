import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:islami_app/core/constant/app_color.dart';

class ResetBottonWidget extends StatelessWidget {
  const ResetBottonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Theme.of(context).primaryColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.refresh_rounded, color: AppColors.white, size: 24),
          const SizedBox(width: 8),
          Text(
            "إعادة التعيين",
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }
}
