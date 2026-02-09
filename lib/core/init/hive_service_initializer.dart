import 'package:hive_flutter/hive_flutter.dart';
import 'package:islami_app/core/constant/app_constant.dart';
import 'package:islami_app/core/services/hive_service.dart';
import 'package:islami_app/feature/notification/data/model/notification_model.dart';
import 'package:islami_app/feature/khatmah/data/model/khatmah_model.dart';
import 'package:islami_app/feature/khatmah/utils/khatmah_constants.dart';

class HiveInitializer {
  Future<void> init() async {
    await Hive.initFlutter();
    
    // تسجيل الـ Adapters
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(NotificationModelAdapter());
    }
    
    // Khatmah Adapters - إضافة جديدة
    // Register in dependency order
    if (!Hive.isAdapterRegistered(KhatmahConstants.juzProgressTypeId)) {
      Hive.registerAdapter(JuzProgressAdapter());
    }
    if (!Hive.isAdapterRegistered(KhatmahConstants.dailyProgressTypeId)) {
      Hive.registerAdapter(DailyProgressAdapter());
    }
    if (!Hive.isAdapterRegistered(KhatmahConstants.khatmahModelTypeId)) {
      Hive.registerAdapter(KhatmahModelAdapter());
    }

    // فتح الـ Boxes
    await HiveService.instanceFor<NotificationModel>(
      boxName: AppConstant.hivenotifications,
    ).init();
    
    // Khatmah Box - إضافة جديدة
    await HiveService.instanceFor<KhatmahModel>(
      boxName: KhatmahConstants.khatmahBoxName,
      enableLogging: true,
    ).init();
  }
}