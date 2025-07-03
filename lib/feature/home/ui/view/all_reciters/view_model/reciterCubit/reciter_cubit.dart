import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/data/model/reciters_model.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/data/repo/reciters_repo.dart';

part 'reciter_state.dart';

class ReciterCubit extends Cubit<ReciterState> {
  final ReciterRepo repository;
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
