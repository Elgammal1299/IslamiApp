import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/reciter_edition.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/quran_audio_cubit/quran_audio_cubit.dart';

class AudioBottomSheet extends StatefulWidget {
  final int ayahNumber;
  final String ayahText;
  final int surahNumber;
  final String surahName;

  const AudioBottomSheet({
    super.key,
    required this.ayahNumber,
    required this.ayahText,
    required this.surahNumber,
    required this.surahName,
  });

  @override
  State<AudioBottomSheet> createState() => _AudioBottomSheetState();
}

class _AudioBottomSheetState extends State<AudioBottomSheet> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;

  // التحكم في نوع التشغيل
  bool _isSurahMode = false;

  // معلومات التشغيل الحالي
  String _currentAudioUrl = '';
  int _currentAyahIndexInSurah = 0;
  List<String> _surahAudioUrls = [];

  // القارئ المختار (افتراضياً العفاسي)
  String _selectedReciterId = 'ar.husarymujawwad';
  String _selectedReciterName = 'محمود خليل الحصري (المجود)';
  @override
  void initState() {
    super.initState();

    // جلب قائمة القراء فوراً
    context.read<QuranAudioCubit>().fetchReciters();

    // تحميل المادة الصوتية المبدئية
    _loadInitialAudio();

    _setupAudioListeners();
  }

  void _setupAudioListeners() {
    _audioPlayer.onDurationChanged.listen((newDuration) {
      if (!mounted) return;
      setState(() {
        _duration = newDuration;
      });
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      if (!mounted) return;
      setState(() {
        _position = newPosition;
      });
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (!mounted) return;
      if (_isSurahMode &&
          _currentAyahIndexInSurah < _surahAudioUrls.length - 1) {
        _playNextInSurah();
      } else {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
  }

  void _loadInitialAudio() {
    if (_isSurahMode) {
      context.read<QuranAudioCubit>().fetchSurahAudio(
        widget.surahNumber,
        _selectedReciterId,
      );
    } else {
      context.read<QuranAudioCubit>().fetchAyahAudio(
        widget.ayahNumber,
        _selectedReciterId,
      );
    }
  }

  void _playNextInSurah() {
    _currentAyahIndexInSurah++;
    _currentAudioUrl = _surahAudioUrls[_currentAyahIndexInSurah];
    _audioPlayer.play(UrlSource(_currentAudioUrl));
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      if (_currentAudioUrl.isNotEmpty) {
        try {
          await _audioPlayer.play(UrlSource(_currentAudioUrl));
        } catch (e) {
          debugPrint("❌ Audio error: $e");
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تعذر تشغيل الملف الصوتي")),
          );
        }
      } else {
        _loadInitialAudio();
      }
    }
  }

  void _seekTo(double seconds) {
    final newPosition = Duration(seconds: seconds.toInt());
    _audioPlayer.seek(newPosition);
  }

  void _showReciterPicker(List<ReciterEdition> reciters) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,

      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                /// Handle
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                /// Title + Icon
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorDark,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.mic_rounded,
                          color: Theme.of(context).primaryColorLight,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'اختر القارئ',
                        style: context.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                    ],
                  ),
                ),

                /// Reciters List
                Expanded(
                  child:
                      reciters.isEmpty
                          ? Center(
                            child: Text(
                              "لا يوجد قراء حاليا",
                              style: context.textTheme.bodyMedium,
                            ),
                          )
                          : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: reciters.length,
                            itemBuilder: (context, index) {
                              final reciter = reciters[index];
                              final isSelected =
                                  reciter.identifier == _selectedReciterId;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? AppColors.primary.withOpacity(.08)
                                          : Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? AppColors.primary
                                            : Colors.grey.shade200,
                                  ),
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: Colors.black.withOpacity(.03),
                                  //     blurRadius: 10,
                                  //     offset: const Offset(0, 4),
                                  //   ),
                                  // ],
                                ),

                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(18),
                                  ),

                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor:
                                          isSelected
                                              ? AppColors.primary
                                              : Colors.grey.shade200,
                                      child: Text(
                                        reciter.name.characters.first,
                                        style: TextStyle(
                                          color:
                                              isSelected
                                                  ? Colors.white
                                                  : Colors.grey.shade700,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      reciter.name,
                                      style: context.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                isSelected
                                                    ? AppColors.primary
                                                    : Theme.of(
                                                      context,
                                                    ).primaryColorDark,
                                          ),
                                    ),
                                    subtitle: Text(
                                      reciter.englishName,
                                      style: context.textTheme.bodySmall,
                                    ),
                                    trailing: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      child:
                                          isSelected
                                              ? const Icon(
                                                Icons.check_circle_rounded,
                                                color: AppColors.primary,
                                                key: ValueKey(1),
                                              )
                                              : const SizedBox(
                                                key: ValueKey(2),
                                              ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _selectedReciterId = reciter.identifier;
                                        _selectedReciterName = reciter.name;
                                        _audioPlayer.stop();
                                        _isPlaying = false;
                                        _duration = Duration.zero;
                                        _position = Duration.zero;
                                      });
                                      _loadInitialAudio();
                                      Navigator.pop(context);
                                    },
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header - Surah Name & Mode Switcher
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.surahName,
                        style: context.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        _isSurahMode
                            ? 'تشغيل السورة كاملة'
                            : 'تشغيل آية مختارة',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                  // Toggle Button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        _buildModeButton('الآية', !_isSurahMode, () {
                          if (_isSurahMode) {
                            setState(() {
                              _isSurahMode = false;
                              _audioPlayer.stop();
                              _position = Duration.zero;
                            });
                            _loadInitialAudio();
                          }
                        }),
                        _buildModeButton('السورة', _isSurahMode, () {
                          if (!_isSurahMode) {
                            setState(() {
                              _isSurahMode = true;
                              _audioPlayer.stop();
                              _position = Duration.zero;
                            });
                            _loadInitialAudio();
                          }
                        }),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Ayah Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.ayahText,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.justify,
                  style: context.textTheme.titleLarge?.copyWith(
                    height: 1.6,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Reciter Selector (Always Visible Container)
              BlocBuilder<QuranAudioCubit, QuranAudioState>(
                builder: (context, state) {
                  final reciters =
                      (state is RecitersLoaded)
                          ? state.reciters
                          : <ReciterEdition>[];
                  final isLoading = (state is RecitersLoading);

                  return GestureDetector(
                    onTap:
                        reciters.isNotEmpty
                            ? () => _showReciterPicker(reciters)
                            : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(15),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.black.withOpacity(0.03),
                        //     blurRadius: 10,
                        //     offset: const Offset(0, 4),
                        //   ),
                        // ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            child: Icon(
                              Icons.person_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'القارئ الحالي',
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[500],
                                  ),
                                ),
                                Text(
                                  _selectedReciterName,
                                  style: context.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isLoading)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          else
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppColors.primary,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              // Audio Controls
              BlocConsumer<QuranAudioCubit, QuranAudioState>(
                listener: (context, state) {
                  if (state is AyahAudioLoaded && !_isSurahMode) {
                    setState(() {
                      _currentAudioUrl = state.ayahAudio.audio;
                    });
                  } else if (state is SurahAudioLoaded && _isSurahMode) {
                    setState(() {
                      _surahAudioUrls =
                          state.surahAudio.ayahs.map((e) => e.audio).toList();
                      _currentAyahIndexInSurah = 0;
                      _currentAudioUrl = _surahAudioUrls[0];
                    });
                  } else if (state is QuranAudioError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  final isAudioLoading =
                      (state is AyahAudioLoading || state is SurahAudioLoading);

                  return Column(
                    children: [
                      // Slider with Timer
                      Column(
                        children: [
                          SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 6,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 10,
                              ),
                              overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 20,
                              ),
                              activeTrackColor: AppColors.primary,
                              inactiveTrackColor: AppColors.primary.withOpacity(
                                0.1,
                              ),
                              thumbColor: AppColors.primary,
                            ),
                            child: Slider(
                              min: 0,
                              max:
                                  _duration.inSeconds > 0
                                      ? _duration.inSeconds.toDouble()
                                      : 1,
                              value: _position.inSeconds.toDouble().clamp(
                                0,
                                _duration.inSeconds > 0
                                    ? _duration.inSeconds.toDouble()
                                    : 1,
                              ),
                              onChanged: (value) => _seekTo(value),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(_position),
                                  style: context.textTheme.bodySmall,
                                ),
                                Text(
                                  _formatDuration(_duration),
                                  style: context.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Play/Pause Button
                      Center(
                        child: GestureDetector(
                          onTap: isAudioLoading ? null : _togglePlay,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.primary.withAlpha(200),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child:
                                isAudioLoading
                                    ? const Padding(
                                      padding: EdgeInsets.all(25.0),
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    )
                                    : Icon(
                                      _isPlaying
                                          ? Icons.pause_rounded
                                          : Icons.play_arrow_rounded,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton(String text, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: context.textTheme.labelLarge?.copyWith(
            color: isActive ? Colors.white : Colors.grey[600],
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return hours > 0
        ? "${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}"
        : "${twoDigits(minutes)}:${twoDigits(seconds)}";
  }
}
