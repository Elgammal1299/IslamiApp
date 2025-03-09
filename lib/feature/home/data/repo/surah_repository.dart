
import 'package:islami_app/core/surah_db.dart';
import 'package:islami_app/feature/home/data/model/sura.dart';

class JsonRepository {
  final SurahJsonServer jsonServer;

  JsonRepository(this.jsonServer);
  Future<List<SurahModel>> readJson() async {
    try {
      return await jsonServer.readJson();
    } catch (e) {
      throw Exception(e);
    }
  }
}
