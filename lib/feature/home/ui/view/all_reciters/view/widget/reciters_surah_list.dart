import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islami_app/core/constant/app_image.dart';
import 'package:islami_app/core/helper/audio_manager.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/data/model/reciters_model.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view/widget/audio_app_wrapper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quran/quran.dart' as quran;

class RecitersSurahList extends StatefulWidget {
  final Moshaf moshaf;
  final String name;
  const RecitersSurahList({
    super.key,
    required this.moshaf,
    required this.name,
  });

  @override
  State<RecitersSurahList> createState() => _RecitersSurahListState();
}

class _RecitersSurahListState extends State<RecitersSurahList> {
  final audioManager = AudioManager();

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  Future<Uri> _copyAssetToTemp(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/${assetPath.split('/').last}');
    await file.writeAsBytes(data.buffer.asUint8List());
    return Uri.file(file.path);
  }

  Future<void> _initAudio() async {
    final artUri = await _copyAssetToTemp(AppImage.quranCoverImage);

    List<int> numberSurahList =
        (widget.moshaf.surahList ?? '')
            .split(",")
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .map(int.parse)
            .toList();

    List<MediaItem> playlist =
        numberSurahList.map((surahNumber) {
          final formattedNumber = surahNumber.toString().padLeft(3, '0');
          return MediaItem(
            id: '${widget.moshaf.server}$formattedNumber.mp3',
            title: quran.getSurahNameArabic(surahNumber),

            // genre: 'عبدالباسط',
            displayTitle: widget.name,
            // displayDescription: 'jhjhjhjh',
            displaySubtitle: '${widget.moshaf.name}',
            album: 'قرآن كريم',
            artist: '${widget.moshaf.name}',
            duration: const Duration(
              minutes: 5,
            ), // لو مش معروف، ممكن تسيبها null
            artUri: artUri,
            //      Uri.parse(
            //  'https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg', // صورة ثابتة مؤقتًا
            //     ),
          );
        }).toList();

    await audioManager.loadPlaylist(playlist);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: AudioAppWrapper(audioManager: audioManager));
  }
}
