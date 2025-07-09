import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/feature/home/ui/view/azkar/view/widget/custom_azkar_and_doa_ist.dart';
import 'package:islami_app/feature/home/ui/view/azkar/view_model/azkar_cubit/azkar_cubit.dart';

class AzkarScreen extends StatelessWidget {
  const AzkarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("📂 قائمة الأذكار")),
      body: BlocBuilder<AzkarCubit, AzkarState>(
        builder: (context, state) {
          if (state is AzkarLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AzkarLoaded) {
            final sections = state.sections;

            final allCategories =
                sections.expand((section) => section.categories).toList();

            return ListView.builder(
              itemCount: allCategories.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final category = allCategories[index];
                return CustomAzkarAndDoaList(category: category);
              },
            );
          } else {
            return const Center(child: Text("فشل في تحميل البيانات"));
          }
        },
      ),
    );
  }
}
