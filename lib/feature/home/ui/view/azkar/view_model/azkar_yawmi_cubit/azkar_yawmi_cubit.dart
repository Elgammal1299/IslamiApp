import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/feature/home/ui/view/azkar/data/model/azkar_yawmi_model.dart';
import 'package:islami_app/feature/home/ui/view/azkar/data/repo/azkar_yawmi_repo.dart';

part 'azkar_yawmi_state.dart';

class AzkarYawmiCubit extends Cubit<AzkarYawmiState> {
  AzkarYawmiCubit(this.repository) : super(SupplicationInitial());
  final AzkarYawmiRepo repository;
  Future<void> loadSupplications() async {
    emit(SupplicationLoading());
    try {
      final data = await repository.loadSupplications();
      emit(SupplicationLoaded(data));
    } catch (e) {
      emit(SupplicationError('فشل تحميل الأذكار'));
    }
  }
}
