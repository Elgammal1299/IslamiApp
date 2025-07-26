import 'package:hive_flutter/hive_flutter.dart';
import 'package:islami_app/core/constant/app_constant.dart';
import 'package:islami_app/core/services/hive_service.dart';
import 'package:islami_app/feature/home/data/model/recording_model.dart';
import 'package:islami_app/feature/notification/data/model/notification_model.dart';

class HiveInitializer {
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(RecordingModelAdapter());
    Hive.registerAdapter(NotificationModelAdapter());

    await HiveService.instanceFor<RecordingModel>(
      boxName: AppConstant.hiveAudio,
    ).init();

    await HiveService.instanceFor<NotificationModel>(
      boxName: AppConstant.hivenotifications,
    ).init();
  }
}
