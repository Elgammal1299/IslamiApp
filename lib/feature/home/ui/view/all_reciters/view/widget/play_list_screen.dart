import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audio_service/audio_service.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/core/constant/app_image.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/core/helper/audio_manager.dart';
import 'package:islami_app/core/router/app_routes.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view_model/audio_manager_cubit/audio_cubit.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view_model/cubit/download_cubit.dart';

class PlaylistScreen extends StatefulWidget {
  final AudioManager audioManager;

  const PlaylistScreen({super.key, required this.audioManager});

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DownloadCubit, DownloadState>(
      listener: (context, state) {
        if (state is DownloadCompleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✓ تم التحميل: ${state.download.title}'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is DownloadFailed) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text('✗ فشل التحميل: ${state.error}'),
          //     backgroundColor: Colors.red,
          //     duration: const Duration(seconds: 3),
          //     behavior: SnackBarBehavior.floating,
          //   ),
          // );
        } else if (state is DownloadAlreadyExists) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: BlocBuilder<AudioCubit, AudioState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: AppBar(
              title: const Text('قائمة التشغيل'),
              actions: [
                // BlocBuilder<DownloadCubit, DownloadState>(
                //   builder: (context, downloadState) {
                //     if (downloadState is DownloadLoaded &&
                //         downloadState.downloads.isNotEmpty) {
                //       return Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Center(
                //           child: GestureDetector(
                //             onTap: () {
                //               Navigator.pushNamed(
                //                 context,
                //                 AppRoutes.downloadsRouter,
                //               );
                //             },
                //             child: Chip(
                //               avatar: const Icon(
                //                 Icons.download_done,
                //                 color: AppColors.white,
                //                 size: 18,
                //               ),
                //               label: Text(
                //                 '${downloadState.downloads.length}',
                //                 style: const TextStyle(
                //                   color: AppColors.white,
                //                   fontWeight: FontWeight.bold,
                //                 ),
                //               ),
                //               backgroundColor: Theme.of(context).primaryColor,
                //             ),
                //           ),
                //         ),
                //       );
                //     }
                //     return const SizedBox.shrink();
                //   },
                // ),
              ],
            ),
            body: FadeTransition(
              opacity: _fadeAnimation,
              child: _buildPlaylist(state),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlaylist(AudioState state) {
    if (state is! AudioPlaybackState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.playlist.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: state.playlist.length,
      itemBuilder: (context, index) {
        final item = state.playlist[index];
        return _buildSongCard(item, state);
      },
    );
  }

  Widget _buildSongCard(MediaItem item, AudioPlaybackState state) {
    final isCurrentItem = state.currentItem?.id == item.id;

    return BlocBuilder<DownloadCubit, DownloadState>(
      builder: (context, downloadState) {
        final downloadCubit = context.read<DownloadCubit>();
        final isDownloaded = downloadCubit.isDownloaded(item.id);
        final isDownloading = downloadCubit.isDownloading(item.id);
        final downloadProgress = downloadCubit.getDownloadProgress(item.id);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: isCurrentItem ? 4 : 2,
          color:
              isCurrentItem
                  ? Theme.of(context).secondaryHeaderColor
                  : Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadowColor: AppColors.white,
          child: InkWell(
            onTap: () async {
              final index = state.playlist.indexOf(item);
              if (state.currentItem?.id != item.id) {
                await context.read<AudioCubit>().skipToIndex(index);
              }
              if (mounted) {
                Navigator.pushNamed(
                  context,
                  AppRoutes.nowPlayingScreenRouter,
                  arguments: widget.audioManager,
                );
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                border:
                    isCurrentItem
                        ? Border.all(color: Colors.black, width: 2)
                        : const Border(),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildAlbumArt(item, isCurrentItem),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    item.title,
                                    style:
                                        isCurrentItem
                                            ? context.textTheme.titleLarge!
                                                .copyWith(
                                                  color: AppColors.black,
                                                  fontWeight: FontWeight.bold,
                                                )
                                            : context.textTheme.titleLarge,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    textAlign: TextAlign.end,
                                    item.displayTitle ?? '',
                                    style:
                                        isCurrentItem
                                            ? context.textTheme.bodyLarge!
                                                .copyWith(
                                                  color: AppColors.black,
                                                )
                                            : context.textTheme.bodyLarge,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.artist ?? 'فنان غير معروف',
                              style:
                                  isCurrentItem
                                      ? context.textTheme.bodyLarge!.copyWith(
                                        color: AppColors.black,
                                      )
                                      : context.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                      _buildDownloadButton(
                        item,
                        isDownloaded,
                        isDownloading,
                        downloadProgress,
                      ),
                      if (isCurrentItem)
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.equalizer,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                        ),
                    ],
                  ),
                  // Download progress indicator
                  if (isDownloading)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'جاري التحميل...',
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Text(
                                '${downloadProgress.toStringAsFixed(0)}%',
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: downloadProgress / 100,
                              minHeight: 6,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDownloadButton(
    MediaItem item,
    bool isDownloaded,
    bool isDownloading,
    double downloadProgress,
  ) {
    if (isDownloading) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                value: downloadProgress / 100,
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                context.read<DownloadCubit>().cancelDownload(item.id);
              },
              child: const Icon(Icons.close, size: 16, color: Colors.red),
            ),
          ],
        ),
      );
    }

    return PopupMenuButton<String>(
      onSelected: (String result) {
        if (result == 'download') {
          context.read<DownloadCubit>().downloadAudio(
            id: item.id,
            title: item.title,
            artist: item.artist ?? '',
            url: item.id,
          );
        } else if (result == 'delete') {
          _showDeleteConfirmation(item);
        }
      },
      itemBuilder: (BuildContext context) {
        if (isDownloaded) {
          return [
            const PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('حذف التحميل'),
                ],
              ),
            ),
          ];
        }

        return [
          const PopupMenuItem<String>(
            value: 'download',
            child: Row(
              children: [
                Icon(Icons.download, size: 20),
                SizedBox(width: 8),
                Text('تحميل'),
              ],
            ),
          ),
        ];
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildDownloadIcon(isDownloaded),
      ),
    );
  }

  Widget _buildDownloadIcon(bool isDownloaded) {
    if (isDownloaded) {
      return const Icon(Icons.check_circle, color: Colors.green, size: 28);
    }

    return Icon(
      Icons.cloud_download_outlined,
      color: Theme.of(context).primaryColor,
      size: 28,
    );
  }

  void _showDeleteConfirmation(MediaItem item) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.delete_outline, color: Colors.red),
                SizedBox(width: 8),
                Text('حذف التحميل'),
              ],
            ),
            content: Text('هل تريد حذف "${item.title}"؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<DownloadCubit>().deleteDownload(item.id);
                  Navigator.pop(dialogContext);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('حذف'),
              ),
            ],
          ),
    );
  }

  Widget _buildAlbumArt(MediaItem item, bool isCurrentItem) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(AppImage.quranCoverImage, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.music_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 24),
          Text(
            'لا توجد أغاني في القائمة',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          Text(
            'اضغط على + لإضافة أغاني',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
