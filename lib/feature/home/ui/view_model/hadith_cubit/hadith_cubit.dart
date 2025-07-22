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

  void getHadith(HadithType type) async {
    emit(HadithLoading());
    try {
      List<HadithModel> hadiths;

      switch (type) {
        case HadithType.bukhari:
          hadiths = await jsonRepository.Bukhari();
          break;
        case HadithType.muslim:
          hadiths = await jsonRepository.Muslim();
          break;
        case HadithType.abuDaud:
          hadiths = await jsonRepository.AbuDaud();
          break;
        case HadithType.tirmidzi:
          hadiths = await jsonRepository.Tirmidzi();
          break;
        case HadithType.nasai:
          hadiths = await jsonRepository.Nasai();
          break;
        case HadithType.ibnuMajah:
          hadiths = await jsonRepository.IbnuMajah();
          break;
        case HadithType.malik:
          hadiths = await jsonRepository.Malik();
          break;
        case HadithType.darimi:
          hadiths = await jsonRepository.Darimi();
          break;
        case HadithType.ahmed:
          hadiths = await jsonRepository.Ahmed();
          break;
      }

      emit(HadithSuccess(hadiths));
    } catch (e) {
      log(e.toString());
      emit(HadithError(e.toString()));
    }
  }
}



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

