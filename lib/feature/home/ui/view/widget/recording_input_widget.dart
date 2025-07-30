import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/core/extension/theme_text.dart';

class RecordingInputWidget extends StatelessWidget {
  final bool isRecording;
  final String? error;
  final VoidCallback onRecord;
  final RecorderController recorderController;
  const RecordingInputWidget({
    super.key,
    required this.isRecording,
    required this.error,
    required this.onRecord,
    required this.recorderController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isRecording)
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColorDark,
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: AudioWaveforms(
                  enableGesture: false,
                  size: const Size(double.infinity, 60),
                  recorderController: recorderController,
                  waveStyle: WaveStyle(
                    waveColor: Theme.of(context).primaryColor,
                    showMiddleLine: false,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        GestureDetector(
          onTap: onRecord,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow:
                  isRecording
                      ? [
                        BoxShadow(
                          color: Theme.of(context).canvasColor,
                          blurRadius: 24,
                          spreadRadius: 2,
                        ),
                      ]
                      : [
                        BoxShadow(
                          color: Theme.of(context).primaryColor,
                          blurRadius: 16,
                          spreadRadius: 1,
                        ),
                      ],
            ),
            child: CircleAvatar(
              radius: 38,
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(
                isRecording ? Icons.stop : Icons.mic,
                color: AppColors.white,
                size: 36,
              ),
            ),
          ),
        ),
         const SizedBox(height: 8),
        Text(
          isRecording ? "جاري التسجيل..." : "اضغط لتسجيل جديد",
          style: context.textTheme.titleLarge,
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              "⚠️ $error",
              style: const TextStyle(color: AppColors.red),
            ),
          ),
      ],
    );
  }
}
