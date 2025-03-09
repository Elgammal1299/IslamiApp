import 'package:bloc/bloc.dart';
import 'package:islami_app/feature/home/data/model/sura.dart';
import 'package:islami_app/feature/home/data/repo/surah_repository.dart';
import 'package:meta/meta.dart';
import 'package:quran/quran.dart';
import 'package:share_plus/share_plus.dart';
part 'surah_state.dart';

class SurahCubit extends Cubit<SurahState> {
  final JsonRepository jsonRepository;
  SurahCubit(this.jsonRepository) : super(SurahInitial());

  void getSurahs() async {
    emit(SurahLoading());
    try {
    final  surahs = await jsonRepository.readJson();

      emit(SurahSuccess(surahs));
    } catch (e) {
      emit(SurahError(e.toString()));
    }
  }
  

Future<void> shareSurah(int surahNumber, String surahName) async {
    try {
      String surahText = '';
      int versesCount = getVerseCount(surahNumber);
      
      // تجميع نص السورة
      surahText = 'سورة $surahName\n\n';
      for (int i = 1; i <= versesCount; i++) {
        surahText += '${getVerse(surahNumber, i)} (${i.toString()})\n';
      }
      
      // إضافة رابط التطبيق (اختياري)
      surahText += '\nمشاركة من تطبيق إسلامي';
      
      await Share.share(surahText);
    } catch (e) {
      emit(SurahError(e.toString()));
    }
  }

  // دالة لمشاركة آية محددة
  Future<void> shareVerse(int surahNumber, int verseNumber, String surahName) async {
    try {
      String verseText = getVerse(surahNumber, verseNumber);
      String shareText = 'سورة $surahName - الآية $verseNumber\n\n$verseText';
      
      await Share.share(shareText);
    } catch (e) {
      emit(SurahError(e.toString()));
    }
  }
}



