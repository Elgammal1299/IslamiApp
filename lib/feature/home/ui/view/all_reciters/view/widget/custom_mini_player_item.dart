import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/core/extension/theme_text.dart';
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
        color: Theme.of(context).cardColor,
        // boxShadow: [
        //   BoxShadow(
        //     color: AppColors.white,
        //     blurRadius: 1,
        //     offset: const Offset(0, -2),
        //   ),
        // ],
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
                  inactiveTrackColor: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.2),
                  trackHeight: 2.0,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 6.0,
                  ),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.currentItem?.title ?? 'لا توجد أغنية',
                        style: context.textTheme.titleLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${formatDuration(position)} / ${formatDuration(duration)}',
                        style: context.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    state.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Theme.of(context).primaryColorDark,
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
