// lib/feature/home/ui/view/radio_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/feature/home/data/model/radio_model.dart';
import 'package:islami_app/feature/home/ui/view_model/radio_cubit/radio_cubit.dart';
class RadioPage extends StatefulWidget {
  static const String routeName = '/radio';

  const RadioPage({Key? key}) : super(key: key);

  @override
  State<RadioPage> createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  @override
  void initState() {
    super.initState();
    context.read<RadioCubit>().loadRadioStations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'إذاعة القرآن',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.teal.shade50,
              Colors.white,
            ],
          ),
        ),
        child: BlocBuilder<RadioCubit, RadioState>(
          builder: (context, state) {
            if (state is RadioLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is RadioError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<RadioCubit>().loadRadioStations();
                      },
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }

            if (state is RadioLoaded) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.stations.length,
                itemBuilder: (context, index) {
                  final station = state.stations[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RadioPlayerPage(
                              station: station,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.teal.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person,
                              color: Colors.teal.shade700,
                            ),
                          ),
                          title: Text(
                            station.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Icon(
                            Icons.play_circle_filled,
                            color: Colors.teal.shade300,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class RadioPlayerPage extends StatefulWidget {
  final RadioModel station;

  const RadioPlayerPage({
    Key? key,
    required this.station,
  }) : super(key: key);

  @override
  State<RadioPlayerPage> createState() => _RadioPlayerPageState();
}

class _RadioPlayerPageState extends State<RadioPlayerPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _playStation();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopStation();
    super.dispose();
  }

  Future<void> _playStation() async {
    await context.read<RadioCubit>().playStation(widget.station.url);
  }

  Future<void> _stopStation() async {
    await context.read<RadioCubit>().stopPlaying();
  }

  Future<void> _togglePlayPause() async {
    final cubit = context.read<RadioCubit>();
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
    return WillPopScope(
      onWillPop: () async {
        await _stopStation();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          // ... AppBar configuration
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.teal.shade50, Colors.white],
            ),
          ),
          child: BlocBuilder<RadioCubit, RadioState>(
            buildWhen: (previous, current) {
              // إعادة البناء فقط عند تغيير حالة التشغيل
              return current is RadioPlaying || 
                     (previous is RadioPlaying && current is! RadioPlaying);
            },
            builder: (context, state) {
              final bool isPlaying = state is RadioPlaying && 
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
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    GestureDetector(
                      onTap: _togglePlayPause,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.teal.shade100,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.teal.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 40,
                          color: Colors.teal.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      isPlaying ? 'جاري التشغيل' : 'متوقف',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.teal.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
