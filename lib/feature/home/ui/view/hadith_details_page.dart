import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/feature/home/ui/view/widget/custom_hadith_cart_item.dart';
import 'package:islami_app/feature/home/ui/view_model/hadith_cubit/hadith_cubit.dart';

class HadithDetailsPage extends StatelessWidget {
  const HadithDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("حديث اليوم")),
      body: BlocBuilder<HadithCubit, HadithState>(
        buildWhen:
            (previous, current) =>
                current is HadithLoading ||
                current is HadithSuccess ||
                current is HadithError,

        builder: (context, state) {
          debugPrint("🎯 Current State============: $state");
          if (state is HadithLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HadithError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.black),
              ),
            );
          } else if (state is HadithSuccess) {
            // Assuming you have a list of hadiths in the state
            final hadiths = state.hadiths;

            return ListView.builder(
              itemCount: hadiths.length,
              itemBuilder: (context, index) {
                final hadith = hadiths[index];
                debugPrint("Hadith=======: $hadith");
                return CustomHadithCard(hadithModel: hadith);
              },
            );
          }
          return const SizedBox.shrink(); // Return an empty widget if no state matches
        },
      ),
    );
  }
}
