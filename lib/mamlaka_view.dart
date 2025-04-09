import 'dart:async';
import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mamlaka/core/utils/constants.dart';
import 'package:mamlaka/core/utils/errorLoadingWidgets/stop_internet_widget.dart';
import 'package:mamlaka/core/utils/notification/notification.dart';

import 'main.dart';

class MamlakaApp extends StatefulWidget {
  const MamlakaApp({super.key});

  @override
  State<MamlakaApp> createState() => _MamlakaAppState();
}

class _MamlakaAppState extends State<MamlakaApp> {
  int currentIndex = 0;

  late StreamSubscription<List<ConnectivityResult>> subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        Future.delayed(
          const Duration(seconds: 10),
          () {
            subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
              if (result[0] == ConnectivityResult.none) {
                Constants.noInternet = true;
                log('We Are Here');
                // context.navigateToPage(const StopInternetWidget());
                navigatorKey.currentState!.push(
                  MaterialPageRoute(
                    builder: (context) => const StopInternetWidget(),
                  ),
                );
              } else {
                if (Constants.noInternet) {
                  navigatorKey.currentState!.pop();
                }
                Constants.noInternet = false;
              }
              setState(() {});
              log('connectivity ${result[0]}==== ${Constants.noInternet}');
            });
          },
        );
      },
    );
  }

  @override
  void didChangeDependencies() async {
    if (currentIndex == 0) {
      await initNotification();
      await selectTokens();
      currentIndex++;
    }
    super.didChangeDependencies();
  }

  Future<void> initNotification() async {
    await Future.delayed(Duration.zero, () async {
      //setup notification callback here
      await NotificationUtility.setUpNotificationService(context);
    });

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationUtility.onActionReceivedMethod,
      onNotificationCreatedMethod: NotificationUtility.onNotificationCreatedMethod,
      onNotificationDisplayedMethod: NotificationUtility.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: NotificationUtility.onDismissActionReceivedMethod,
    );

    notificationTerminatedBackground();
  }

  void notificationTerminatedBackground() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      debugPrint('Global Message ${Constants.messageGlobal?.data}');
      if (Constants.messageGlobal?.data != null) {
        debugPrint('Global Message Enter${Constants.messageGlobal?.data}');

        Future.delayed(const Duration(milliseconds: 1000), () async {
          NotificationUtility.onTapNotificationScreenNavigateCallback(
            Constants.messageGlobal!.data['type'] ?? '',
            Constants.messageGlobal!.data,
          );
          Constants.messageGlobal = null;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return appStartScreen;
  }
}
