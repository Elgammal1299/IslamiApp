import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/feature/home/ui/view/azkar/data/model/azkar_random_model.dart';
import 'package:islami_app/feature/home/ui/view/azkar/data/repo/azkar_random_repo.dart';

part 'azkar_random_state.dart';

class AzkarRandomCubit extends Cubit<AzkarRandomState> {
  AzkarRandomCubit(this.repository) : super(AzkarRandomInitial());
  final AzkarRandomRepo repository;
  Timer? _timer;
  List<AzkarRandomModel> _adhkar = [];
  int _currentIndex = 0;

  Future<void> loadAdhkar() async {
    emit(DikrLoading());

    try {
      _adhkar = await repository.loadAdhkarFromAssets();
      _currentIndex = 0;
      emit(AzkarRandomLoaded(_adhkar[_currentIndex]));

      _timer = Timer.periodic(const Duration(seconds: 10), (_) {
        _currentIndex = (_currentIndex + 1) % _adhkar.length;
        emit(AzkarRandomLoaded(_adhkar[_currentIndex]));
      });
    } catch (e) {
      emit(AzkarRandomError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void nextDikr() {
    if (_adhkar.isEmpty) return;
    _currentIndex = (_currentIndex + 1) % _adhkar.length;
    emit(AzkarRandomLoaded(_adhkar[_currentIndex]));
  }

  void previousDikr() {
    if (_adhkar.isEmpty) return;
    _currentIndex = (_currentIndex - 1 + _adhkar.length) % _adhkar.length;
    emit(AzkarRandomLoaded(_adhkar[_currentIndex]));
  }
}
