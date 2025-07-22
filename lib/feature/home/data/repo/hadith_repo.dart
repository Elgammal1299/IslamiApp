import 'package:islami_app/core/services/api/download.dart';
import 'package:islami_app/core/services/api/hadith_db.dart';
import 'package:islami_app/feature/home/data/model/hadith.dart';

class HadithRepo {
  final HadithJsonServer jsonServer;

  HadithRepo(this.jsonServer);
  Future<List<HadithModel>> readJsonAbuDaud() async {
    try {
     return await GetData.getData();

      // return await jsonServer.readJsonAbuDaud();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<HadithModel>> readJsonBukhari() async {
    try {
      return await jsonServer.readJsonBukhari();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<HadithModel>> readJsonMuslim() async {
    try {
      return await jsonServer.readJsonMuslim();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<HadithModel>> readJsonAhmed() async {
    try {
      return await jsonServer.readJsonAhmed();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<HadithModel>> readJsonIbnuMajah() async {
    try {
      return await jsonServer.readJsonIbnuMajah();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<HadithModel>> readJsonNasai() async {
    try {
      return await jsonServer.readJsonNasai();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<HadithModel>> readJsonMalik() async {
    try {
      return await jsonServer.readJsonMalik();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<HadithModel>> readJsonDarimi() async {
    try {
      return await jsonServer.readJsonDarimi();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<HadithModel>> readJsonTirmidzi() async {
    try {
      return await jsonServer.readJsonTirmidzi();
    } catch (e) {
      throw Exception(e);
    }
  }
}
