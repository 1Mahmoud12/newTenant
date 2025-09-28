import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:dobzz_seller/core/utils/errorLoadingWidgets/empty_widget.dart';
import 'package:dobzz_seller/core/utils/extensions.dart';
import 'package:dobzz_seller/feature/notification/data/models/notifications_model.dart';
import 'package:dobzz_seller/feature/notification/view/manager/notifications_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationsCubit()..fetchNotifications(),
      child: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          final cubit = context.read<NotificationsCubit>();
          return Scaffold(
            appBar: customAppBar(
              context: context,
              title: 'Notification'.tr(),
              actions: cubit.groups.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        cubit.markAllAsRead();
                      },
                      icon: const Icon(Icons.done_all),
                      tooltip: 'Mark all as read',
                    )
                  : const SizedBox.shrink(),
            ),
            body: switch (state) {
              NotificationsLoading() => const Center(child: CircularProgressIndicator()),
              NotificationsError() => Column(
                  children: [
                    EmptyWidget(
                      data: 'failed_to_load_notifications'.tr(),
                      subData: state.e,
                      emptyImage: EmptyImages.noNotificationYet,
                    ),
                  ],
                ),
              _ => cubit.groups.isEmpty
                  ? Column(
                      children: [
                        EmptyWidget(
                          data: 'You haven’t gotten any notifications yet!'.tr(),
                          subData: 'We’ll alert you when something cool happens.'.tr(),
                          emptyImage: EmptyImages.noNotificationYet,
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemCount: cubit.groups.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            NotificationItemWidget(
                              notification: cubit.groups[index],
                            ),
                            if (index < cubit.groups.length - 1)
                              Divider(
                                height: 1,
                                thickness: 0.7,
                                color: Colors.grey.withOpacityNew(0.2),
                              ),
                          ],
                        );
                      },
                    ),
            },
          );
        },
      ),
    );
  }
}

// Widget for individual notification
class NotificationItemWidget extends StatelessWidget {
  final ItemsNotificationModel notification;

  const NotificationItemWidget({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Mark notification as read when tapped
        if (notification.id != null) {
          context.read<NotificationsCubit>().markAsRead(notification.id!);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.notifications,
                color: Colors.grey,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title ?? 'Notification',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.body ?? '',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Add a small indicator for unread notifications
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
