import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/router/app_routes.dart';
import 'package:islami_app/feature/home/data/model/hadith_model_item.dart';
import 'package:islami_app/feature/home/ui/view_model/hadith_cubit/hadith_cubit.dart';

class HadithNameItem extends StatelessWidget {
  final HadithModelItem item;

  const HadithNameItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<HadithCubit>().getHadith(item.englishName);
        log("Selected Hadith: ${item.name}");
        Navigator.pushNamed(
          context,
          AppRoutes.hadithDetailsRouter,
          arguments: context.read<HadithCubit>(),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).secondaryHeaderColor,
            width: 1.5,
          ), // بني فاتح
        ),
        child: Row(
          children: [
            Icon(
              Icons.menu_book,
              size: 28,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
