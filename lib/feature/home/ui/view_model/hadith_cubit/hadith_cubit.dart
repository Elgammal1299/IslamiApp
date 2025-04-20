import 'package:bloc/bloc.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/hadith.dart';
import 'package:islami_app/feature/botton_nav_bar/data/repo/hadith_repo.dart';
import 'package:islami_app/feature/home/data/model/hadith_model_item.dart';
import 'package:meta/meta.dart';

part 'hadith_state.dart';

class HadithCubit extends Cubit<HadithState> {
  final HadithRepo jsonRepository;
  HadithCubit(this.jsonRepository) : super(HadithInitial());

  void getHadith(HadithType type) async {
    emit(HadithLoading());
    try {
      List<HadithModel> hadiths;

      switch (type) {
        case HadithType.bukhari:
          hadiths = await jsonRepository.readJsonBukhari();
          break;
        case HadithType.muslim:
          hadiths = await jsonRepository.readJsonMuslim();
          break;
        case HadithType.abuDaud:
          hadiths = await jsonRepository.readJsonAbuDaud();
          break;
        case HadithType.tirmidzi:
          hadiths = await jsonRepository.readJsonTirmidzi();
          break;
        case HadithType.nasai:
          hadiths = await jsonRepository.readJsonNasai();
          break;
        case HadithType.ibnuMajah:
          hadiths = await jsonRepository.readJsonIbnuMajah();
          break;
        case HadithType.malik:
          hadiths = await jsonRepository.readJsonMalik();
          break;
        case HadithType.darimi:
          hadiths = await jsonRepository.readJsonDarimi();
          break;
        case HadithType.ahmed:
          hadiths = await jsonRepository.readJsonAhmed();
          break;
      }

      emit(HadithSuccess(hadiths));
    } catch (e) {
      emit(HadithError(e.toString()));
    }
  }
}



  // void getHadithAbuDaud() async {
  //   emit(HadithLoading());
  //   try {
  //     final surahs = await jsonRepository.readJsonAbuDaud();

  //     emit(HadithSuccess(surahs));
  //   } catch (e) {
  //     emit(HadithError(e.toString()));
  //   }
  // }

  // void getHadithAhmed() async {
  //   emit(HadithLoading());
  //   try {
  //     final surahs = await jsonRepository.readJsonAhmed();

  //     emit(HadithSuccess(surahs));
  //   } catch (e) {
  //     emit(HadithError(e.toString()));
  //   }
  // }

  // void getHadithBukhari() async {
  //   emit(HadithLoading());
  //   try {
  //     final surahs = await jsonRepository.readJsonBukhari();

  //     emit(HadithSuccess(surahs));
  //   } catch (e) {
  //     emit(HadithError(e.toString()));
  //   }
  // }

  // void getHadithIbnuMajah() async {
  //   emit(HadithLoading());
  //   try {
  //     final surahs = await jsonRepository.readJsonIbnuMajah();

  //     emit(HadithSuccess(surahs));
  //   } catch (e) {
  //     emit(HadithError(e.toString()));
  //   }
  // }

  // void getHadithMalik() async {
  //   emit(HadithLoading());
  //   try {
  //     final surahs = await jsonRepository.readJsonMalik();

  //     emit(HadithSuccess(surahs));
  //   } catch (e) {
  //     emit(HadithError(e.toString()));
  //   }
  // }

  // void getHadithMuslim() async {
  //   emit(HadithLoading());
  //   try {
  //     final surahs = await jsonRepository.readJsonMuslim();

  //     emit(HadithSuccess(surahs));
  //   } catch (e) {
  //     emit(HadithError(e.toString()));
  //   }
  // }

  // void getHadithNasai() async {
  //   emit(HadithLoading());
  //   try {
  //     final surahs = await jsonRepository.readJsonNasai();

  //     emit(HadithSuccess(surahs));
  //   } catch (e) {
  //     emit(HadithError(e.toString()));
  //   }
  // }

  // void getHadithTirmidzi() async {
  //   emit(HadithLoading());
  //   try {
  //     final surahs = await jsonRepository.readJsonTirmidzi();

  //     emit(HadithSuccess(surahs));
  //   } catch (e) {
  //     emit(HadithError(e.toString()));
  //   }
  // }

  // void getHadithdarimi() async {
  //   emit(HadithLoading());
  //   try {
  //     final surahs = await jsonRepository.readJsonDarimi();

  //     emit(HadithSuccess(surahs));
  //   } catch (e) {
  //     emit(HadithError(e.toString()));
  //   }
  // }

