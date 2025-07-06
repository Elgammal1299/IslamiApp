import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/feature/home/ui/view_model/audio_recording_cubit/audio_recording_cubit.dart';
import 'package:just_audio/just_audio.dart';
import 'package:islami_app/core/services/hive_service.dart';
import 'package:islami_app/feature/home/data/model/recording_model.dart'; // تأكد من المسار الصحيح

class AudioRecordingScreen extends StatefulWidget {
  const AudioRecordingScreen({super.key});

  @override
  State<AudioRecordingScreen> createState() => _AudioRecordingScreenState();
}

class _AudioRecordingScreenState extends State<AudioRecordingScreen> {
  final AudioPlayer _player = AudioPlayer();
  final audioService = HiveService.instanceFor<RecordingModel>("audioBox");

  List<RecordingModel> recordings = [];

  @override
  void initState() {
    super.initState();
    loadRecordings();
  }

  Future<void> loadRecordings() async {
    final data = await audioService.getAll();
    setState(() {
      recordings = data;
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تسجيل وتشغيل صوت")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BlocBuilder<AudioRecordingCubit, AudioRecordingState>(
              builder: (context, state) {
                if (state is AudioRecording) {
                  return ElevatedButton(
                    onPressed:
                        () =>
                            context.read<AudioRecordingCubit>().stopRecording(),
                    child: const Text("⏹️ إيقاف التسجيل"),
                  );
                } else if (state is AudioRecorded) {
                  // بعد الحفظ، أعد تحميل التسجيلات
                  loadRecordings();
                  return Column(
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
                        child: const Text("▶️ تشغيل التسجيل الأخير"),
                      ),
                    ],
                  );
                } else if (state is AudioRecordingError) {
                  return Text("خطأ: ${state.message}");
                } else {
                  return ElevatedButton(
                    onPressed:
                        () =>
                            context
                                .read<AudioRecordingCubit>()
                                .startRecording(),
                    child: const Text("🎤 بدء التسجيل"),
                  );
                }
              },
            ),

            const SizedBox(height: 24),
            const Divider(),
            const Text(
              "📂 التسجيلات المحفوظة",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // قائمة التسجيلات
            Expanded(
              child:
                  recordings.isEmpty
                      ? const Center(child: Text("لا توجد تسجيلات محفوظة"))
                      : ListView.builder(
                        itemCount: recordings.length,
                        itemBuilder: (context, index) {
                          final recording = recordings[index];
                          return ListTile(
                            title: Text("تسجيل - ${recording.createdAt}"),
                            onTap: () async {
                              await _player.setFilePath(recording.filePath);
                              _player.play();
                            },
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
