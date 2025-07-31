import 'package:islami_app/feature/notification/widget/local_notification_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationInitializer {
  Future<void> init() async {
    tz.initializeTimeZones();
    await LocalNotificationService.init();
  }
}
