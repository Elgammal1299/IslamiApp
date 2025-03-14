import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter/services.dart';

import 'package:islami_app/core/services/bookmark_manager.dart';

import 'package:islami_app/feature/home/data/model/tafsir_model.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view/tafsir_details_page.dart';
import 'package:quran/quran.dart';
import 'package:quran/quran.dart' as quran;
import 'package:quran/quran.dart' as Quran;
import 'package:share_plus/share_plus.dart';

class BottonSheetItem extends StatefulWidget {
  final int verse;
  final int surah;
  final int cumulativeNumber;
  const BottonSheetItem({
    super.key,
    required this.verse,
    required this.surah,
    required this.cumulativeNumber,
  });

  @override
  State<BottonSheetItem> createState() => _BottonSheetItemState();
}

class _BottonSheetItemState extends State<BottonSheetItem> {
  // int getCumulativeAyahNumber(int surahNumber, int ayahNumber) {
  //   int cumulativeNumber = 0;

  //   for (int i = 1; i < surahNumber; i++) {
  //     cumulativeNumber += Quran.getVerseCount(i);
  //   }

  //   return cumulativeNumber + ayahNumber;
  // }

  final List<Data> tafsirIdentifiers = [];
  late String audioURL;
  late AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    audioURL =
        "https://cdn.islamic.network/quran/audio/128/ar.alafasy/${widget.cumulativeNumber}.mp3";
    audioPlayer = AudioPlayer();
    debugPrint('$audioURL ==========');
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  m.Widget build(m.BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            trailing: Icon(Icons.play_arrow),
            title: Text(
              "استماع ",
              style: TextStyle(
                fontFamily: "arsura",
                fontSize: 20,
                color: Colors.black,
              ),
              textAlign: TextAlign.end,
            ),
            onTap: () {
              // await audioPlayer.play(UrlSource(audioURL));
              Navigator.pop(context);
              showModalBottomSheet(
                scrollControlDisabledMaxHeightRatio: 1,
                context: context,
                builder:
                    (_) => AudioBottomSheet(

                      audioUrl: audioURL,
                      ayah: quran.getVerse(widget.surah, widget.verse),
                    ),
              );
            },
          ),
          ListTile(
            trailing: Icon(Icons.menu_book),
            title: Text(
              "التفسير",
              style: TextStyle(
                fontFamily: "arsura",
                fontSize: 20,
                color: Colors.black,
              ),
              textAlign: TextAlign.end,
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => TafsirDetailsPage(
                        tafsirIdentifier: "ar.muyassar",
                        verse: widget.cumulativeNumber,
                        // getCumulativeAyahNumber(
                        //   widget.surah,
                        //   widget.verse,
                        // ),
                        text: quran.getVerse(widget.surah, widget.verse),
                      ),
                ),
              );
            },
          ),

          ListTile(
            trailing: const Icon(Icons.copy),
            title: const Text(
              'نسخ الآية',
              style: TextStyle(
                fontFamily: "arsura",
                fontSize: 20,
                color: Colors.black,
              ),
              textAlign: TextAlign.end,
            ),
            onTap: () {
              Clipboard.setData(
                ClipboardData(text: quran.getVerse(widget.surah, widget.verse)),
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('تم نسخ الآية')));
            },
          ),
          FutureBuilder<bool>(
            future: BookmarkManager.isBookmarked(widget.surah, widget.verse),
            builder: (context, snapshot) {
              bool isBookmarked = snapshot.data ?? false;
              return ListTile(
                trailing: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                ),
                title: Text(
                  isBookmarked ? 'إزالة من المفضلة' : 'إضافة إلى المفضلة',
                  style: TextStyle(
                    fontFamily: "arsura",
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.end,
                ),
                onTap: () async {
                  if (isBookmarked) {
                    await BookmarkManager.removeBookmark(
                      widget.surah,
                      widget.verse,
                    );
                  } else {
                    await BookmarkManager.addBookmark(
                      widget.surah,
                      widget.verse,
                    );
                  }
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isBookmarked
                            ? 'تم إزالة الآية من المفضلة'
                            : 'تمت إضافة الآية إلى المفضلة',
                      ),
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            trailing: const Icon(Icons.share),
            title: const Text(
              'مشاركة الآية',
              style: TextStyle(
                fontFamily: "arsura",
                fontSize: 20,
                color: Colors.black,
              ),
              textAlign: TextAlign.end,
            ),
            onTap: () {
              Share.share(
                '${getVerse(widget.surah, widget.verse)}\n\n'
                'سورة ${getSurahNameArabic(widget.surah)} - آية ${widget.verse}',
              );

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class AudioBottomSheet extends StatefulWidget {
  final String audioUrl;
  final String ayah;
  const AudioBottomSheet({
    super.key,
    required this.audioUrl,
    required this.ayah,
  });

  @override
  _AudioBottomSheetState createState() => _AudioBottomSheetState();
}

class _AudioBottomSheetState extends State<AudioBottomSheet> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    // الاستماع لتغير مدة التشغيل الكلية
    _audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        _duration = newDuration;
      });
    });

    // الاستماع لتغير مدة التشغيل الحالية
    _audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        _position = newPosition;
      });
    });

    // يمكنك الاستماع لإنهاء التشغيل إذا أردت
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying = false;
        _position = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlay() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(widget.audioUrl));
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _seekTo(double seconds) {
    final newPosition = Duration(seconds: seconds.toInt());
    _audioPlayer.seek(newPosition);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            color: Colors.grey[200],
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                textDirection: TextDirection.rtl,

                widget.ayah,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
          // زر التشغيل/الإيقاف المؤقت
          IconButton(
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, size: 36),
            onPressed: _togglePlay,
          ),
          // شريط التمرير الذي يعرض حالة التشغيل ويسمح بالتقديم أو التأخير
          Slider(
            min: 0,
            max: _duration.inSeconds.toDouble(),
            value: _position.inSeconds.toDouble().clamp(
              0,
              _duration.inSeconds.toDouble(),
            ),
            onChanged: (value) {
              _seekTo(value);
            },
          ),
          // عرض الوقت الحالي والمدى الكلي
          Text(
            "${_formatDuration(_position)} / ${_formatDuration(_duration)}",
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  // دالة لتنسيق مدة التشغيل في شكل hh:mm:ss
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return hours > 0
        ? "${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}"
        : "${twoDigits(minutes)}:${twoDigits(seconds)}";
  }
}
