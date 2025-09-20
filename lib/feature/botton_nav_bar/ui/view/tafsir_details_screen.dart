import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/core/widget/error_widget.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/tafsir_cubit/tafsir_cubit.dart';

class TafsirDetailsScreen extends StatefulWidget {
  final String tafsirIdentifier;
  final int verse;
  final String text;

  const TafsirDetailsScreen({
    super.key,
    required this.verse,
    required this.text,
    required this.tafsirIdentifier,
  });

  @override
  _TafsirDetailsScreenState createState() => _TafsirDetailsScreenState();
}

class _TafsirDetailsScreenState extends State<TafsirDetailsScreen> {
  @override
  void initState() {
    context.read<TafsirCubit>().fetchAyahTafsir(
      widget.verse.toString(),
      widget.tafsirIdentifier,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("تفسير الآية")),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Card(
                  color: Theme.of(context).cardColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      textDirection: TextDirection.rtl,

                      widget.text,
                      style: context.textTheme.titleLarge,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),

                // 🔍 عرض التفسير
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              SliverToBoxAdapter(
                child: BlocBuilder<TafsirCubit, TafsirByAyahState>(
                  builder: (context, state) {
                    if (state is TafsirByAyahError) {
                      return customErrorWidget(
                        onPressed: () {
                          context.read<TafsirCubit>().fetchAyahTafsir(
                            widget.verse.toString(),
                            widget.tafsirIdentifier,
                          );
                        },
                      );
                    } else if (state is TafsirByAyahLoaded) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.justify,
                          state.tafsirByAyah.data!.text.toString(),
                          style: context.textTheme.titleLarge,
                          // textAlign: TextAlign.justify,
                        ),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
