part of 'download_cubit.dart';

sealed class DownloadState extends Equatable {
  const DownloadState();

  @override
  List<Object?> get props => [];
}

class DownloadInitial extends DownloadState {
  const DownloadInitial();
}

class DownloadLoading extends DownloadState {
  const DownloadLoading();
}

class DownloadLoaded extends DownloadState {
  final List<DownloadModel> downloads;

  const DownloadLoaded(this.downloads);

  @override
  List<Object?> get props => [downloads];
}

class DownloadInProgress extends DownloadState {
  final String id;
  final int progress;
  final int total;

  const DownloadInProgress({
    required this.id,
    required this.progress,
    required this.total,
  });

  double get percentage => total > 0 ? (progress / total) * 100 : 0;

  String get formattedPercentage => '${percentage.toStringAsFixed(0)}%';

  String get formattedProgress {
    final progressMB = (progress / (1024 * 1024)).toStringAsFixed(2);
    final totalMB = (total / (1024 * 1024)).toStringAsFixed(2);
    return '$progressMB / $totalMB MB';
  }

  @override
  List<Object?> get props => [id, progress, total];
}

class DownloadCompleted extends DownloadState {
  final DownloadModel download;

  const DownloadCompleted(this.download);

  @override
  List<Object?> get props => [download];
}

class DownloadFailed extends DownloadState {
  final String id;
  final String error;

  const DownloadFailed({required this.id, required this.error});

  @override
  List<Object?> get props => [id, error];
}

class DownloadAlreadyExists extends DownloadState {
  final String id;
  final String message;

  const DownloadAlreadyExists(this.id, this.message);

  @override
  List<Object?> get props => [id, message];
}

class DownloadDeleted extends DownloadState {
  final String id;

  const DownloadDeleted(this.id);

  @override
  List<Object?> get props => [id];
}

class DownloadAllDeleted extends DownloadState {
  const DownloadAllDeleted();
}

class DownloadCancelled extends DownloadState {
  final String id;

  const DownloadCancelled(this.id);

  @override
  List<Object?> get props => [id];
}

class DownloadError extends DownloadState {
  final String message;

  const DownloadError(this.message);

  @override
  List<Object?> get props => [message];
}
