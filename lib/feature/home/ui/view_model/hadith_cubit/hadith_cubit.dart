
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/feature/home/data/model/hadith_model.dart';
import 'package:islami_app/feature/home/data/repo/hadith_repo.dart';

import 'package:equatable/equatable.dart';

part 'hadith_state.dart';

class HadithCubit extends Cubit<HadithState> {
  final HadithRepo jsonRepository;
  HadithCubit(this.jsonRepository) : super(HadithInitial());

  void getHadith(String name) async {
    emit(HadithLoading());
    final result = await jsonRepository.getHadith(name);
    result.fold(
      (l) => emit(HadithError(l.toString())),
      (r) => emit(HadithSuccess(r)),
    );
  }
}
