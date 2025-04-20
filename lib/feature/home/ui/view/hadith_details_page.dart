import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/feature/home/ui/view/widget/hadith_cart_item.dart';
import 'package:islami_app/feature/home/ui/view_model/hadith_cubit/hadith_cubit.dart';

class HadithDetailsPage extends StatelessWidget {
  const HadithDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            "حديث اليوم",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<HadithCubit, HadithState>(
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
                      style: const TextStyle(color: Colors.red),
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
                      return HadithCard(hadithModel: hadith);
                    },
                  );
                }
                return SizedBox.shrink(); // Return an empty widget if no state matches
              },
            ),
          ),
        ],
      ),
    );
  }
}
