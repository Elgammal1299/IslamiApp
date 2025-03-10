// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:islami_app/feature/home/data/model/tafsir_model.dart';
// import 'package:islami_app/feature/home/ui/view/TafsirDetailsScreentest.dart';
// import 'package:islami_app/feature/home/ui/view_model/tafsir_cubit/tafsir_cubit.dart';

// class QuranScreen extends StatefulWidget {
//   @override
//   _QuranScreenState createState() => _QuranScreenState();
// }

// class _QuranScreenState extends State<QuranScreen> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<TafsirCubit>().fetchTafsirEditions(); // تحميل التفسيرات عند فتح الشاشة
//     context.read<TafsirCubit>().fetchTafsirEditions(); // تحميل التفسيرات عند فتح الشاشة
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("التفاسير", style: TextStyle(fontWeight: FontWeight.bold))),
//       body: BlocBuilder<TafsirCubit, TafsirState>(
//         builder: (context, state) {
//           if (state is TafsirLoading) {
//             return Center(child: CircularProgressIndicator());
//           } else if (state is TafsirError) {
//             return Center(child: Text("حدث خطأ: ${state.message}", style: TextStyle(color: Colors.red)));
//           } else if (state is TafsirEditionsLoaded) {
//             return _buildTafsirList(state.tafsirModel);
//           }
//           return Center(child: Text("اضغط على زر التحديث لجلب البيانات"));
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => context.read<TafsirCubit>().fetchTafsirEditions(),
//         child: Icon(Icons.refresh),
//       ),
//     );
//   }

//   Widget _buildTafsirList(TafsirModel tafsirModel) {
//     return ListView.builder(
//       padding: EdgeInsets.all(10),
//       itemCount: tafsirModel.data!.length,
//       itemBuilder: (context, index) {
//         final tafsir = tafsirModel.data![index];

//         return Card(
//           elevation: 3,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//           child: ListTile(
//             title: Text(tafsir.name.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
//             subtitle: Text(tafsir.englishName.toString()),
//             trailing: Icon(Icons.arrow_forward),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => TafsirDetailsScreen(),
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }
