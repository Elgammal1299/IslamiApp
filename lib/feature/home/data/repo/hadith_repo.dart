import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';

import 'package:islami_app/core/services/api/hadith_service.dart';
import 'package:islami_app/feature/home/data/model/hadith_model.dart';
import 'package:islami_app/feature/home/data/repo/hadith_repoo.dart';


class HadithRepo extends HadithRepoo {
  final Box<List> _hadithBox = Hive.box<List>('hadiths');

  @override
  Future<Either<Failure, List<HadithModel>>> getHadith(String endpoint) async {
    try {
      // نحاول نقرأ من Hive أولًا
      final cachedData = _hadithBox.get(endpoint);
      if (cachedData != null && cachedData.isNotEmpty) {
        final hadithList = cachedData.cast<HadithModel>();
 
        return Right(hadithList);
      }

      // لو مفيش بيانات مخزنة، نجيب من النت
      final hadithList = await HadithService.fetchHadiths(endpoint);
      if (hadithList.isNotEmpty) {
        await _hadithBox.put(endpoint, hadithList); 

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
