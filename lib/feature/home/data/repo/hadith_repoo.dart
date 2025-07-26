import 'package:dartz/dartz.dart';
import 'package:islami_app/feature/home/data/model/hadith_model.dart';

abstract class HadithRepoo {
  Future<Either<Failure, List<HadithModel>>> getHadith(String endpoint);
}

class Failure {
  final String message;

  Failure(this.message);
}
