import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audio_service/audio_service.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/core/constant/app_image.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/core/helper/audio_manager.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view/now_playing_screen.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view_model/audio_manager_cubit/audio_cubit.dart';

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
    return BlocBuilder<AudioCubit, AudioState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(title: const Text('قائمة التشغيل')),
          body: FadeTransition(
            opacity: _fadeAnimation,
            child: _buildPlaylist(state),
          ),
        );
      },
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

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: isCurrentItem ? 4 : 2,
      color:
          isCurrentItem
              ? Theme.of(context).secondaryHeaderColor
              : Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      shadowColor: AppColors.white,
      child: InkWell(
        onTap: () async {
          final index = state.playlist.indexOf(item);
          if (state.currentItem?.id != item.id) {
            await context.read<AudioCubit>().skipToIndex(index);
          }
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        NowPlayingScreen(audioManager: widget.audioManager),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            border:
                isCurrentItem
                    ? Border.all(color: Colors.black)
                    : const Border(),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _buildAlbumArt(item, isCurrentItem),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          item.title,
                          style:
                              isCurrentItem
                                  ? context.textTheme.titleLarge!.copyWith(
                                    color: AppColors.black,
                                  )
                                  : context.textTheme.titleLarge,

                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Expanded(
                          flex: 4,
                          child: Text(
                            textAlign: TextAlign.end,
                            item.displayTitle ?? '',
                            style:
                                isCurrentItem
                                    ? context.textTheme.bodyLarge!.copyWith(
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
              //دى علامة بتظهر على الصورة اللى شغالة
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
        ),
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
        child: Image.asset(AppImage.quranCoverImage),
        // item.artUri != null
        //     ? Image.network(
        //       item.artUri.toString(),
        //       fit: BoxFit.cover,
        //       errorBuilder: (_, __, ___) => _buildPlaceholderArt(),
        //     )
        //     : _buildPlaceholderArt(),
      ),
    );
  }

  // Widget _buildPlaceholderArt() {
  //   return Container(
  //     color: Colors.grey[200],
  //     child: const Icon(Icons.music_note, color: Colors.grey, size: 30),
  //   );
  // }

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
