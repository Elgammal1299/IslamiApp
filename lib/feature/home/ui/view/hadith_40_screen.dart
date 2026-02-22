import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/feature/home/ui/view/widget/custom_hadith_40_list_view_item.dart';
import 'package:islami_app/feature/home/ui/view_model/hadith_40_cubit/hadith_40_cubit.dart';

class Hadith40Screen extends StatelessWidget {
  const Hadith40Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الأربعون نووية')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder<Hadith40Cubit, Hadith40State>(
          builder: (context, state) {
            if (state is Hadith40Success) {
              return ListView.builder(
                itemCount: state.hadiths.length,
                itemBuilder: (context, index) {
                  final model = state.hadiths[index];
                  return CustomHadith40ListViewItem(model: model);
                },
              );
            } else if (state is Hadith40Loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is Hadith40Error) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text("انتظار التحميل..."));
            }
          },
        ),
      ),
    );
  }
}
