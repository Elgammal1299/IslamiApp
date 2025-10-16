part of 'download_cubit.dart';

sealed class DownloadState extends Equatable {
  const DownloadState();

  @override
  List<Object?> get props => [];
}

class DownloadInitial extends DownloadState {
  const DownloadInitial();
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
  final String message;

  const DownloadAlreadyExists(this.message);

  @override
  List<Object?> get props => [message];
}

class DownloadDeleted extends DownloadState {
  final String id;

  const DownloadDeleted(this.id);

  @override
  List<Object?> get props => [id];
}