import 'package:islami_app/core/services/hive_service.dart';
import 'package:islami_app/feature/notification/data/model/notification_model.dart';

class NotificationRepo {
  Future<void> logNotification({
    required String title,
    required String body,
    required String type,
  }) async {
    final service = HiveService.instanceFor<NotificationModel>(
      boxName: 'notifications',
    );
    // if (!service.isOpen) await service.init();

    final now = DateTime.now();
    final key = 'notif_${now.toIso8601String()}'; // مفتاح زمني فريد

    final model = NotificationModel(
      title: title,
      body: body,
      dateTime: now,
      type: type,
    );

    await service.put(key, model);

    // لو العدد زاد عن 10، احذف الأقدم
    final entries = service.toEntries(); // MapEntry<String, NotificationModel>
    if (entries.length > 10) {
      final sorted =
          entries..sort((a, b) => a.value.dateTime.compareTo(b.value.dateTime));

      final toDelete = sorted.sublist(0, entries.length - 10);
      for (final entry in toDelete) {
        await service.delete(entry.key);
      }
    }
  }
}
