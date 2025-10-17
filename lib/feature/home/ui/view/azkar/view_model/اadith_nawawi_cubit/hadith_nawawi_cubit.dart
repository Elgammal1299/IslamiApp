// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:islami_app/feature/home/ui/view/azkar/data/model/hadith_nawawi_model.dart';
// import 'package:islami_app/feature/home/ui/view/azkar/data/repo/hadith_nawawi_repo.dart';

// part 'hadith_nawawi_state.dart';

// class HadithNawawiCubit extends Cubit<HadithNawawiState> {
//   HadithNawawiCubit(this.hadithNawawiRepo) : super(HadithNawawiInitial());
//   final HadithNawawiRepo hadithNawawiRepo;
//   Future<void> getHadiths() async {
//     emit(HadithNawawiLoading());
//     try {
//       final hadiths = await hadithNawawiRepo.fetchNawawiHadiths();
//       emit(HadithNawawiLoaded(hadiths));
//     } catch (e) {
//       emit(HadithNawawiError(e.toString()));
//     }
//   }
// }
