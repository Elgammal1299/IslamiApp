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
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:islami_app/feature/home/ui/view_model/audio_recording_cubit/audio_recording_cubit.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:islami_app/core/services/hive_service.dart';
// import 'package:islami_app/feature/home/data/model/recording_model.dart';
// import 'package:audio_waveforms/audio_waveforms.dart';

// class AudioRecordingScreen extends StatefulWidget {
//   const AudioRecordingScreen({super.key});

//   @override
//   State<AudioRecordingScreen> createState() => _AudioRecordingScreenState();
// }

// class _AudioRecordingScreenState extends State<AudioRecordingScreen> {
//   final AudioPlayer _player = AudioPlayer();
//   final audioService = HiveService.instanceFor<RecordingModel>("audioBox");
//   late RecorderController _recorderController;
//   late List<PlayerController> _playerControllers = [];
//   int? _currentlyPlayingIndex;

//   List<RecordingModel> recordings = [];

//   @override
//   void initState() {
//     super.initState();
//     _initRecorder();
//     loadRecordings();
//   }

//   void _initRecorder() {
//     _recorderController =
//         RecorderController()
//           ..androidEncoder = AndroidEncoder.aac
//           ..androidOutputFormat = AndroidOutputFormat.mpeg4
//           ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
//           ..sampleRate = 44100;
//   }

//   Future<void> loadRecordings() async {
//     final data = await audioService.getAll();
//     setState(() {
//       recordings = data;
//       _playerControllers = List.generate(
//         data.length,
//         (index) => PlayerController(),
//       );
//     });
//   }

//   Future<void> _playRecording(int index) async {
//     if (_currentlyPlayingIndex != null) {
//       await _playerControllers[_currentlyPlayingIndex!].stopPlayer();
//     }

//     setState(() {
//       _currentlyPlayingIndex = index;
//     });

//     await _playerControllers[index].preparePlayer(
//       path: recordings[index].filePath,
//     );
//     await _playerControllers[index].startPlayer();

//     // _playerControllers[index].onPlayerStateChanged.listen((state) {
//     //   if (state == PlayerState.stopped) {
//     //     setState(() {
//     //       _currentlyPlayingIndex = null;
//     //     });
//     //   }
//     // });
//   }

