import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
part 'audio_recording_state.dart';

class AudioRecordingCubit extends Cubit<AudioRecordingState> {
  AudioRecordingCubit() : super(AudioRecordingInitial());

  String? lastPath;
  final AudioRecorder _record = AudioRecorder();
  Future<void> startRecording() async {
    if (await _record.hasPermission()) {
      final dir = await getApplicationDocumentsDirectory();
      final path =
          '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
      lastPath = path;

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
    if (path != null) {
      emit(AudioRecorded(path));
    } else {
      emit(AudioRecordingError("فشل في إيقاف التسجيل"));
    }
  }

  Future<void> reset() async {
    emit(AudioRecordingInitial());
  }
}
