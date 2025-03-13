import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:islami_app/feature/home/data/model/radio_model.dart';
import 'package:islami_app/feature/home/data/repo/radio_repository.dart';
import 'package:meta/meta.dart';

part 'radio_state.dart';

class RadioCubit extends Cubit<RadioState> {
  final RadioRepository radioRepository;
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<RadioModel> radioStations = [];
String? _currentUrl;

  RadioCubit(this.radioRepository) : super(RadioInitial());

@override
  Future<void> close() async {
    await _audioPlayer.dispose();
    return super.close();
  }

  Future<void> loadRadioStations({String language = 'ar'}) async {
    try {
      emit(RadioLoading());
      
      final stations = await radioRepository.getRadioStations(language: language);
      
      emit(RadioLoaded(stations));
    } catch (e) {
      emit(RadioError('حدث خطأ أثناء تحميل المحطات'));
    }
  }

  Future<void> playStation(String url) async {
    try {
      emit(RadioLoading());
      await _audioPlayer.stop();
      await _audioPlayer.setSourceUrl(url);
      _currentUrl =url;
      await _audioPlayer.resume();
      emit(RadioPlaying(true, url));
    } catch (e) {
      emit(RadioError('حدث خطأ أثناء تشغيل المحطة'));
      await stopPlaying();
    }
  }

  Future<void> stopPlaying() async {
    try {
      await _audioPlayer.stop();
      //  if (_currentUrl != null) {
      //   emit(RadioPlaying(false, _currentUrl!));
      // }
      emit(RadioStopped());
    } catch (e) {
      emit(RadioError('حدث خطأ أثناء إيقاف المحطة'));
    }
  }

  Future<void> pausePlaying() async {
    try {
      await _audioPlayer.pause();
      emit(RadioPaused());
    } catch (e) {
      emit(RadioError('حدث خطأ أثناء إيقاف المحطة مؤقتاً'));
    }
  }

  Future<void> resumePlaying() async {
    try {
      await _audioPlayer.resume();
      emit(RadioPlaying(true, _currentUrl?? ''));
    } catch (e) {
      emit(RadioError('حدث خطأ أثناء استئناف التشغيل'));
    }
  }

  void setVolume(double volume) {
    try {
      _audioPlayer.setVolume(volume);
    } catch (e) {
      emit(RadioError('حدث خطأ أثناء تغيير مستوى الصوت'));
    }
  }
  Future<void> dispose() async {
    await stopPlaying();
    await _audioPlayer.dispose();
  }
  
}