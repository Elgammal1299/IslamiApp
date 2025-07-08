import 'package:hive/hive.dart';

part 'recording_model.g.dart';

@HiveType(typeId: 0)
class RecordingModel extends HiveObject {
  @HiveField(0)
  final String filePath;

  @HiveField(1)
  final DateTime createdAt;

  @HiveField(2)
  final int? duration; // duration in milliseconds

  RecordingModel({
    required this.filePath,
    required this.createdAt,
    required this.duration,
  });
}
