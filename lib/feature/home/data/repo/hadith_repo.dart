import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';

import 'package:islami_app/core/services/api/hadith_service.dart';
import 'package:islami_app/feature/home/data/model/hadith_model.dart';
import 'package:islami_app/feature/home/data/repo/hadith_repoo.dart';

class HadithRepo extends HadithRepoo {
  final Box<List> _hadithBox = Hive.box<List>('hadiths');

  @override
  //* Fetches a list of Hadiths from the given endpoint.
  //* If the Hadiths are cached in Hive, it will return the cached data. Otherwise,
  //* it will fetch the data from the API and store it in Hive before returning it.
  //* If there is an error fetching the data, it will return a Left containing the
  //! error message.
  //* If no Hadiths are found for the given endpoint, it will return a Left with
  //* the message "No Hadith found for the given endpoint".
  Future<Either<Failure, List<HadithModel>>> getHadith(String endpoint) async {
    try {
  //* Check if Hadiths are cached in Hive
      final cachedData = _hadithBox.get(endpoint);
      if (cachedData != null && cachedData.isNotEmpty) {
        final hadithList = cachedData.cast<HadithModel>();

        return Right(hadithList);
      }

      //* Fetch Hadiths from the API
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
