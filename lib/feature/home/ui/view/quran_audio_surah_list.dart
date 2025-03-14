
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:islami_app/feature/home/ui/view/audio_player_page.dart';

class QuranAudioSurahList extends StatelessWidget {
  static const String routeName = '/quran-surah-list';
   QuranAudioSurahList({super.key});

  final List<Map<String, dynamic>> surahs = [
    {
      'name': 'الفاتحة',
      'number': 1,
      'imageUrl': 'assets/images/quran3.png',
    },
    {
      'name': 'البقرة',
      'number': 2,
      'imageUrl': 'assets/images/quran3.png',
    },
     {
      'name': 'ال عمران',
      'number': 3,
      'imageUrl': 'assets/images/quran3.png',
    },
    {
      'name': 'النساء',
      'number': 4,
      'imageUrl': 'assets/images/quran3.png',
    },
      {
      'name': 'المائدة',
      'number': 5,
      'imageUrl': 'assets/images/quran3.png',
    },
    {
      'name': 'الانعام',
      'number': 6,
      'imageUrl': 'assets/images/quran3.png',
    },
     {
      'name': 'الاعراف',
      'number': 7,
      'imageUrl': 'assets/images/quran3.png',
    },
    {
      'name': 'الانفال',
      'number': 8,
      'imageUrl': 'assets/images/quran3.png',
    },
    // أضف باقي السور هنا
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'سور القرآن الكريم',
          style: TextStyle(
            fontSize: 24,

            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey,
              Colors.grey,
              Colors.grey,
            ],
          ),
        ),
        child: GridView.builder(
          padding: EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: surahs.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AudioPlayerPage.routeName,
                  arguments: {
                    'surahIndex': index,
                    'surahName': surahs[index]['name'],
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors:
                             [
                              Colors.black87,
                              Colors.white,
                            ],
                          ),
                        ),
                      ),
                      
                      Image.asset(
                        surahs[index]['imageUrl'],
                        fit: BoxFit.contain,
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Container(
                          decoration: BoxDecoration(

                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors:
                             [
                              Colors.white,
                              Colors.transparent,
                              Colors.white70,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                
                                surahs[index]['name'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // SizedBox(height: 4),
                              Text(
                                'سورة ${surahs[index]['number']}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
