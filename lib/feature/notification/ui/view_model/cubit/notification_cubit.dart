import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/services/hive_service.dart';
import 'package:islami_app/feature/notification/data/model/notification_model.dart';
import 'package:islami_app/feature/notification/data/repo/notification_repo.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());
  final _repo = NotificationRepo();
  final _service = HiveService.instanceFor<NotificationModel>(
    boxName: 'notifications',
  );

  Future<void> init() async {
    emit(NotificationLoading());
    try {
      // await _service.init();
      final data = await _service.getAll();
      emit(NotificationLoaded(data));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> addNotification({
    required String title,
    required String body,
    required String type,
  }) async {
    try {
      await _repo.logNotification(title: title, body: body, type: type);
      final data = await _service.getAll();
      emit(NotificationLoaded(data));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> clearAll() async {
    try {
      await _service.clear();
      emit(NotificationLoaded([]));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
}
