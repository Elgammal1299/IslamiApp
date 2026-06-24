import 'package:flutter/material.dart';
import 'package:qcf_quran_plus/qcf_quran_plus.dart';

class SurahListScreen extends StatefulWidget {
  final int initialSurah;

  const SurahListScreen({super.key, this.initialSurah = 1});

  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  late int _selectedSurah;

  @override
  void initState() {
    super.initState();
    _selectedSurah = widget.initialSurah;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: _selectedSurah,
            items: List.generate(114, (index) {
              int surahNum = index + 1;
              return DropdownMenuItem(
                value: surahNum,
                child: Text('سورة ${getSurahNameArabic(surahNum)}'),
              );
            }),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedSurah = value;
                });
              }
            },
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: QuranSurahListView(
          surahNumber: _selectedSurah,
          highlights: const [],
          fontSize: 24,
          isTajweed: true,
          isDarkMode: Theme.of(context).brightness == Brightness.dark,
          ayahBuilder: (context, surahNumber, verseNumber, pageNumber, othmanicText, isHighlighted, highlightColor) {
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.05),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('آية $verseNumber', style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 12)),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.copy, size: 18),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.share, size: 18),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: othmanicText,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
