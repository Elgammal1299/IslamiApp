import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/feature/home/data/model/hadith_model.dart';
import 'package:islami_app/feature/home/data/repo/hadith_repo.dart';

import 'package:equatable/equatable.dart';

part 'hadith_state.dart';

class HadithCubit extends Cubit<HadithState> {
  final HadithRepo jsonRepository;
  HadithCubit(this.jsonRepository) : super(HadithInitial());

  void getHadith(String name) async {
    if (!isClosed) emit(HadithLoading());
    final result = await jsonRepository.getHadith(name);
    if (isClosed) return;
    result.fold(
      (l) {
        if (!isClosed) emit(HadithError(l.toString()));
      },
      (r) {
        if (!isClosed) emit(HadithSuccess(r));
      },
    );
  }
}
