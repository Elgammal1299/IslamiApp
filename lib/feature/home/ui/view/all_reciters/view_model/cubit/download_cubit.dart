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
  final Map<String, double> _downloadProgress = {};

  void _loadDownloadedFiles() async {
    try {
      emit(const DownloadLoading());
      final files = await _hiveService.getAll();
      _downloadedFiles = files;
      emit(DownloadLoaded(_downloadedFiles));
    } catch (e) {
      emit(DownloadError('فشل تحميل الملفات: ${e.toString()}'));
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
        emit(DownloadAlreadyExists(id, 'هذا الملف محمل بالفعل'));
        emit(DownloadLoaded(_downloadedFiles));
        return;
      }

      // Initialize progress
      _downloadProgress[id] = 0.0;
      emit(DownloadInProgress(id: id, progress: 0, total: 1));

      final filePath = await _downloadManager.downloadFile(
        url: url,
        filename: id,
        onProgress: (count, total) {
          if (!isClosed) {
            final percentage = (count / total * 100).clamp(0.0, 100.0);
            _downloadProgress[id] = percentage;
            emit(DownloadInProgress(id: id, progress: count, total: total));
          }
        },
        onError: (error) {
          if (!isClosed) {
            _downloadProgress.remove(id);
            emit(DownloadFailed(id: id, error: error));
            emit(DownloadLoaded(_downloadedFiles));
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
      _downloadProgress.remove(id);

      if (!isClosed) {
        emit(DownloadCompleted(downloadModel));
        emit(DownloadLoaded(_downloadedFiles));
      }
    } catch (e) {
      _downloadProgress.remove(id);
      if (!isClosed) {
        emit(DownloadFailed(id: id, error: 'فشل التحميل: ${e.toString()}'));
        emit(DownloadLoaded(_downloadedFiles));
      }
    }
  }

  Future<void> deleteDownload(String id) async {
    try {
      final download = _downloadedFiles.firstWhere((d) => d.id == id);
      await _downloadManager.deleteFile(download.localPath);
      await _hiveService.delete(id);
      _downloadedFiles.removeWhere((d) => d.id == id);
      _downloadProgress.remove(id);
      emit(DownloadDeleted(id));
      emit(DownloadLoaded(_downloadedFiles));
    } catch (e) {
      emit(DownloadError('فشل حذف الملف: ${e.toString()}'));
      emit(DownloadLoaded(_downloadedFiles));
    }
  }

  Future<void> deleteAllDownloads() async {
    try {
      for (var download in _downloadedFiles) {
        await _downloadManager.deleteFile(download.localPath);
        await _hiveService.delete(download.id);
      }
      _downloadedFiles.clear();
      _downloadProgress.clear();
      emit(const DownloadAllDeleted());
      emit(DownloadLoaded(_downloadedFiles));
    } catch (e) {
      emit(DownloadError('فشل حذف جميع الملفات: ${e.toString()}'));
      emit(DownloadLoaded(_downloadedFiles));
    }
  }

  void cancelDownload(String id) {
    _downloadManager.cancelCurrentDownload();
    _downloadProgress.remove(id);
    emit(DownloadCancelled(id));
    emit(DownloadLoaded(_downloadedFiles));
  }

  bool _isAlreadyDownloaded(String id) {
    return _downloadedFiles.any((d) => d.id == id);
  }

  bool isDownloaded(String id) => _isAlreadyDownloaded(id);

  bool isDownloading(String id) => _downloadProgress.containsKey(id);

  double getDownloadProgress(String id) => _downloadProgress[id] ?? 0.0;

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

  String getFormattedTotalSize() {
    final totalBytes = getTotalDownloadSize();
    if (totalBytes < 1024 * 1024) {
      return '${(totalBytes / 1024).toStringAsFixed(2)} KB';
    }
    return '${(totalBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  void refresh() {
    _loadDownloadedFiles();
  }
}