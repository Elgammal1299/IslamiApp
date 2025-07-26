import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:islami_app/core/services/api/download.dart';
import 'package:islami_app/core/services/api/hadith_db.dart';
import 'package:islami_app/feature/home/data/model/hadith.dart';
import 'package:islami_app/feature/home/data/repo/hadith_repoo.dart';

class HadithRepo extends HadithRepoo {
  final HadithJsonServer jsonServer;

  HadithRepo(this.jsonServer);

  // Future<List<HadithModel>> AbuDaud() async {
  //   try {
  //     log("xdasdasdasdas");

  //     return await GetData.getData(endpoint: "abu-daud");

  //     // return await jsonServer.readJsonAbuDaud();
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }

  // Future<List<HadithModel>> Bukhari() async {
  //   try {
  //     return await jsonServer.readJsonBukhari();
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }

  // Future<List<HadithModel>> Muslim() async {
  //   try {
  //     return await jsonServer.readJsonMuslim();
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }

  // Future<List<HadithModel>> Ahmed() async {
  //   try {
  //     return await jsonServer.readJsonAhmed();
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }

  // Future<List<HadithModel>> IbnuMajah() async {
  //   try {
  //     return await jsonServer.readJsonIbnuMajah();
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }

  // Future<List<HadithModel>> Nasai() async {
  //   try {
  //     return await jsonServer.readJsonNasai();
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }

  // Future<List<HadithModel>> Malik() async {
  //   try {
  //     return await jsonServer.readJsonMalik();
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }

  // Future<List<HadithModel>> Darimi() async {
  //   try {
  //     return await jsonServer.readJsonDarimi();
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }

  // Future<List<HadithModel>> Tirmidzi() async {
  //   try {
  //     return await jsonServer.readJsonTirmidzi();
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }

  @override
  Future<Either<Failure, List<HadithModel>>> getHadith(String endpoint) async {
    try {
      final hadithList = await HadithService.fetchHadiths(endpoint);
      if (hadithList.isNotEmpty) {
        return Right(hadithList);
      } else {
        return Left(Failure("No Hadith found for the given endpoint"));
      }
    } catch (e) {
      log("Error fetching Hadith: $e");
      return Left(Failure("Failed to fetch Hadith: $e"));
    }
  }
}
