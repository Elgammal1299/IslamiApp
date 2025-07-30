import 'package:flutter/material.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/feature/home/data/model/recording_model.dart';
import 'package:islami_app/feature/home/ui/view/widget/recording_row_widget.dart';

class RecordingListWidget extends StatelessWidget {
  final List<RecordingModel> recordings;
  final String? currentlyPlayingKey;
  final void Function(String key) onPlayRequest;
  final void Function(String key) onStopRequest;
  final void Function(RecordingModel rec) onDelete;
  const RecordingListWidget({
    super.key,
    required this.recordings,
    required this.currentlyPlayingKey,
    required this.onPlayRequest,
    required this.onStopRequest,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (recordings.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 64,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 12),
          Text("لا توجد تسجيلات محفوظة", style: context.textTheme.titleLarge),
        ],
      );
    }
    final reversed = recordings.reversed.toList();
    return ListView.builder(
      itemCount: reversed.length,
      itemBuilder: (context, i) {
        final rec = reversed[i];
        return RecordingRowWidget(
          recording: rec,
          onDelete: () => onDelete(rec),
          currentlyPlayingKey: currentlyPlayingKey,
          onPlayRequest: onPlayRequest,
          onStopRequest: onStopRequest,
        );
      },
    );
  }
}
