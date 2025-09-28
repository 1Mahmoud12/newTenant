part of 'notifications_cubit.dart';

abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsSuccess extends NotificationsState {}

class NotificationsError extends NotificationsState {
  final String e;

  NotificationsError({required this.e});
}
