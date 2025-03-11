import 'package:quran/quran.dart';
class AudioService {
  String getSurahAudio(int surahNumber, dynamic reciterIdentifier) {
    return getAudioURLBySurah(surahNumber, reciterIdentifier);
  }

  String getVerseAudio(int surahNumber, int verseNumber, dynamic reciterIdentifier) {
    return getAudioURLByVerse(surahNumber, verseNumber, reciterIdentifier);
  }
}
