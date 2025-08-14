import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/feature/notification/data/model/notification_model.dart';
import 'package:islami_app/feature/notification/data/repo/notification_repo.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  final _repo = NotificationRepo();

  Future<void> init() async {
    if (!isClosed) emit(NotificationLoading());
    try {
      final data = await _repo.getAllNotifications();
      if (!isClosed) emit(NotificationLoaded(data));
    } catch (e) {
      if (!isClosed) emit(NotificationError(e.toString()));
    }
  }

  Future<void> addNotification({
    required String title,
    required String body,
    required String type,
  }) async {
    try {
      await _repo.logNotification(title: title, body: body, type: type);
      final data = await _repo.getAllNotifications();
      if (!isClosed) emit(NotificationLoaded(data));
    } catch (e) {
      if (!isClosed) emit(NotificationError(e.toString()));
    }
  }

  Future<void> markAsRead(String key) async {
    try {
      await _repo.markAsRead(key);
      final data = await _repo.getAllNotifications();
      if (!isClosed) emit(NotificationLoaded(data));
    } catch (e) {
      if (!isClosed) emit(NotificationError(e.toString()));
    }
  }

  Future<void> clearAll() async {
    try {
      await _repo.clearAll();
      if (!isClosed) emit(NotificationLoaded([]));
    } catch (e) {
      if (!isClosed) emit(NotificationError(e.toString()));
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _repo.markAllAsRead();
      final data = await _repo.getAllNotifications();
      if (!isClosed) emit(NotificationLoaded(data));
    } catch (e) {
      if (!isClosed) emit(NotificationError(e.toString()));
    }
  }
}
