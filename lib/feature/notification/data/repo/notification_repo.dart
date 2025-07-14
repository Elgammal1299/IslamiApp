import 'package:islami_app/core/constant/app_constant.dart';
import 'package:islami_app/core/services/hive_service.dart';
import 'package:islami_app/feature/notification/data/model/notification_model.dart';

class NotificationRepo {
  final HiveService<NotificationModel> _service =
      HiveService.instanceFor<NotificationModel>(
        boxName: AppConstant.hivenotifications,
      );

  /// تسجّل إشعار جديد (مع isRead = false)
  Future<void> logNotification({
    required String title,
    required String body,
    required String type,
  }) async {
    final now = DateTime.now();

    // ✅ تجنّب تكرار الإشعارات المجدولة عند استلام إشعار Firebase
    if (type == "scheduled") {
      final existing = _service.toEntries().where(
        (entry) =>
            entry.value.title == title &&
            entry.value.body == body &&
            entry.value.type == "scheduled" &&
            now.difference(entry.value.dateTime).inMinutes.abs() <
                2, // خلال دقيقتين
      );
      if (existing.isNotEmpty) {
        return; // تم إضافته مؤخرًا.. تجاهل التكرار
      }
    }

    final key = 'notif_${now.toIso8601String()}';

    final model = NotificationModel(
      title: title,
      body: body,
      dateTime: now,
      type: type,
      isRead: false,
    );

    await _service.put(key, model);

    // 🧹 حافظ على آخر 10 إشعارات فقط
    final entries = _service.toEntries();
    if (entries.length > 10) {
      entries.sort(
        (a, b) => b.value.dateTime.compareTo(a.value.dateTime),
      ); // 👈 الأحدث أولاً
      final toDelete = entries.sublist(10);
      for (final entry in toDelete) {
        await _service.delete(entry.key);
      }
    }
  }

  /// ترجّع الإشعارات كلها مع ترتيبها من الأحدث إلى الأقدم
  Future<List<MapEntry<String, NotificationModel>>>
  getAllNotifications() async {
    final entries = _service.toEntries();
    entries.sort(
      (a, b) => b.value.dateTime.compareTo(a.value.dateTime),
    ); // 👈 ترتيب
    return entries;
  }

  /// حدّث إشعار كمقروء
  Future<void> markAsRead(String key) async {
    final notif = _service.get(key);
    if (notif != null && (notif.isRead ?? false) == false) {
      notif.isRead = true;
      await _service.put(key, notif);
    }
  }

  /// حذف كل الإشعارات
  Future<void> clearAll() async {
    await _service.clear();
  }

  /// تحديد الكل كمقروء
  Future<void> markAllAsRead() async {
    final entries = _service.toEntries();
    for (final entry in entries) {
      final model = entry.value;
      if (model.isRead != true) {
        model.isRead = true;
        await _service.put(entry.key, model);
      }
    }
  }

  /// تعديل إشعار (لو احتجته من الكيوبت)
  Future<void> updateNotification(String key, NotificationModel model) async {
    await _service.put(key, model);
  }
}
