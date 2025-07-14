import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/constant/app_constant.dart';
import 'package:islami_app/core/services/hive_service.dart';
import 'package:islami_app/feature/home/data/model/recording_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
part 'audio_recording_state.dart';

class AudioRecordingCubit extends Cubit<AudioRecordingState> {
  AudioRecordingCubit() : super(AudioRecordingInitial());

  String? lastPath;
  DateTime? lastCreatedAt;
  final AudioRecorder _record = AudioRecorder();
  Future<void> startRecording() async {
    if (await _record.hasPermission()) {
      final dir = await getApplicationDocumentsDirectory();
      final path =
          '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
      lastPath = path;
      lastCreatedAt = DateTime.now();

      await _record.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: path,
      );
      emit(AudioRecording());
    } else {
      emit(AudioRecordingError("لا يوجد إذن لاستخدام الميكروفون"));
    }
  }

  Future<void> stopRecording() async {
    final path = await _record.stop();

    if (path != null && lastCreatedAt != null) {
      try {
        final player = AudioPlayer();
        await player.setFilePath(path);
        final duration = player.duration?.inMilliseconds ?? 0;
        await player.dispose();

        // استخدام HiveService لتخزين التسجيل
        final audioService = HiveService.instanceFor<RecordingModel>(
          boxName: AppConstant.hiveAudio,
        );
        await audioService.put(
          DateTime.now().millisecondsSinceEpoch.toString(), // مفتاح مميز
          RecordingModel(
            filePath: path,
            createdAt: lastCreatedAt!,
            duration: duration,
          ),
        );

        emit(AudioRecorded(path));
      } catch (e) {
        emit(AudioRecordingError("فشل في قراءة مدة التسجيل"));
      }
    } else {
      emit(AudioRecordingError("فشل في إيقاف التسجيل"));
    }
  }

  Future<void> reset() async {
    emit(AudioRecordingInitial());
  }
}
