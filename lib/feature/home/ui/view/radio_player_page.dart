import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/feature/home/data/model/radio_model.dart';
import 'package:islami_app/feature/home/ui/view_model/radio_cubit/radio_cubit.dart';

class RadioPlayerPage extends StatefulWidget {
  final RadioModel station;

  const RadioPlayerPage({super.key, required this.station});

  @override
  State<RadioPlayerPage> createState() => _RadioPlayerPageState();
}

class _RadioPlayerPageState extends State<RadioPlayerPage>
    with WidgetsBindingObserver {
  late RadioCubit _radioCubit;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _radioCubit = context.read<RadioCubit>();
    _playStation();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopStation();
    super.dispose();
  }

  Future<void> _playStation() async {
    await _radioCubit.playStation(widget.station.url);
  }

  Future<void> _stopStation() async {
    await _radioCubit.stopPlaying();
    _radioCubit.loadRadioStations();
  }

  Future<void> _togglePlayPause() async {
    final cubit = _radioCubit;
    if (cubit.state is RadioPlaying) {
      final playingState = cubit.state as RadioPlaying;
      if (playingState.isPlaying) {
        await _stopStation();
      } else {
        await _playStation();
      }
    } else {
      await _playStation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RadioCubit, RadioState>(
        buildWhen: (previous, current) {
          // إعادة البناء فقط عند تغيير حالة التشغيل
          return current is RadioPlaying ||
              (previous is RadioPlaying && current is! RadioPlaying);
        },
        builder: (context, state) {
          final bool isPlaying =
              state is RadioPlaying &&
              state.isPlaying &&
              state.currentUrl == widget.station.url;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ... Station image container
                const SizedBox(height: 32),
                Text(
                  widget.station.name,
                  style: context.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                GestureDetector(
                  onTap: _togglePlayPause,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).secondaryHeaderColor,
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 40,
                      color: Theme.of(context).cardColor,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  isPlaying ? 'جاري التشغيل' : 'متوقف',
                  style: context.textTheme.titleLarge,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
