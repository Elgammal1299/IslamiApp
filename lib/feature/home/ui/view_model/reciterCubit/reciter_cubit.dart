import 'package:bloc/bloc.dart';
import 'package:islami_app/feature/home/data/model/quran_audio_model.dart';
import 'package:islami_app/feature/home/data/repo/quran_audio_repo.dart';
import 'package:meta/meta.dart';

part 'reciter_state.dart';

class ReciterCubit extends Cubit<ReciterState> {
  final ReciterRepository repository;
  ReciterCubit(this.repository) : super(ReciterInitial());

  void fetchReciters() async {
    emit(ReciterLoading());
    final result = await repository.getReciters();
    result.fold(
      (error) => emit(ReciterError(error)),
      (data) => emit(ReciterLoaded(data)),
    );
  }

}
