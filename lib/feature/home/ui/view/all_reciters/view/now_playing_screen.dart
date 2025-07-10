import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audio_service/audio_service.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/core/helper/audio_manager.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view_model/audio_manager_cubit/audio_cubit.dart';
import 'package:just_audio/just_audio.dart';

class NowPlayingScreen extends StatefulWidget {
  final AudioManager audioManager;

  const NowPlayingScreen({super.key, required this.audioManager});

  @override
  _NowPlayingScreenState createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  // final double _sliderValue = 0;
  // final bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _startPlayback();
  }

  Future<void> _startPlayback() async {
    await Future.delayed(Duration.zero);
    if (mounted) {
      final state = context.read<AudioCubit>().state;
      if (state is AudioPlaybackState && !state.isPlaying) {
        await context.read<AudioCubit>().play();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioCubit, AudioState>(
      builder: (context, state) {
        if (state is! AudioPlaybackState) {
          return Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(state.currentItem?.title ?? 'لا توجد أغنية'),
          ),
          body: Column(
            children: [
              Expanded(child: Center(child: _buildAlbumArt(state.currentItem))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Text(
                      state.currentItem?.title ?? 'لا توجد أغنية',
                      style: Theme.of(context).textTheme.labelLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.currentItem?.artist ?? 'فنان غير معروف',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    _buildProgressBar(state),
                    const SizedBox(height: 32),
                    _buildControlButtons(context, state),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAlbumArt(MediaItem? item) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary,
            blurRadius: 20,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child:
            item?.artUri != null
                ? Image.network(
                  item!.artUri.toString(),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildPlaceholderArt(),
                )
                : _buildPlaceholderArt(),
      ),
    );
  }

  Widget _buildPlaceholderArt() {
    return Container(
      color: Theme.of(context).primaryColor,
      child: const Icon(Icons.music_note, color: Colors.grey, size: 100),
    );
  }

  Widget _buildProgressBar(AudioPlaybackState state) {
    final currentDuration = state.duration ?? Duration.zero;
    final currentPosition = state.position;

    // Calculate the slider value, ensuring it's between 0 and 1
    // double calculateSliderValue() {
    //   if (currentDuration.inMilliseconds <= 0) return 0.0;
    //   final value =
    //       currentPosition.inMilliseconds / currentDuration.inMilliseconds;
    //   return value.clamp(0.0, 1.0);
    // }

    return Column(
      children: [
        BlocBuilder<AudioCubit, AudioState>(
          builder: (context, state) {
            if (state is! AudioPlaybackState) {
              return Slider(
                activeColor: AppColors.primary,
                inactiveColor: AppColors.secondary,
                value: 0,
                onChanged: (_) {},
              );
            }

            final duration = state.duration ?? Duration.zero;
            final position = state.position;
            final value =
                duration.inMilliseconds > 0
                    ? position.inMilliseconds / duration.inMilliseconds
                    : 0.0;

            return SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Theme.of(context).colorScheme.primary,
                inactiveTrackColor: Theme.of(
                  context,
                ).colorScheme.primary.withOpacity(0.2),
                thumbColor: Theme.of(context).colorScheme.primary,
                overlayColor: Theme.of(
                  context,
                ).colorScheme.primary.withOpacity(0.1),
                trackHeight: 4.0,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 8.0,
                ),
                overlayShape: const RoundSliderOverlayShape(
                  overlayRadius: 16.0,
                ),
                valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                valueIndicatorColor: Theme.of(context).colorScheme.primary,
                valueIndicatorTextStyle: Theme.of(context).textTheme.titleLarge,
              ),
              child: Slider(
                activeColor: AppColors.primary,
                inactiveColor: AppColors.secondary,
                value: value.clamp(0.0, 1.0),
                onChanged: (newValue) {
                  final newPosition = duration * newValue;
                  context.read<AudioCubit>().seek(newPosition);
                },
              ),
            );
          },
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(currentPosition),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                _formatDuration(currentDuration),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildControlButtons(BuildContext context, AudioPlaybackState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(
            state.loopMode == LoopMode.one ? Icons.repeat_one : Icons.repeat,
            size: 28,
            color:
                state.loopMode != LoopMode.off
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).primaryColor,
          ),
          onPressed: () {
            final newMode =
                state.loopMode == LoopMode.off
                    ? LoopMode.all
                    : state.loopMode == LoopMode.all
                    ? LoopMode.one
                    : LoopMode.off;
            context.read<AudioCubit>().setLoopMode(newMode);
          },
        ),
        IconButton(
          icon: Icon(
            Icons.skip_previous,
            size: 36,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () => context.read<AudioCubit>().skipToPrevious(),
        ),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(
              state.isPlaying ? Icons.pause : Icons.play_arrow,
              size: 36,
              color: Theme.of(context).cardColor,
            ),
            onPressed: () => context.read<AudioCubit>().togglePlayPause(),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.skip_next,
            size: 36,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () => context.read<AudioCubit>().skipToNext(),
        ),
        IconButton(
          icon: Icon(
            Icons.shuffle,
            size: 28,
            color:
                state.isShuffled
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).primaryColor,
          ),
          onPressed:
              () => context.read<AudioCubit>().setShuffle(!state.isShuffled),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
