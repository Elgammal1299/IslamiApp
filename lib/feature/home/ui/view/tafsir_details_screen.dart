import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/feature/home/ui/view_model/tafsir_cubit/tafsir_cubit.dart';

class TafsirDetailsScreen extends StatelessWidget {
  final String ayahId;
  final String tafsirId;
  final String ayahText;

  const TafsirDetailsScreen({super.key, 
    required this.ayahId,
    required this.tafsirId,
    required this.ayahText,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TafsirCubit>();
    cubit.fetchAyahTafsir(ayahId, tafsirId); // جلب التفسير عند فتح الصفحة

    return Scaffold(
      appBar: AppBar(title: Text("التفسير")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<TafsirCubit, TafsirState>(
          builder: (context, state) {
            if (state is TafsirLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is TafsirError) {
              return Center(child: Text("حدث خطأ أثناء تحميل التفسير"));
            } else if (state is AyahTafsirLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "الآية:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    ayahText,
                    style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                  Divider(thickness: 2, height: 30),
                  Text(
                    "التفسير:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        state.tafsirByAyah.data!.text ??'',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              );
            }
            return Center(child: Text("اختر تفسيرًا لعرضه"));
          },
        ),
      ),
    );
  }
}
