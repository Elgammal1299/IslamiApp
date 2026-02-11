import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/feature/home/ui/view/azkar/data/model/quran_dua_model.dart';
import 'package:islami_app/feature/home/ui/view/azkar/data/repo/quran_dua_repo.dart';

part 'quran_dua_state.dart';

class QuranDuaCubit extends Cubit<QuranDuaState> {
  QuranDuaCubit(this.repo) : super(QuranDuaInitial());

  final QuranDuaRepository repo;

  Timer? _timer;
  int _index = 0;
  List<QuranDuaModel> _list = [];

  Future<void> load() async {
    emit(QuranDuaLoading());

    try {
      _list = await repo.loadDuases();

      if (_list.isEmpty) return;

      _index = Random().nextInt(_list.length);

      emit(QuranDuaLoaded(_list, _index));

      _startTimer();
    } catch (e) {
      emit(QuranDuaError(e.toString()));
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 60), (_) {
      nextRandom();
    });
  }

  void nextRandom() {
    if (_list.isEmpty) return;

    final random = Random();
    int newIndex;

    do {
      newIndex = random.nextInt(_list.length);
    } while (newIndex == _index && _list.length > 1);

    _index = newIndex;

    emit(QuranDuaLoaded(_list, _index));
  }

  void nextManual() {
    nextRandom();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
