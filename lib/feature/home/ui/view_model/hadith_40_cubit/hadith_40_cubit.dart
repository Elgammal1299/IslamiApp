import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/feature/home/data/model/hadith_40_model.dart';
import 'package:islami_app/feature/home/data/repo/hadith_40_repo.dart';

abstract class Hadith40State {}

class Hadith40Initial extends Hadith40State {}

class Hadith40Loading extends Hadith40State {}

class Hadith40Success extends Hadith40State {
  final List<Hadith40Model> hadiths;
  Hadith40Success(this.hadiths);
}

class Hadith40Error extends Hadith40State {
  final String message;
  Hadith40Error(this.message);
}

class Hadith40Cubit extends Cubit<Hadith40State> {
  final Hadith40Repo _repo;
  Hadith40Cubit(this._repo) : super(Hadith40Initial());

  Future<void> loadHadiths() async {
    emit(Hadith40Loading());
    try {
      final hadiths = await _repo.getHadith40();
      emit(Hadith40Success(hadiths));
    } catch (e) {
      emit(Hadith40Error(e.toString()));
    }
  }
}
