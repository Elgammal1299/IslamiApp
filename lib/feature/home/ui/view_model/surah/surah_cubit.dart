import 'package:bloc/bloc.dart';
import 'package:islami_app/feature/home/data/model/sura.dart';
import 'package:islami_app/feature/home/data/repo/surah_repository.dart';
import 'package:meta/meta.dart';

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

}
