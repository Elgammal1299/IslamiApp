import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';

class DownloadModel {
  final String id;
  final String title;
  final String artist;
  final String url;
  final String localPath;
  final DateTime downloadedAt;
  final int fileSize; // in bytes

  DownloadModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.url,
    required this.localPath,
    required this.downloadedAt,
    required this.fileSize,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'artist': artist,
    'url': url,
    'localPath': localPath,
    'downloadedAt': downloadedAt.toIso8601String(),
    'fileSize': fileSize,
  };

  factory DownloadModel.fromJson(Map<String, dynamic> json) => DownloadModel(
    id: json['id'] as String,
    title: json['title'] as String,
    artist: json['artist'] as String,
    url: json['url'] as String,
    localPath: json['localPath'] as String,
    downloadedAt: DateTime.parse(json['downloadedAt'] as String),
    fileSize: json['fileSize'] as int,
  );
}

class DownloadModelAdapter extends TypeAdapter<DownloadModel> {
  @override
  final int typeId = 31; // Unique typeId for DownloadModel

  @override
  DownloadModel read(BinaryReader reader) {
    final id = reader.readString();
    final title = reader.readString();
    final artist = reader.readString();
    final url = reader.readString();
    final localPath = reader.readString();
    final downloadedAt = DateTime.parse(reader.readString());
    final fileSize = reader.readInt();

    return DownloadModel(
      id: id,
      title: title,
      artist: artist,
      url: url,
      localPath: localPath,
      downloadedAt: downloadedAt,
      fileSize: fileSize,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeString(obj.artist);
    writer.writeString(obj.url);
    writer.writeString(obj.localPath);
    writer.writeString(obj.downloadedAt.toIso8601String());
    writer.writeInt(obj.fileSize);
  }
}

class DownloadManager {
  static final DownloadManager _instance = DownloadManager._internal();
  final Dio _dio = Dio();
  CancelToken? _currentCancelToken;

  factory DownloadManager() {
    return _instance;
  }

  DownloadManager._internal();

  Future<bool> hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi);
  }

  Future<String> getDownloadsDirectory() async {
    final dir = await getApplicationDocumentsDirectory();
    final downloadsDir = Directory('${dir.path}/quran_downloads');
    if (!await downloadsDir.exists()) {
      await downloadsDir.create(recursive: true);
    }
    return downloadsDir.path;
  }

  Future<String> downloadFile({
    required String url,
    required String filename,
    required Function(int, int) onProgress,
    required Function(String) onError,
  }) async {
    try {
      // Check internet connection
      final hasConnection = await hasInternetConnection();
      if (!hasConnection) {
        onError('لا توجد اتصال بالإنترنت');
        throw Exception('No internet connection');
      }

      final downloadsDir = await getDownloadsDirectory();
      final filePath = '$downloadsDir/$filename.mp3';

      // Cancel any previous download
      _currentCancelToken?.cancel('Cancelled by user');
      _currentCancelToken = CancelToken();

      await _dio.download(
        url,
        filePath,
        cancelToken: _currentCancelToken,
        onReceiveProgress: (count, total) {
          onProgress(count, total);
        },
        options: Options(
          receiveTimeout: const Duration(seconds: 60),
          sendTimeout: const Duration(seconds: 60),
        ),
      );

      return filePath;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        onError('انتهت مهلة الاتصال');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        onError('انتهت مهلة التحميل');
      } else if (e.type == DioExceptionType.cancel) {
        onError('تم إلغاء التحميل');
      } else {
        onError('فشل التحميل: ${e.message}');
      }
      rethrow;
    } catch (e) {
      onError('خطأ غير متوقع: $e');
      rethrow;
    }
  }

  Future<bool> fileExists(String localPath) async {
    return File(localPath).exists();
  }

  Future<void> deleteFile(String localPath) async {
    final file = File(localPath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  int getFileSizeInBytes(String localPath) {
    final file = File(localPath);
    if (file.existsSync()) {
      return file.lengthSync();
    }
    return 0;
  }

  void cancelCurrentDownload() {
    _currentCancelToken?.cancel('Cancelled by user');
  }
}