//   @override
//   void dispose() {
//     _player.dispose();
//     _recorderController.dispose();
//     for (var controller in _playerControllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       appBar: AppBar(
//         title: const Text('🎤 تسجيل الصوت'),
//         backgroundColor: const Color(0xFF2B6777),
//         foregroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // موجة الصوت أثناء التسجيل
//             BlocBuilder<AudioRecordingCubit, AudioRecordingState>(
//               builder: (context, state) {
//                 if (state is AudioRecording) {
//                   return Container(
//                     margin: const EdgeInsets.all(16),
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: const [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 12,
//                           offset: Offset(0, 6),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       children: [
//                         AudioWaveforms(
//                           size: const Size(double.infinity, 100),
//                           recorderController: _recorderController,
//                           waveStyle: const WaveStyle(
//                             waveColor: Color(0xFF52AB98),
//                             showMiddleLine: true,
//                             extendWaveform: true,
//                             spacing: 6.0,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         Text(
//                           'جاري التسجيل...',
//                           style: TextStyle(
//                             color: Colors.grey[700],
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//                 return const SizedBox.shrink();
//               },
//             ),

//             // التسجيلات المحفوظة
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: Align(
//                 alignment: Alignment.centerRight,
//                 child: Text(
//                   "📂 التسجيلات المحفوظة",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                     color: Colors.blueGrey,
//                   ),
//                 ),
//               ),
//             ),

//             // قائمة التسجيلات
//             Expanded(
//               child:
//                   recordings.isEmpty
//                       ? Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.audio_file_outlined,
//                               size: 60,
//                               color: Colors.grey[400],
//                             ),
//                             const SizedBox(height: 16),
//                             const Text(
//                               "لا توجد تسجيلات بعد",
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 18,
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                       : RefreshIndicator(
//                         onRefresh: loadRecordings,
//                         child: ListView.builder(
//                           itemCount: recordings.length,
//                           padding: const EdgeInsets.symmetric(horizontal: 16),
//                           itemBuilder: (context, index) {
//                             final recording = recordings[index];
//                             return Card(
//                               elevation: 2,
//                               margin: const EdgeInsets.symmetric(vertical: 8),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(12.0),
//                                 child: Row(
//                                   children: [
//                                     IconButton(
//                                       icon: Icon(
//                                         _currentlyPlayingIndex == index
//                                             ? Icons.pause_circle_filled
//                                             : Icons.play_circle_fill,
//                                         size: 32,
//                                         color: const Color(0xFF52AB98),
//                                       ),
//                                       onPressed: () async {
//                                         if (_currentlyPlayingIndex == index) {
//                                           await _playerControllers[index]
//                                               .pausePlayer();
//                                           setState(() {
//                                             _currentlyPlayingIndex = null;
//                                           });
//                                         } else {
//                                           await _playRecording(index);
//                                         }
//                                       },
//                                     ),
//                                     const SizedBox(width: 12),
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "تسجيل ${index + 1}",
//                                             style: const TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                           const SizedBox(height: 4),
//                                           Text(
//                                             recording.createdAt.toString(),
//                                             style: TextStyle(
//                                               color: Colors.grey[600],
//                                               fontSize: 12,
//                                             ),
//                                           ),
//                                           const SizedBox(height: 8),
//                                           AudioFileWaveforms(
//                                             playerController:
//                                                 _playerControllers[index],
//                                             size: const Size(
//                                               double.infinity,
//                                               30,
//                                             ),
//                                             enableSeekGesture: true,
//                                             waveformType: WaveformType.fitWidth,
//                                             playerWaveStyle:
//                                                 const PlayerWaveStyle(
//                                                   fixedWaveColor: Color(
//                                                     0xFF2B6777,
//                                                   ),
//                                                   liveWaveColor: Color(
//                                                     0xFF52AB98,
//                                                   ),
//                                                   waveThickness: 3.0,
//                                                   seekLineColor: Color(
//                                                     0xFF2B6777,
//                                                   ),
//                                                 ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     IconButton(
//                                       icon: const Icon(
//                                         Icons.delete_outline,
//                                         color: Colors.red,
//                                       ),
//                                       onPressed: () async {
//                                         // await audioService.delete(recording.id);
//                                         await loadRecordings();
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.only(right: 32, bottom: 24),
//         child: Align(
//           alignment: Alignment.bottomRight,
//           child: BlocConsumer<AudioRecordingCubit, AudioRecordingState>(
//             listener: (context, state) {
//               if (state is AudioRecorded) {
//                 loadRecordings();
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text("تم حفظ التسجيل بنجاح"),
//                     duration: Duration(seconds: 2),
//                   ),
//                 );
//               } else if (state is AudioRecordingError) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text("خطأ: ${state.message}"),
//                     backgroundColor: Colors.red,
//                   ),
//                 );
//               }
//             },
//             builder: (context, state) {
//               final isRecording = state is AudioRecording;
//               return FloatingActionButton.extended(
//                 onPressed: () async {
//                   if (isRecording) {
//                     final path = await _recorderController.stop();
//                     if (path != null) {
//                       // context.read<AudioRecordingCubit>().stopRecording(path);
//                     }
//                   } else {
//                     await _recorderController.record();
//                     context.read<AudioRecordingCubit>().startRecording();
//                   }
//                 },
//                 label: Text(isRecording ? "إيقاف التسجيل" : "تسجيل جديد"),
//                 icon: Icon(isRecording ? Icons.stop : Icons.mic),
//                 backgroundColor:
//                     isRecording ? Colors.red : const Color(0xFF52AB98),
//                 elevation: 4,
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
