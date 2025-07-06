import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/feature/home/ui/view/azkar/data/model/section_model.dart';
import 'package:islami_app/feature/home/ui/view/azkar/data/repo/azkar_repo.dart';

part 'azkar_state.dart';

class AzkarCubit extends Cubit<AzkarState> {
  AzkarCubit(this._repository) : super(AzkarInitial());
  final AzkarRepo _repository;
  Future<void> loadAzkar() async {
    emit(AzkarLoading());
    try {
      final sections = await _repository.loadSections();
      emit(AzkarLoaded(sections));
    } catch (e) {
      emit(AzkarError(e.toString()));
    }
  }
}
