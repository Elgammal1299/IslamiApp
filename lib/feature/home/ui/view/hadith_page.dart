import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/router/app_routes.dart';
import 'package:islami_app/feature/home/data/model/hadith_model_item.dart';
import 'package:islami_app/feature/home/ui/view_model/hadith_cubit/hadith_cubit.dart';

class HadithPage extends StatelessWidget {
  const HadithPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('احاديث نبوية')),
      body: ListView.builder(
        itemCount: hadithItems.length,
        itemBuilder: (context, index) {
          return HadithNameItem(item: hadithItems[index]);
        },
      ),
    );
  }
}

class HadithNameItem extends StatelessWidget {
  final HadithModelItem item;

  const HadithNameItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<HadithCubit>().getHadith(item.type);
        Navigator.pushNamed(
          context,
          AppRoutes.hadithDetailsRouter,
          arguments: context.read<HadithCubit>(),
        );
      },
      child: Container(
        height: 150,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.yellow[50],
          border: Border.all(color: Colors.yellow[700]!, width: 2),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
