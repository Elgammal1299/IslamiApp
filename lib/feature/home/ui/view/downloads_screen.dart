import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/data/model/download_model.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view_model/cubit/download_cubit.dart';
import 'package:audio_service/audio_service.dart';
import 'package:islami_app/core/helper/audio_manager.dart';
import 'package:islami_app/core/router/app_routes.dart';
import 'package:islami_app/core/services/setup_service_locator.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  _DownloadsScreenState createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<DownloadCubit, DownloadState>(
      listener: (context, state) {
        if (state is DownloadCompleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم حفظ: ${state.download.title}')),
          );
        } else if (state is DownloadFailed) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('خطأ: ${state.error}')));
          log(state.error);
        } else if (state is DownloadDeleted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('تم حذف التحميل')));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('التحميلات'),
          actions: [
            BlocBuilder<DownloadCubit, DownloadState>(
              builder: (context, state) {
                if (state is DownloadLoaded && state.downloads.isNotEmpty) {
                  return PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'clear_all') {
                        _showClearAllDialog();
                      } else if (value == 'stats') {
                        _showStorageStats();
                      }
                    },
                    itemBuilder:
                        (BuildContext context) => [
                          const PopupMenuItem<String>(
                            value: 'stats',
                            child: Row(
                              children: [
                                Icon(Icons.info_outline),
                                SizedBox(width: 8),
                                Text('الإحصائيات'),
                              ],
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'clear_all',
                            child: Row(
                              children: [
                                Icon(Icons.delete_sweep, color: Colors.red),
                                SizedBox(width: 8),
                                Text('حذف الكل'),
                              ],
                            ),
                          ),
                        ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocBuilder<DownloadCubit, DownloadState>(
          builder: (context, state) {
            if (state is DownloadLoaded) {
              if (state.downloads.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.downloads.length,
                itemBuilder: (context, index) {
                  final download = state.downloads[index];
                  return _buildDownloadCard(download, context);
                },
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 24),
          Text(
            'لا توجد تحميلات بعد',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          Text(
            'حمل السور لتستمع إليها بدون إنترنت',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadCard(DownloadModel download, BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy', 'ar');
    final timeFormat = DateFormat('HH:mm', 'ar');
    final fileSizeMB = (download.fileSize / (1024 * 1024)).toStringAsFixed(2);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: const Icon(
          Icons.download_done,
          size: 36,
          color: AppColors.primary,
        ),
        title: Text(
          download.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${dateFormat.format(download.downloadedAt)} - ${timeFormat.format(download.downloadedAt)}',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 2),
            Text(
              'الحجم: $fileSizeMB MB',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.play_arrow, color: AppColors.primary),
              onPressed: () async {
                final audioManager = sl<AudioManager>();
                final mediaItem = MediaItem(
                  id: Uri.file(download.localPath).toString(),
                  title: download.title,
                  artist: download.artist,
                  album: 'تنزيلات',
                  displayTitle: download.title,
                  displaySubtitle: download.artist,
                );
                await audioManager.loadPlaylist([mediaItem]);
                await audioManager.play();
                if (mounted) {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.nowPlayingScreenRouter,
                    arguments: audioManager,
                  );
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _showDeleteDialog(download);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(DownloadModel download) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('حذف التحميل'),
            content: Text('هل أنت متأكد من حذف "${download.title}"؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () {
                  context.read<DownloadCubit>().deleteDownload(download.id);
                  Navigator.pop(context);
                },
                child: const Text('حذف', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('حذف جميع التحميلات'),
            content: const Text('هل أنت متأكد من حذف جميع التحميلات؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () {
                  context.read<DownloadCubit>().deleteAllDownloads();
                  Navigator.pop(context);
                },
                child: const Text(
                  'حذف الكل',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  void _showStorageStats() {
    final state = context.read<DownloadCubit>().state;
    if (state is DownloadLoaded) {
      final totalSizeMB = (state.downloads.fold<int>(
                0,
                (sum, d) => sum + d.fileSize,
              ) /
              (1024 * 1024))
          .toStringAsFixed(2);

      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('إحصائيات التخزين'),
              content: Text(
                'عدد التحميلات: ${state.downloads.length}\nإجمالي الحجم: $totalSizeMB MB',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('حسناً'),
                ),
              ],
            ),
      );
    }
  }
}
