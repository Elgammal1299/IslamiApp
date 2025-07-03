import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view_model/audio_manager_cubit/audio_cubit.dart';

class CustomMiniPlayerItem extends StatelessWidget {
  final dynamic state;
  final Duration position;
  final Duration duration;
  const CustomMiniPlayerItem({
    super.key,
    this.state,
    required this.position,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    String formatDuration(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      final minutes = twoDigits(duration.inMinutes.remainder(60));
      final seconds = twoDigits(duration.inSeconds.remainder(60));
      return '$minutes:$seconds';
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<AudioCubit, AudioState>(
            builder: (context, state) {
              if (state is! AudioPlaybackState) {
                return Slider(value: 0, onChanged: (_) {});
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
                  trackHeight: 2.0,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 6.0,
                  ),
                ),
                child: Slider(
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.currentItem?.title ?? 'لا توجد أغنية',
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${formatDuration(position)} / ${formatDuration(duration)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    state.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () => context.read<AudioCubit>().togglePlayPause(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
