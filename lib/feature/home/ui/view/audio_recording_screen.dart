import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:islami_app/core/constant/app_constant.dart';
import 'package:islami_app/core/services/hive_service.dart';
import 'package:islami_app/feature/home/data/model/recording_model.dart';
import 'package:islami_app/feature/home/ui/view_model/audio_recording_cubit/audio_recording_cubit.dart';
import 'package:islami_app/feature/home/ui/view/widget/recording_input_widget.dart';
import 'package:islami_app/feature/home/ui/view/widget/recording_list_widget.dart';

class AudioRecordingScreen extends StatefulWidget {
  const AudioRecordingScreen({super.key});

  @override
  State<AudioRecordingScreen> createState() => _AudioRecordingScreenState();
}

class _AudioRecordingScreenState extends State<AudioRecordingScreen> {
  late final RecorderController recorderController;
  final audioService = HiveService.instanceFor<RecordingModel>(
    boxName: AppConstant.hiveAudio,
  );

  List<RecordingModel> recordings = [];
  String? currentlyPlayingKey;

  @override
  void initState() {
    super.initState();
    recorderController = RecorderController();
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
    super.dispose();
  }

  Future<void> _deleteRecording(RecordingModel rec) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              "حذف التسجيل؟",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            content: Text(
              "هل أنت متأكد أنك تريد حذف هذا التسجيل؟ لا يمكن التراجع.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  "إلغاء",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  "حذف",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
    );
    if (confirmed == true) {
      await audioService.delete(rec.key);
      _loadRecordings();
    }
  }

  // String _formatDuration(Duration d) {
  //   String twoDigits(int n) => n.toString().padLeft(2, '0');
  //   if (d.inHours > 0) {
  //     return "${d.inHours}:${twoDigits(d.inMinutes % 60)}:${twoDigits(d.inSeconds % 60)}";
  //   } else {
  //     return "${d.inMinutes}:${twoDigits(d.inSeconds % 60)}";
  //   }
  // }

  // WhatsApp-style date formatting
  String formatWhatsAppDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final aDate = DateTime(date.year, date.month, date.day);
    final diff = today.difference(aDate).inDays;
    if (diff == 0) {
      return 'اليوم، ${DateFormat('HH:mm').format(date)}';
    } else if (diff == 1) {
      return 'أمس، ${DateFormat('HH:mm').format(date)}';
    } else if (today.year == aDate.year) {
      return DateFormat('d MMMM، HH:mm', 'ar').format(date);
    } else {
      return DateFormat('yyyy/MM/dd – HH:mm').format(date);
    }
  }

  void _onPlayRequest(String key) {
    setState(() {
      currentlyPlayingKey = key;
    });
  }

  void _onStopRequest(String key) {
    if (currentlyPlayingKey == key) {
      setState(() {
        currentlyPlayingKey = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تسجيل الصوت')),
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
                  final error =
                      state is AudioRecordingError ? state.message : null;
                  return RecordingInputWidget(
                    isRecording: isRecording,
                    error: error,
                    onRecord: () {
                      if (isRecording) {
                        context.read<AudioRecordingCubit>().stopRecording();
                        recorderController.stop();
                      } else {
                        context.read<AudioRecordingCubit>().startRecording();
                        recorderController.record();
                      }
                    },
                    recorderController: recorderController,
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            Text(
              " التسجيلات المحفوظة",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: RecordingListWidget(
                recordings: recordings,
                currentlyPlayingKey: currentlyPlayingKey,
                onPlayRequest: _onPlayRequest,
                onStopRequest: _onStopRequest,
                onDelete: _deleteRecording,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
