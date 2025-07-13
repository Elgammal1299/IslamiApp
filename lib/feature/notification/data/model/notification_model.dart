import 'package:hive/hive.dart';

part 'notification_model.g.dart';

@HiveType(typeId: 1)
class NotificationModel extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String body;

  @HiveField(2)
  final DateTime dateTime;

  @HiveField(3)
  final String type; // firebase | scheduled

  NotificationModel({
    required this.title,
    required this.body,
    required this.dateTime,
    required this.type,
  });
}
