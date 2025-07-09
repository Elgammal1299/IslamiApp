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
      backgroundColor: const Color(0xFFFFF8F0), // خلفية الصفحة بيج هادي
      appBar: AppBar(
        title: const Text(
          'أحاديث نبوية',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4E342E), // بني غامق
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
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
    return InkWell(
      onTap: () {
        context.read<HadithCubit>().getHadith(item.type);
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
          color: const Color(0xFFFFFFFF), // أبيض للكارت
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Color(0xFFE0C097), width: 1.5), // بني فاتح
          boxShadow: [
            BoxShadow(
              color: const Color(0x33000000), // ظل خفيف (20% شفاف)
              blurRadius: 6,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.menu_book, size: 28, color: Color(0xFF4E342E)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4E342E), // بني غامق
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
