import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:islami_app/core/services/hive_service.dart';
import 'package:islami_app/feature/home/data/model/recording_model.dart';
import 'package:islami_app/feature/home/ui/view_model/audio_recording_cubit/audio_recording_cubit.dart';

class AudioRecordingScreen extends StatefulWidget {
  const AudioRecordingScreen({super.key});

  @override
  State<AudioRecordingScreen> createState() => _AudioRecordingScreenState();
}

class _AudioRecordingScreenState extends State<AudioRecordingScreen> {
  late final RecorderController recorderController;
  late final PlayerController playerController;
  final audioService = HiveService.instanceFor<RecordingModel>(
    boxName: "audioBox",
  );

  List<RecordingModel> recordings = [];
  String? currentPlayingPath;
  StreamSubscription<PlayerState>? _playerSubscription;

  @override
  void initState() {
    super.initState();
    recorderController = RecorderController();
    playerController = PlayerController();
    _loadRecordings();
  }

  Future<void> _loadRecordings() async {
    if (!audioService.isOpen) await audioService.init();
    final data = await audioService.getAll();
    setState(() => recordings = data);
  }

  @override
  void dispose() {
    recorderController.dispose();
    playerController.dispose();
    _playerSubscription?.cancel();
    super.dispose();
  }

  Future<void> _playRecording(String path) async {
    try {
      await playerController.stopPlayer();
      currentPlayingPath = null;
      await _playerSubscription?.cancel();

      await playerController.preparePlayer(path: path);
      currentPlayingPath = path;
      await playerController.startPlayer();

      _playerSubscription = playerController.onPlayerStateChanged.listen((
        state,
      ) {
        if (state == PlayerState.stopped) {
          setState(() => currentPlayingPath = null);
        }
      });

      setState(() {});
    } catch (e) {
      print("\u{1F534} Error playing: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("\u{1F3A7} تسجيل الصوت"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BlocListener<AudioRecordingCubit, AudioRecordingState>(
              listener: (_, state) {
                if (state is AudioRecorded) _loadRecordings();
              },
              child: BlocBuilder<AudioRecordingCubit, AudioRecordingState>(
                builder: (context, state) {
                  final isRecording = state is AudioRecording;
                  return Column(
                    children: [
                      if (isRecording)
                        Column(
                          children: [
                            AudioWaveforms(
                              enableGesture: false,
                              size: const Size(double.infinity, 60),
                              recorderController: recorderController,
                              waveStyle: const WaveStyle(
                                waveColor: Colors.deepPurple,
                                showMiddleLine: false,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      GestureDetector(
                        onTap: () {
                          if (isRecording) {
                            context.read<AudioRecordingCubit>().stopRecording();
                            recorderController.stop();
                          } else {
                            context
                                .read<AudioRecordingCubit>()
                                .startRecording();
                            recorderController.record();
                          }
                        },
                        child: CircleAvatar(
                          radius: 36,
                          backgroundColor:
                              isRecording ? Colors.red : Colors.deepPurple,
                          child: Icon(
                            isRecording ? Icons.stop : Icons.mic,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isRecording ? "جاري التسجيل..." : "اضغط لتسجيل جديد",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isRecording ? Colors.red : Colors.black54,
                        ),
                      ),
                      if (state is AudioRecordingError)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            "⚠️ ${state.message}",
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                "📂 التسجيلات المحفوظة",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child:
                  recordings.isEmpty
                      ? const Center(child: Text("لا توجد تسجيلات محفوظة"))
                      : ListView.builder(
                        itemCount: recordings.length,
                        itemBuilder: (context, i) {
                          final rec = recordings[i];
                          final date = DateFormat(
                            'yyyy/MM/dd – HH:mm',
                          ).format(rec.createdAt);
                          final seconds =
                              Duration(
                                milliseconds: rec.duration ?? 0,
                              ).inSeconds;

                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.audiotrack,
                                        color: Colors.deepPurple,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "تسجيل - $date",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        icon: Icon(
                                          currentPlayingPath == rec.filePath
                                              ? Icons.stop
                                              : Icons.play_arrow,
                                        ),
                                        onPressed: () {
                                          if (currentPlayingPath ==
                                              rec.filePath) {
                                            playerController.stopPlayer();
                                            setState(
                                              () => currentPlayingPath = null,
                                            );
                                          } else {
                                            _playRecording(rec.filePath);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  if (currentPlayingPath == rec.filePath)
                                    AudioFileWaveforms(
                                      size: const Size(double.infinity, 60),
                                      playerController: playerController,
                                      waveformType: WaveformType.long,
                                      continuousWaveform: true,
                                      animationDuration: Duration(
                                        milliseconds: 10,
                                      ),
                                      playerWaveStyle: const PlayerWaveStyle(
                                        fixedWaveColor: Colors.deepPurple,
                                        liveWaveColor: Colors.purpleAccent,
                                        spacing: 6,
                                        showSeekLine: false,
                                      ),
                                    ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "المدة: $seconds ثانية",
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
