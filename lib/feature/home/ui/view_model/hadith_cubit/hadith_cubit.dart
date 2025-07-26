import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/feature/home/data/model/hadith.dart';
import 'package:islami_app/feature/home/data/repo/hadith_repo.dart';
import 'package:islami_app/feature/home/data/model/hadith_model_item.dart';

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
  //     try {
  //       List<HadithModel> hadiths;

  //       final res = await jsonRepository.getHadith();

  // res.fold(
  //         (failure) {
  //           log("Error fetching hadith: ${failure.message}");
  //           emit(HadithError(failure.message));
  //         },
  //         (data) {
  //           hadiths = data;
  //         },
  //       );
  //       emit(HadithSuccess(hadiths));
  //     } catch (e) {
  //       log(e.toString());
  //       emit(HadithError(e.toString()));
  //     }
  //   }




  // void getHadithAbuDaud() async {
  //   emit(HadithLoading());
  //   try {
  //     final surahs = await jsonRepository.AbuDaud();

  //     emit(HadithSuccess(surahs));
  //   } catch (e) {
  //     emit(HadithError(e.toString()));
  //   }
  // }

  // void getHadithAhmed() async {
  //   emit(HadithLoading());
  //   try {
  //     final surahs = await jsonRepository.Ahmed();

  //     emit(HadithSuccess(surahs));
  //   } catch (e) {
  //     emit(HadithError(e.toString()));
  //   }
  // }

  // void getHadithBukhari() async {
  //   emit(HadithLoading());
  //   try {
  //     final surahs = await jsonRepository.Bukhari();

  //     emit(HadithSuccess(surahs));
  //   } catch (e) {
  //     emit(HadithError(e.toString()));
  //   }
  // }

  // void getHadithIbnuMajah() async {
  //   emit(HadithLoading());
  //   try {
  //     final surahs = await jsonRepository.IbnuMajah();

  //     emit(HadithSuccess(surahs));
  //   } catch (e) {
  //     emit(HadithError(e.toString()));
  //   }
  // }

  // void getHadithMalik() async {
  //   emit(HadithLoading());
  //   try {
  //     final surahs = await jsonRepository.Malik();

  //     emit(HadithSuccess(surahs));
  //   } catch (e) {
  //     emit(HadithError(e.toString()));
  //   }
  // }

  // void getHadithMuslim() async {
  //   emit(HadithLoading());
  //   try {
  //     final surahs = await jsonRepository.Muslim();

  //     emit(HadithSuccess(surahs));
  //   } catch (e) {
  //     emit(HadithError(e.toString()));
  //   }
  // }

  // void getHadithNasai() async {
  //   emit(HadithLoading());
  //   try {
  //     final surahs = await jsonRepository.Nasai();

  //     emit(HadithSuccess(surahs));
  //   } catch (e) {
  //     emit(HadithError(e.toString()));
  //   }
  // }

  // void getHadithTirmidzi() async {
  //   emit(HadithLoading());
  //   try {
  //     final surahs = await jsonRepository.Tirmidzi();

  //     emit(HadithSuccess(surahs));
  //   } catch (e) {
  //     emit(HadithError(e.toString()));
  //   }
  // }

  // void getHadithdarimi() async {
  //   emit(HadithLoading());
  //   try {
  //     final surahs = await jsonRepository.Darimi();

  //     emit(HadithSuccess(surahs));
  //   } catch (e) {
  //     emit(HadithError(e.toString()));
  //   }
  // }

