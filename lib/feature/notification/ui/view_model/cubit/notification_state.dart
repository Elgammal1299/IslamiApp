part of 'notification_cubit.dart';

sealed class NotificationState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class NotificationInitial extends NotificationState {}

final class NotificationLoading extends NotificationState {}

final class NotificationLoaded extends NotificationState {
  final List<MapEntry<String, NotificationModel>> notifications;

  NotificationLoaded(this.notifications);
  @override
  List<Object?> get props => [notifications];
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);
  @override
  List<Object?> get props => [message];
}
