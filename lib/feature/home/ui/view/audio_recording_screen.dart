import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/feature/home/ui/view_model/audio_recording_cubit/audio_recording_cubit.dart';
import 'package:just_audio/just_audio.dart';

class AudioRecordingScreen extends StatefulWidget {
  const AudioRecordingScreen({super.key});

  @override
  State<AudioRecordingScreen> createState() => _AudioRecordingScreenState();
}

class _AudioRecordingScreenState extends State<AudioRecordingScreen> {
  final AudioPlayer _player = AudioPlayer();

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تسجيل وتشغيل صوت")),
      body: Center(
        child: BlocBuilder<AudioRecordingCubit, AudioRecordingState>(
          builder: (context, state) {
            if (state is AudioRecording) {
              return ElevatedButton(
                onPressed:
                    () => context.read<AudioRecordingCubit>().stopRecording(),
                child: const Text("⏹️ إيقاف التسجيل"),
              );
            } else if (state is AudioRecorded) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed:
                        () =>
                            context
                                .read<AudioRecordingCubit>()
                                .startRecording(),
                    child: const Text("🎙️ تسجيل جديد"),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await _player.setFilePath(state.path);
                      _player.play();
                    },
                    child: const Text("▶️ تشغيل التسجيل"),
                  ),
                ],
              );
            } else if (state is AudioRecordingError) {
              return Text("خطأ: ${state.message}");
            } else {
              return ElevatedButton(
                onPressed:
                    () => context.read<AudioRecordingCubit>().startRecording(),
                child: const Text("🎤 بدء التسجيل"),
              );
            }
          },
        ),
      ),
    );
  }
}
