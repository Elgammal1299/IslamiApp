import 'package:dartz/dartz.dart';
import 'package:islami_app/core/services/api/hadith_service.dart';
import 'package:islami_app/core/services/hive_service.dart';
import 'package:islami_app/feature/home/data/model/hadith_model.dart';
import 'package:islami_app/feature/home/data/repo/hadith_repoo.dart';

class HadithRepo implements HadithRepoo {
  final HiveService<List> _hadithService = HiveService.instanceFor<List>(
    boxName: 'hadiths',
    enableLogging: true,
  );

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
      // Ensure the service is initialized
      if (!_hadithService.isOpen) {
        await _hadithService.init();
      }

      //* Check if Hadiths are cached in Hive
      final cachedData = _hadithService.get(endpoint);
      if (cachedData != null && cachedData.isNotEmpty) {
        final hadithList = cachedData.cast<HadithModel>();
        return Right(hadithList);
      }

      //* Fetch Hadiths from the API
      final hadithList = await HadithService.fetchHadith(endpoint);
      if (hadithList.isNotEmpty) {
        await _hadithService.put(endpoint, hadithList);
        return Right(hadithList);
      } else {
        return Left(Failure("No Hadith found for the given endpoint"));
      }
    } catch (e) {
      return Left(Failure("Failed to fetch Hadith: $e"));
    }
  }
}
