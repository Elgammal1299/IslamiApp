import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:islami_app/core/services/hive_service.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/data/model/download_model.dart';

part 'download_state.dart';

class DownloadCubit extends Cubit<DownloadState> {
  final DownloadManager _downloadManager;
  final HiveService<DownloadModel> _hiveService;

  DownloadCubit(this._downloadManager, this._hiveService)
    : super(const DownloadInitial()) {
    _loadDownloadedFiles();
  }

  List<DownloadModel> _downloadedFiles = [];

  void _loadDownloadedFiles() async {
    try {
      final files = await _hiveService.getAll();
      _downloadedFiles = files;
      emit(DownloadLoaded(_downloadedFiles));
    } catch (e) {
      print('Error loading downloads: $e');
    }
  }

  Future<void> downloadAudio({
    required String id,
    required String title,
    required String artist,
    required String url,
  }) async {
    try {
      // Check if already downloaded
      if (_isAlreadyDownloaded(id)) {
        emit(const DownloadAlreadyExists('هذا الملف محمل بالفعل'));
        return;
      }

      emit(DownloadInProgress(id: id, progress: 0, total: 1));

      final filePath = await _downloadManager.downloadFile(
        url: url,
        filename: id,
        onProgress: (count, total) {
          if (!isClosed) {
            emit(DownloadInProgress(id: id, progress: count, total: total));
          }
        },
        onError: (error) {
          if (!isClosed) {
            emit(DownloadFailed(id: id, error: error));
          }
        },
      );

      // Get file size
      final fileSize = _downloadManager.getFileSizeInBytes(filePath);

      // Create download model
      final downloadModel = DownloadModel(
        id: id,
        title: title,
        artist: artist,
        url: url,
        localPath: filePath,
        downloadedAt: DateTime.now(),
        fileSize: fileSize,
      );

      // Save to Hive
      await _hiveService.put(id, downloadModel);
      _downloadedFiles.add(downloadModel);

      if (!isClosed) {
        emit(DownloadCompleted(downloadModel));
        emit(DownloadLoaded(_downloadedFiles));
      }
    } catch (e) {
      if (!isClosed) {
        emit(DownloadFailed(id: id, error: 'فشل التحميل: ${e.toString()}'));
      }
    }
  }

  Future<void> deleteDownload(String id) async {
    try {
      final download = _downloadedFiles.firstWhere((d) => d.id == id);
      await _downloadManager.deleteFile(download.localPath);
      await _hiveService.delete(id);
      _downloadedFiles.removeWhere((d) => d.id == id);
      emit(DownloadDeleted(id));
      emit(DownloadLoaded(_downloadedFiles));
    } catch (e) {
      print('Error deleting download: $e');
    }
  }

  Future<void> deleteAllDownloads() async {
    try {
      for (var download in _downloadedFiles) {
        await _downloadManager.deleteFile(download.localPath);
        await _hiveService.delete(download.id);
      }
      _downloadedFiles.clear();
      emit(DownloadLoaded(_downloadedFiles));
    } catch (e) {
      print('Error deleting all downloads: $e');
    }
  }

  bool _isAlreadyDownloaded(String id) {
    return _downloadedFiles.any((d) => d.id == id);
  }

  bool isDownloaded(String id) => _isAlreadyDownloaded(id);

  DownloadModel? getDownload(String id) {
    try {
      return _downloadedFiles.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }

  int get totalDownloads => _downloadedFiles.length;

  int getTotalDownloadSize() {
    return _downloadedFiles.fold(0, (sum, d) => sum + d.fileSize);
  }

  void cancelCurrentDownload() {
    _downloadManager.cancelCurrentDownload();
  }
}
