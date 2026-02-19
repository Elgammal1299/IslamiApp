import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/feature/home/ui/view_model/radio_player_cubit/radio_player_cubit.dart';
import 'package:islami_app/feature/home/ui/view_model/radio_player_cubit/radio_player_state.dart';

class RadioScreen2 extends StatefulWidget {
  const RadioScreen2({super.key});

  @override
  State<RadioScreen2> createState() => _RadioScreen2State();
}

class _RadioScreen2State extends State<RadioScreen2> {
  final String _radioUrl = "http://n0a.radiojar.com/8s5u5tpdtwzuv";
  final String _radioName = "إذاعة القرآن الكريم - مباشر";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "البث المباشر",
          style: context.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColorDark,
            ],
          ),
        ),
        child: BlocBuilder<RadioPlayerCubit, RadioPlayerState>(
          builder: (context, state) {
            bool isPlaying = false;
            String? metadataText;

            if (state is RadioPlayerPlaying) {
              isPlaying = state.isPlaying;
              if (state.metadata != null) {
                metadataText = state.metadata!.title;
                if (state.metadata!.artist != null) {
                  metadataText =
                      (metadataText ?? "") + " - " + state.metadata!.artist!;
                }
              }
            }

            return SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Radio Visualizer / Image
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.1),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.radio_rounded,
                        size: 150,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Station Name
                  Text(
                    _radioName,
                    style: context.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),

                  // Metadata / Current Program
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      metadataText ?? "جاري جلب بيانات البث...",
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  if (isPlaying)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.graphic_eq,
                          color: Colors.white70,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "جاري التشغيل الآن",
                          style: context.textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),

                  if (state is RadioPlayerLoading)
                    const CircularProgressIndicator(color: Colors.white),

                  if (state is RadioPlayerError)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  const SizedBox(height: 30),

                  // Playback Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Refresh Button
                      GestureDetector(
                        onTap:
                            () => context.read<RadioPlayerCubit>().refreshRadio(
                              _radioUrl,
                              name: _radioName,
                            ),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.2),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.refresh_rounded,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(width: 30),

                      // Play/Pause Button
                      GestureDetector(
                        onTap:
                            () => context.read<RadioPlayerCubit>().togglePlay(),
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Icon(
                            isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            size: 50,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),

                      const SizedBox(width: 30),

                      const SizedBox(width: 60),
                    ],
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
