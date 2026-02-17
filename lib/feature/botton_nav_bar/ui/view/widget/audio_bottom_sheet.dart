import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/reciter_edition.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/quran_audio_cubit/quran_audio_cubit.dart';
import 'package:quran/quran.dart' as quran;

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
  bool _isSequential = false; // وضع التشغيل المتتالي ملغي افتراضياً
  bool _isTransitioning = false; // لتجنب تضارب الحالة أثناء الانتقال بين الآيات

  // معلومات الآية الحالية
  late int _currentAyahNumber;
  late String _currentAyahText;
  late int _currentSurahNumber;
  late String _currentSurahName;

  // معلومات التشغيل الحالي
  String _currentAudioUrl = '';

  // القارئ المختار (افتراضياً الحصري المجود)
  String _selectedReciterId = 'ar.husarymujawwad';
  String _selectedReciterName = 'محمود خليل الحصري (المجود)';
    String get pageFont => "QCF_P${_currentAyahNumber.toString().padLeft(3, '0')}";


  @override
  void initState() {
    super.initState();
    _currentAyahNumber = widget.ayahNumber;
    _currentAyahText = widget.ayahText;
    _currentSurahNumber = widget.surahNumber;
    _currentSurahName = widget.surahName;

    // جلب قائمة القراء فوراً
    context.read<QuranAudioCubit>().fetchReciters();

    // تحميل المادة الصوتية المبدئية
    _loadAudio();

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
      if (_isSequential) {
        _nextAyah(fromAuto: true);
      } else {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted || _isTransitioning) return;
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
  }

  void _loadAudio() {
    // جلب رقم الآية العالمي (Global Ayah Number) لأن API الصوت يحتاجه
    int globalAyahNumber = _calculateGlobalAyahNumber(
      _currentSurahNumber,
      _currentAyahNumber,
    );

    context.read<QuranAudioCubit>().fetchAyahAudio(
      globalAyahNumber,
      _selectedReciterId,
    );
  }

  int _calculateGlobalAyahNumber(int surah, int ayah) {
    int total = 0;
    for (int i = 1; i < surah; i++) {
      total += quran.getVerseCount(i);
    }
    return total + ayah;
  }

  void _nextAyah({bool fromAuto = false}) {
    int totalVerses = quran.getVerseCount(_currentSurahNumber);
    bool shouldPlay = fromAuto || _isPlaying;

    if (_currentAyahNumber < totalVerses) {
      _updateAyah(
        _currentSurahNumber,
        _currentAyahNumber + 1,
        keepPlaying: shouldPlay,
      );
    } else if (_currentSurahNumber < 114) {
      _updateAyah(_currentSurahNumber + 1, 1, keepPlaying: shouldPlay);
    } else {
      // انتهى المصحف
      setState(() {
        _isPlaying = false;
        _position = Duration.zero;
      });
    }
  }

  void _previousAyah() {
    bool shouldPlay = _isPlaying;
    if (_currentAyahNumber > 1) {
      _updateAyah(
        _currentSurahNumber,
        _currentAyahNumber - 1,
        keepPlaying: shouldPlay,
      );
    } else if (_currentSurahNumber > 1) {
      int prevSurah = _currentSurahNumber - 1;
      _updateAyah(
        prevSurah,
        quran.getVerseCount(prevSurah),
        keepPlaying: shouldPlay,
      );
    }
  }

  void _updateAyah(int surah, int ayah, {bool keepPlaying = false}) {
    setState(() {
      _isTransitioning = true; // بدء الانتقال
      _currentSurahNumber = surah;
      _currentAyahNumber = ayah;
      _currentSurahName = quran.getSurahNameArabic(surah);
      _currentAyahText = quran.getVerse(surah, ayah, verseEndSymbol: true);
      _audioPlayer.stop();
      _isPlaying = keepPlaying;
      _position = Duration.zero;
      _duration = Duration.zero;
      _currentAudioUrl = '';
    });
    _loadAudio();

    // إنهاء حالة الانتقال بعد فترة وجيزة للسماح لـ stop() بالتنفيذ
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isTransitioning = false;
        });
      }
    });
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
      setState(() => _isPlaying = false);
    } else {
      if (_currentAudioUrl.isNotEmpty) {
        try {
          await _audioPlayer.play(UrlSource(_currentAudioUrl));
          setState(() => _isPlaying = true);
        } catch (e) {
          debugPrint("❌ Audio error: $e");
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تعذر تشغيل الملف الصوتي")),
          );
        }
      } else {
        // إذا لم يكن الرابط موجوداً، نبدأ تحميله ونعلم النظام أننا نريد التشغيل بمجرد التحميل
        setState(() => _isPlaying = true);
        _loadAudio();
      }
    }
  }

  void _seekTo(double seconds) {
    final newPosition = Duration(seconds: seconds.toInt());
    _audioPlayer.seek(newPosition);
  }

  void _showReciterPicker() {
    // We need to capture the cubit from the current context to pass it to the bottom sheet
    // because showModalBottomSheet creates a new route/context.
    final cubit = context.read<QuranAudioCubit>();

    // If reciters are not loaded yet, trigger the fetch
    if (cubit.state is! RecitersLoaded) {
      cubit.fetchReciters();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => BlocProvider.value(
            value: cubit,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
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
                      color: Theme.of(context).dividerColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  /// Title
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.mic_rounded,
                            color: Theme.of(context).primaryColor,
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
                    child: BlocBuilder<QuranAudioCubit, QuranAudioState>(
                      // Using buildWhen to ensure list stays visible when switching to AyahAudioLoading
                      buildWhen:
                          (previous, current) =>
                              current is RecitersLoading ||
                              current is RecitersLoaded ||
                              (current is QuranAudioError &&
                                  previous is RecitersLoading),
                      builder: (context, state) {
                        if (state is RecitersLoading) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),
                          );
                        }

                        List<ReciterEdition> reciters = [];
                        // Try to get reciters from state, or from previous state if available
                        if (state is RecitersLoaded) {
                          reciters = state.reciters;
                        } else if (cubit.state is RecitersLoaded) {
                          reciters = (cubit.state as RecitersLoaded).reciters;
                        }

                        if (reciters.isEmpty && state is! RecitersLoading) {
                          if (state is QuranAudioError) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(state.message),
                                  TextButton(
                                    onPressed: () => cubit.fetchReciters(),
                                    child: const Text("إعادة المحاولة"),
                                  ),
                                ],
                              ),
                            );
                          }
                          return const Center(
                            child: Text("لا توجد قائمة قراء حالياً"),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: reciters.length,
                          itemBuilder: (context, index) {
                            final reciter = reciters[index];
                            final isSelected =
                                reciter.identifier == _selectedReciterId;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedReciterId = reciter.identifier;
                                    _selectedReciterName = reciter.name;
                                    _audioPlayer.stop();
                                    _isPlaying = false;
                                    _duration = Duration.zero;
                                    _position = Duration.zero;
                                    _currentAudioUrl = '';
                                  });
                                  _loadAudio();
                                  Navigator.pop(context);
                                },
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color:
                                        isSelected
                                            ? Theme.of(
                                              context,
                                            ).primaryColor.withOpacity(0.1)
                                            : Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color:
                                          isSelected
                                              ? Theme.of(context).primaryColor
                                              : Theme.of(
                                                context,
                                              ).dividerColor.withOpacity(0.5),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            isSelected
                                                ? Theme.of(context).primaryColor
                                                : Theme.of(
                                                  context,
                                                ).primaryColor.withOpacity(0.1),
                                        child: Text(
                                          reciter.name.characters.first,
                                          style: TextStyle(
                                            color:
                                                isSelected
                                                    ? Colors.white
                                                    : Theme.of(
                                                      context,
                                                    ).primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              reciter.name,
                                              style: context
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        isSelected
                                                            ? Theme.of(
                                                              context,
                                                            ).primaryColor
                                                            : Theme.of(
                                                              context,
                                                            ).primaryColorDark,
                                                  ),
                                            ),
                                            Text(
                                              reciter.englishName,
                                              style: context.textTheme.bodySmall
                                                  ?.copyWith(
                                                    color: Theme.of(context)
                                                        .primaryColorDark
                                                        .withOpacity(0.6),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isSelected)
                                        Icon(
                                          Icons.check_circle_rounded,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
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
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
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
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header - Surah Name
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Column(
              //       children: [
              //         Text(
              //           _currentSurahName,
              //           style: context.textTheme.headlineSmall?.copyWith(
              //             fontWeight: FontWeight.bold,
              //             color: Theme.of(context).primaryColor,
              //           ),
              //         ),
              //         Text(
              //           'الآية $_currentAyahNumber',
              //           style: context.textTheme.bodyMedium?.copyWith(
              //             color: Theme.of(
              //               context,
              //             ).primaryColorDark.withOpacity(0.6),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),

              // const SizedBox(height: 24),

              // Ayah Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _currentAyahText,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.justify,
                  style: context.textTheme.titleLarge?.copyWith(
                    height: 1.6,
                    fontWeight: FontWeight.w600,
                    // fontFamily: pageFont,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Reciter Selector
              BlocBuilder<QuranAudioCubit, QuranAudioState>(
                builder: (context, state) {
                  final isLoading = (state is RecitersLoading);

                  return GestureDetector(
                    onTap: () => _showReciterPicker(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).dividerColor.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.1),
                            child: Icon(
                              Icons.person_rounded,
                              color: Theme.of(context).primaryColor,
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
                                    color: Theme.of(
                                      context,
                                    ).primaryColorDark.withOpacity(0.5),
                                  ),
                                ),
                                Text(
                                  _selectedReciterName,
                                  style: context.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColorDark,
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
                              color: Theme.of(context).primaryColor,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Audio Controls
              BlocConsumer<QuranAudioCubit, QuranAudioState>(
                listener: (context, state) {
                  if (state is AyahAudioLoaded) {
                    setState(() {
                      _currentAudioUrl = state.ayahAudio.audio;
                    });
                    // إذا كان المشغل في وضع التشغيل (تلقائي أو يدوي)، وبدأ الرابط بالوصول، ابدأ فوراً
                    if (_isPlaying && (_currentAudioUrl.isNotEmpty)) {
                      _audioPlayer.play(UrlSource(_currentAudioUrl));
                    }
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
                  final isAudioLoading = (state is AyahAudioLoading);

                  return Column(
                    children: [
                      // Slider
                      Column(
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 4,
                              activeTrackColor: Theme.of(context).primaryColor,
                              inactiveTrackColor: Theme.of(
                                context,
                              ).primaryColor.withOpacity(0.1),
                              thumbColor: Theme.of(context).primaryColor,
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

                      // Controls Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // زر التكرار / التشغيل المتتالي
                          // زر إضافي للتوازن أو الوظائف المستقبلية (مثل الإيقاف المؤقت)
                          Opacity(
                            opacity: 0,
                            child: _buildExtraButton(
                              icon: Icons.shuffle_rounded,
                              isSelected: false,
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(width: 16),

                          // زر الآية السابقة (الآن في اليمين - RTL)
                          _buildNavButton(
                            icon: Icons.skip_next_rounded,
                            onTap: _previousAyah,
                          ),
                          const SizedBox(width: 20),

                          // Play/Pause
                          GestureDetector(
                            onTap: isAudioLoading ? null : _togglePlay,
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(
                                      context,
                                    ).primaryColor.withOpacity(0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child:
                                  isAudioLoading
                                      ? const Padding(
                                        padding: EdgeInsets.all(20.0),
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                      )
                                      : Icon(
                                        _isPlaying
                                            ? Icons.pause_rounded
                                            : Icons.play_arrow_rounded,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                            ),
                          ),
                          const SizedBox(width: 20),

                          // زر الآية التالية (الآن في الشمال - RTL)
                          _buildNavButton(
                            icon: Icons.skip_previous_rounded,
                            onTap: _nextAyah,
                          ),
                          const SizedBox(width: 16),

                          _buildExtraButton(
                            icon:
                                _isSequential
                                    ? Icons.repeat_one_on_rounded
                                    : Icons.repeat_one_rounded,
                            isSelected: _isSequential,
                            onTap: () {
                              setState(() => _isSequential = !_isSequential);
                            },
                          ),
                        ],
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

  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Theme.of(context).primaryColor, size: 30),
      ),
    );
  }

  Widget _buildExtraButton({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Theme.of(context).primaryColor,
          size: 22,
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return "${twoDigits(minutes)}:${twoDigits(seconds)}";
  }
}
