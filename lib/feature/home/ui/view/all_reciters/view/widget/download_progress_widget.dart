import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view_model/cubit/download_cubit.dart';

class DownloadProgressWidget extends StatelessWidget {
  final String id;
  final VoidCallback? onCancel;

  const DownloadProgressWidget({super.key, required this.id, this.onCancel});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DownloadCubit, DownloadState>(
      builder: (context, state) {
        if (state is DownloadInProgress && state.id == id) {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.downloading,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'جاري التحميل...',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          state.formattedPercentage,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (onCancel != null) ...[
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: onCancel,
                            child: const Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: state.percentage / 100,
                    minHeight: 6,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  state.formattedProgress,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class CircularDownloadProgress extends StatelessWidget {
  final String id;
  final double size;
  final VoidCallback? onCancel;

  const CircularDownloadProgress({
    super.key,
    required this.id,
    this.size = 28,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DownloadCubit, DownloadState>(
      builder: (context, state) {
        if (state is DownloadInProgress && state.id == id) {
          return Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: state.percentage / 100,
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                  backgroundColor: Colors.grey[300],
                ),
              ),
              if (onCancel != null)
                GestureDetector(
                  onTap: onCancel,
                  child: Container(
                    width: size * 0.6,
                    height: size * 0.6,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 12, color: Colors.red),
                  ),
                )
              else
                Text(
                  '${state.percentage.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: size * 0.25,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class DownloadStatusIcon extends StatelessWidget {
  final String id;
  final double size;

  const DownloadStatusIcon({super.key, required this.id, this.size = 24});

  @override
  Widget build(BuildContext context) {
    final downloadCubit = context.read<DownloadCubit>();
    final isDownloaded = downloadCubit.isDownloaded(id);
    final isDownloading = downloadCubit.isDownloading(id);

    if (isDownloading) {
      return CircularDownloadProgress(id: id, size: size);
    }

    if (isDownloaded) {
      return Icon(Icons.check_circle, color: Colors.green, size: size);
    }

    return Icon(
      Icons.cloud_download_outlined,
      color: Theme.of(context).primaryColor,
      size: size,
    );
  }
}
