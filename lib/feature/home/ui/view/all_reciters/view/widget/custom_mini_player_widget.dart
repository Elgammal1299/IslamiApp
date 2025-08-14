import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/helper/audio_manager.dart';
import 'package:islami_app/core/router/app_routes.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view/widget/custom_mini_player_item.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view/now_playing_screen.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view_model/audio_manager_cubit/audio_cubit.dart';

class CustomMiniPlayerWidget extends StatefulWidget {
  final bool showMiniPlayer;
  bool isUserDragging;
  double miniPlayerProgress;
  final Duration position;
  final Duration duration;
  double dragStartPosition;
  Duration dragStartDuration;

  final AudioManager audioManager;

  CustomMiniPlayerWidget({
    super.key,
    required this.showMiniPlayer,
    this.isUserDragging = false,
    this.miniPlayerProgress = 0.0,
    required this.position,
    required this.duration,
    this.dragStartPosition = 0.0,
    this.dragStartDuration = Duration.zero,
    required this.audioManager,
  });

  @override
  State<CustomMiniPlayerWidget> createState() => _CustomMiniPlayerWidgetState();
}

class _CustomMiniPlayerWidgetState extends State<CustomMiniPlayerWidget> {
  @override
  Widget build(BuildContext context) {
    void openNowPlayingScreen(BuildContext context) {
      Navigator.pushNamed(
        context,
        AppRoutes.nowPlayingScreenRouter,
        arguments: widget.audioManager,
      );
    }

    return BlocBuilder<AudioCubit, AudioState>(
      builder: (context, state) {
        if (state is! AudioPlaybackState) return const SizedBox.shrink();

        final currentProgress =
            widget.isUserDragging
                ? widget.miniPlayerProgress
                : (widget.duration.inMilliseconds > 0
                    ? (widget.position.inMilliseconds /
                            widget.duration.inMilliseconds)
                        .clamp(0.0, 1.0)
                    : 0.0);

        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => openNowPlayingScreen(context),
            onHorizontalDragStart: (details) {
              HapticFeedback.lightImpact();
              setState(() {
                widget.isUserDragging = true;
                widget.dragStartPosition = details.localPosition.dx;
                widget.dragStartDuration = widget.position;
              });
            },
            onHorizontalDragUpdate: (details) {
              if (widget.duration.inMilliseconds == 0) return;

              final screenWidth = MediaQuery.sizeOf(context).width;
              final dragDistance =
                  details.localPosition.dx - widget.dragStartPosition;
              final dragPercentage = dragDistance / screenWidth;
              final newPositionMs =
                  widget.dragStartDuration.inMilliseconds +
                  (dragPercentage * widget.duration.inMilliseconds).round();

              setState(() {
                widget.miniPlayerProgress = (newPositionMs /
                        widget.duration.inMilliseconds)
                    .clamp(0.0, 1.0);
              });
            },
            onHorizontalDragEnd: (details) {
              final newPosition = Duration(
                milliseconds:
                    (widget.miniPlayerProgress * widget.duration.inMilliseconds)
                        .round(),
              );
              context.read<AudioCubit>().seek(newPosition);
              setState(() => widget.isUserDragging = false);
            },
            child: CustomMiniPlayerItem(
              duration: widget.duration,
              position: widget.position,
              state: state,
            ),
          ),
        );
      },
    );
  }
}
