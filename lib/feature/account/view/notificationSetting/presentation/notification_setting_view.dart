import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:flutter/material.dart';

class NotificationsSettingsview extends StatefulWidget {
  const NotificationsSettingsview({Key? key}) : super(key: key);

  @override
  State<NotificationsSettingsview> createState() => _NotificationsSettingsviewState();
}

class _NotificationsSettingsviewState extends State<NotificationsSettingsview> {
  // Store switch values
  Map<String, bool> switchValues = {
    'General Notifications': true,
    'Sound': true,
    'Vibrate': false,
    'Special Offers': true,
    'Promo & Discounts': false,
    'Payments': false,
    'Cashback': true,
    'App Updates': false,
    'New Service Available': true,
    'New Tips Available': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: 'Notification'),
      body: ListView.separated(
        itemCount: switchValues.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          indent: 16,
          endIndent: 16,
          color: Colors.grey.withOpacity(0.2),
        ),
        itemBuilder: (context, index) {
          final String key = switchValues.keys.elementAt(index);
          return ListTile(
            title: Text(
              key,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            trailing: SizedBox(
              height: 45,
              child: FittedBox(
                child: Switch(
                  value: switchValues[key]!,
                  onChanged: (bool value) {
                    setState(() {
                      switchValues[key] = value;
                    });
                  },
                  trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
                  activeTrackColor: Colors.black,
                  activeColor: Colors.white,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey.shade300,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          );
        },
      ),
    );
  }
}
