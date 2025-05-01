import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:dobzz_seller/core/utils/app_images.dart';
import 'package:dobzz_seller/core/utils/errorLoadingWidgets/empty_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Group notifications by date
    final notificationGroups = [
      NotificationGroup(
        date: 'Today',
        notifications: [
          NotificationItem(
            icon: Icons.local_offer,
            title: '30% Special Discount!',
            subtitle: 'Special promotion only valid today.',
            iconColor: Colors.grey,
          ),
        ],
      ),
      NotificationGroup(
        date: 'Yesterday',
        notifications: [
          NotificationItem(
            icon: Icons.account_balance_wallet,
            title: 'Top Up E-wallet Successfully!',
            subtitle: 'You have top up your e-wallet.',
            iconColor: Colors.grey,
          ),
          NotificationItem(
            icon: Icons.location_on,
            title: 'New Service Available!',
            subtitle: 'Now you can track order in real-time.',
            iconColor: Colors.grey,
          ),
        ],
      ),
      NotificationGroup(
        date: 'June 7, 2023',
        notifications: [
          NotificationItem(
            icon: Icons.credit_card,
            title: 'Credit Card Connected!',
            subtitle: 'Credit card has been linked.',
            iconColor: Colors.grey,
          ),
          NotificationItem(
            icon: Icons.account_circle,
            title: 'Account Setup Successfully!',
            subtitle: 'Your account has been created.',
            iconColor: Colors.grey,
          ),
        ],
      ),
    ];

    return Scaffold(
      appBar: customAppBar(
        context: context,
        title: 'Notification'.tr(),
        actions: const SizedBox.shrink(),
      ),
      body:  Column(
        children: [
          EmptyWidget(
            data: 'You haven’t gotten any notifications yet!'.tr(),
            subData: 'We’ll alert you when something cool happens.'.tr(),
            emptyImage: EmptyImages.noNotificationYet,
          ),
        ],
      ),
      // body: ListView.builder(
      //   itemCount: notificationGroups.length,
      //   itemBuilder: (context, index) {
      //     return NotificationGroupWidget(
      //       group: notificationGroups[index],
      //     );
      //   },
      // ),
    );
  }
}

// Model class for notification item
class NotificationItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;

  NotificationItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
  });
}

// Model class for notification group
class NotificationGroup {
  final String date;
  final List<NotificationItem> notifications;

  NotificationGroup({
    required this.date,
    required this.notifications,
  });
}

// Widget for notification group
class NotificationGroupWidget extends StatelessWidget {
  final NotificationGroup group;

  const NotificationGroupWidget({
    Key? key,
    required this.group,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            group.date,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
        // Notification items
        ...group.notifications.map((notification) {
          final index = group.notifications.indexOf(notification);
          return Column(
            children: [
              NotificationItemWidget(notification: notification),
              // Add divider except after the last item in the group
              if (index < group.notifications.length - 1 || group != group) const Divider(height: 1),
            ],
          );
        }).toList(),
        // Add divider after each group except the last one
        if (group.date != 'June 7, 2023') // Assuming this is the last group
          Divider(
            height: 1,
            thickness: 0.7,
            color: Colors.grey.withOpacity(0.2),
          ),
      ],
    );
  }
}

// Widget for individual notification
class NotificationItemWidget extends StatelessWidget {
  final NotificationItem notification;

  const NotificationItemWidget({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            child: Icon(
              notification.icon,
              color: notification.iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
