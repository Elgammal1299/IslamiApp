import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/feature/home/ui/view/azkar/view/widget/custom_azkar_yawmi_list_view_item.dart';
import 'package:islami_app/feature/home/ui/view/azkar/view_model/azkar_yawmi_cubit/azkar_yawmi_cubit.dart';

class AzkarYawmiScreen extends StatelessWidget {
  const AzkarYawmiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الأذكار')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder<AzkarYawmiCubit, AzkarYawmiState>(
          builder: (context, state) {
            if (state is SupplicationLoaded) {
              final keys = state.data.keys.toList();

              return ListView.builder(
                itemCount: keys.length,
                itemBuilder: (context, index) {
                  final category = keys[index];
                  final items = state.data[category]!;

                  return CustomAzkarYawmiListViewItem(
                    items: items,
                    category: category,
                  );
                },
              );
            } else if (state is SupplicationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: Text("فشل التحميل"));
            }
          },
        ),
      ),
    );
  }
}
