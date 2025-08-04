// import 'package:flutter/material.dart';
// import 'package:islami_app/feature/home/ui/view/audio_player_page.dart';

// class SurahListPage extends StatelessWidget {
//   final List<Map<String, dynamic>> surahs = [
//     {
//       "name": "سورة الفاتحة",
//       "audioUrls": ["https://example.com/fatiha.mp3"],
//     },
//     {
//       "name": "سورة البقرة",
//       "audioUrls": ["https://example.com/baqara.mp3"],
//     },
//     // أضف باقي السور هنا
//   ];

//   // const SurahListPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Colors.purple.shade900,
//               Colors.blue.shade900,
//               Colors.black,
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               // عنوان الصفحة
//               Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Text(
//                   "القرآن الكريم",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),

//               // قائمة السور
//               Expanded(
//                 child: ListView.builder(
//                   padding: EdgeInsets.symmetric(horizontal: 16),
//                   itemCount: surahs.length,
//                   itemBuilder: (context, index) {
//                     return Container(
//                       margin: EdgeInsets.only(bottom: 12),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.purple.withValues(alpha:0.2),
//                             Colors.blue.withValues(alpha:0.2),
//                           ],
//                         ),
//                         borderRadius: BorderRadius.circular(15),
//                         border: Border.all(
//                           color: Colors.white.withValues(alpha:0.2),
//                           width: 1,
//                         ),
//                       ),
//                       child: ListTile(
//                         contentPadding: EdgeInsets.symmetric(
//                           horizontal: 20,
//                           vertical: 8,
//                         ),
//                         title: Row(
//                           children: [
//                             // رقم السورة
//                             Container(
//                               width: 40,
//                               height: 40,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 border: Border.all(
//                                   color: Colors.white.withValues(alpha:0.5),
//                                 ),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   "${index + 1}",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 16),
//                             // اسم السورة
//                             Expanded(
//                               child: Text(
//                                 surahs[index]["name"],
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 20,
//                                 ),
//                               ),
//                             ),
//                             // زر الصوت
//                             Container(
//                               width: 45,
//                               height: 45,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.white.withValues(alpha:0.1),
//                               ),
//                               child: IconButton(
//                                 icon: Icon(
//                                   Icons.play_arrow,
//                                   color: Colors.white,
//                                 ),
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => AudioPlayerPage(

//                                         ),
//                                       ),

//                                   );
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
