import 'package:bloc/bloc.dart';
import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:dobzz_seller/feature/notification/data/dataSource/notification_data_source.dart';
import 'package:dobzz_seller/feature/notification/data/models/notifications_model.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({NotificationDataSource? dataSource})
      : _dataSource = dataSource ?? NotificationDataSourceImpl(),
        super(NotificationsInitial());

  final NotificationDataSource _dataSource;

  List<ItemsNotificationModel> groups = [];

  Future<void> fetchNotifications() async {
    emit(NotificationsLoading());
    final result = await _dataSource.getNotifications();
    result.fold(
      (failure) {
        Utils.showToast(title: failure.errMessage, state: UtilState.error);
        emit(NotificationsError(e: failure.errMessage));
      },
      (data) {
        groups = data.data;
        emit(NotificationsSuccess());
      },
    );
  }

  Future<void> markAllAsRead() async {
    final result = await _dataSource.markAllRead();
    result.fold(
      (failure) {
        Utils.showToast(title: failure.errMessage, state: UtilState.error);
      },
      (success) {
        Utils.showToast(title: success, state: UtilState.success);
        // Refresh notifications after marking all as read
        fetchNotifications();
      },
    );
  }

  Future<void> markAsRead(String notificationId) async {
    final result = await _dataSource.markAsRead(notificationId: notificationId);
    result.fold(
      (failure) {
        Utils.showToast(title: failure.errMessage, state: UtilState.error);
      },
      (success) {
        Utils.showToast(title: success, state: UtilState.success);
        // Refresh notifications after marking as read
        fetchNotifications();
      },
    );
  }
}
