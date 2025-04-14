import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart';
import 'package:dobzz_seller/core/network/local/cache.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/core/utils/device_id.dart';

enum NotificationType { Order, Inbox, Announcement }

// ignore: avoid_classes_with_only_static_members
class NotificationUtility {
  static String generalNotificationType = 'general';

  static String assignmentNotificationType = 'assignment';
  static RemoteMessage? remoteMessageGlobal;
  static AwesomeNotifications awesomeNotification = AwesomeNotifications();

  static Future<void> setUpNotificationService(
    BuildContext buildContext,
  ) async {
    NotificationSettings notificationSettings = await Constants.messaging.getNotificationSettings();
    //ask for permission
    if (notificationSettings.authorizationStatus == AuthorizationStatus.notDetermined ||
        notificationSettings.authorizationStatus == AuthorizationStatus.denied) {
      notificationSettings = await Constants.messaging.requestPermission(
        //provisional: true,
        announcement: true,
      );

      //if permission is provisionnal or authorised
      if (notificationSettings.authorizationStatus == AuthorizationStatus.authorized ||
          notificationSettings.authorizationStatus == AuthorizationStatus.provisional) {
        if (buildContext.mounted) {
          debugPrint('===== 1 ======');
          initNotificationListener(buildContext);
        }
      }

      //if permission denied
    } else if (notificationSettings.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }
    if (buildContext.mounted) {
      debugPrint('===== 2 ======');
      initNotificationListener(buildContext);
    }
  }

  static int count = 0;

  static void initNotificationListener(BuildContext buildContext) {
    Constants.messaging.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    FirebaseMessaging.onMessage.listen((remoteMessage) async {
      if (Platform.isAndroid) {
        createLocalNotification(dismissible: true, message: remoteMessage);
      }
      // BlocProvider.of<HomeCubit>(navigatorKey.currentState!.context).getNotificationCount();

      debugPrint('remoteMessage===>${remoteMessage.toMap()}');
    });
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      log('onMessageOpenedAppListener');

      if (count == 0) {
        onMessageOpenedAppListener(remoteMessage);
        // onTapNotificationScreenNavigateCallback(remoteMessage.dataSource['type'] ?? '', remoteMessage.dataSource);
        //   BlocProvider.of<HomeCubit>(navigatorKey.currentState!.context).getNotificationCount();

        count++;
        Future.delayed(
          const Duration(seconds: 4),
          () {
            log('count cdelayed');

            count = 0;
          },
        );
      }

      log('count count $count');
    });
  }

  static Future<void> onBackgroundMessage(RemoteMessage remoteMessage) async {
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // ).then((value) {
    //   FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
    // });

    //onMessageOpenedAppListener(remoteMessage);
    /* if (Platform.isAndroid) {
      createLocalNotification(dimissable: true, message: remoteMessage);
    }*/

    //perform any background task if needed here
    /*remoteMessageGlobal = remoteMessage;
    debugPrint('_onTapNotificationScreenNavigateCallback BackGround $remoteMessageGlobal');

    onTapNotificationScreenNavigateCallback(
      remoteMessage.dataSource['type'] ?? '',
      remoteMessage.dataSource,
    );*/
  }

/*  static Future<void> foregroundMessageListener(
    RemoteMessage remoteMessage,
  ) async {
    await AppConst.messaging.getToken();
    createLocalNotification(dimissable: true, message: remoteMessage);
  }*/

  static void onMessageOpenedAppListener(
    RemoteMessage remoteMessage,
  ) {
    debugPrint('onMessageOpenedAppListener $remoteMessage');

    onTapNotificationScreenNavigateCallback(
      remoteMessage.data['type'] ?? '',
      remoteMessage.data,
    );
  }

  static void onTapNotificationScreenNavigateCallback(
    String notificationType,
    Map<String, dynamic> data,
  ) async {
    debugPrint('onTapNotificationScreenNavigateCallback $data');

    /* if (notificationType == NotificationType.Order.name) {
      log('======== Order =======');
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => DetailsOrderView(
            orderId: int.parse(data['orderId'] ?? '-1'),
            orderHistory: true,
            statusOrder: MyBookingStatus.active.name.tr(),
            pageController: 0,
          ),
        ),
      );
    } else if (notificationType == NotificationType.Inbox.name) {
      log('======== Inbox =======');
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => const InboxView(),
        ),
      );
    } else if (notificationType == NotificationType.Announcement.name) {
      log('======== Announcement =======');
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => const AnnouncementView(),
        ),
      );
    } else {}*/
  }

  /*static Future<bool> isLocalNotificationAllowed() async {
    const notificationPermission = Permission.notification;
    final status = await notificationPermission.status;
    return status.isGranted;
  }*/

  /// Use this method to detect when a new notification or a schedule is created
  static Future<void> onNotificationCreatedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  static Future<void> onDismissActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    debugPrint('===ACTION RECEIVED===');

    debugPrint("${receivedAction.payload?['data']}");

    final data = jsonDecode(receivedAction.payload!['data']!)['data'];
    final notificationType = data['type'];

    // final titleMessage = jsonDecode(receivedAction.payload!['dataSource']!)['title'];
    // final dataSource = jsonDecode(receivedAction.payload!['dataSource']!);
    /*   if (notificationType == NotificationType.Order.name) {
      log('======== Order =======');
      navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (context) => DetailsOrderView(
            orderId: int.parse(data['orderId'] ?? '-1'),
            orderHistory: true,
            statusOrder: MyBookingStatus.active.name.tr(),
            pageController: 0,
          ),
        ),
      );
    } else if (notificationType == NotificationType.Inbox.name) {
      log('======== Inbox =======');
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => const InboxView(),
        ),
      );
    } else if (notificationType == NotificationType.Announcement.name) {
      log('======== Announcement =======');
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => const AnnouncementView(),
        ),
      );
    } else {}*/

    /*_onTapNotificationScreenNavigateCallback(
      (receivedAction.payload ?? {})['type'] ?? '',
      Map.from(
        receivedAction.payload ?? {},
      ),
    );*/
  }

  static Future<void> sendMessageNotification({
    required String namePerson,
    required String body,
    required String tokenUser,
  }) async {
    try {
      final Response response = await post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAcQAIiSY:APA91bHPRzIe__QC3eOtgvTce0FLo_crabHtjFDYazI212td_Aj3flr3LqCYFDcZDL4asKAX9-RYrrDJP6mtesucuB3ksOfiAwbPX97DJMpwp52wjaoLxB4h50r-kaJXbIo6wOfTP6-8',
        },
        body: jsonEncode(
          {
            'notification': <String, dynamic>{
              'title': namePerson,
              'body': body,
              'sound': 'alarm',
            },
            'priority': 'high',
            //'data': <String, dynamic>{'click_action': action, 'token': tokenMeeting, 'User': jsonEncode(modelUser.toMap()), 'status': 'done'},
            'to': tokenUser,
          },
        ),
      );

      debugPrint(jsonDecode(response.body));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> initializeAwesomeNotification() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: Constants.notificationChannelKey,
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          //vibrationPattern: highVibrationPattern,
          //soundSource: 'resource://raw/notification',
          importance: NotificationImportance.High,
          channelShowBadge: true,
          playSound: true,
        ),
      ],
    );
  }

  static Future<void> createLocalNotification({
    required bool dismissible,
    required RemoteMessage message,
  }) async {
    final String title = message.data['title'] ?? 'no title ';
    final String body = message.data['body'] ?? 'no body found';
    //  final String? image = message.toMap()['notification']['android']['imageUrl'];
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        autoDismissible: dismissible,
        title: title,
        body: body,
        id: 1,
        locked: !dismissible,

        payload: {'data': jsonEncode(message.toMap())},
        channelKey: Constants.notificationChannelKey,
        customSound: 'resource://raw/notification',
        wakeUpScreen: true,
        //  largeIcon: image,
        roundedLargeIcon: true,
        hideLargeIconOnExpand: true,
        //bigPicture: image,
        //notificationLayout: NotificationLayout.Default,
      ),
    );
  }
}

Future<Map> loadJsonFile() async {
  final String response = await rootBundle.loadString('assets/services/gazar-21127-firebase-adminsdk-j5y44-5ac7ce9b3e.json');
  final data = json.decode(response);
  return data;
}

Future<void> sendFCMMessage({
  required String token,
  required String title,
  required String body,
  required String type,
  Map<String, dynamic>? data,
}) async {
//  final serviceAccountFile = File('assets/services/codgoo-12e2d-firebase-adminsdk-gxigy-d3e7342fc4.json');
  // final serviceAccountJson = json.decode(await serviceAccountFile.readAsString());

  final accountCredentials = ServiceAccountCredentials.fromJson(Constants.jsonServerKey);

  final authClient = await clientViaServiceAccount(accountCredentials, ['https://www.googleapis.com/auth/firebase.messaging']);
  final serverKey = authClient.credentials.accessToken.data; // FCM message payload
  data ??
      {}.addAll({
        'title': title,
        'body': body,
        'type': type,
      });
  final message = jsonEncode({
    'message': {
      'token': token,
      'dataSource': data,
      'notification': {
        'body': 'to_client',
        'title': 'notification',
        // "image": "https://dummyimage.com/96x96.png"
        // "sound":"notification.aac"
      },
      'apns': {
        'payload': {
          'aps': {'mutable-content': 1, 'sound': 'notification.wav'},
        },
      },
      // "mutable_content": true,
    },
  });

  // Send the FCM request
  final response = await authClient.post(
    Uri.parse('https://fcm.googleapis.com/v1/projects/codgoo-12e2d/messages:send'),
    headers: {
      'Authorization': 'Bearer $serverKey',
      'Content-Type': 'application/json',
    },
    body: message,
  );

  if (response.statusCode == 200) {
    log('FCM message sent successfully ${response.body}');
  } else {
    log('FCM message failed: ${response.statusCode} ${response.body}');
  }
}

Future<void> selectTokens() async {
  Constants.messaging.requestPermission(
    // provisional: true,
    announcement: true,
  );
  if (Platform.isIOS) {
    await Constants.messaging.requestPermission(
      //provisional: true,
      announcement: true,
    );
    await Constants.messaging.getAPNSToken();
  }
  final String newToken = await Constants.messaging.getToken() ?? '';
  if (newToken != Constants.fcmToken) {
    log('Need Get Token');
    Constants.fcmToken = newToken;
    Constants.deviceId = await DeviceUUid().getUniqueDeviceId();
    if (userCacheValue.data != null) {
      //HomeDataSourceImpl().updateFcmToken(fcmToken: Constants.fcmToken, deviceId: Constants.deviceId);
    }
    userCache?.put(fcmTokenKey, Constants.fcmToken);
    userCache?.put(deviceIdKey, Constants.deviceId);
  }
  debugPrint('Device Id ===> ${Constants.deviceId}');
  debugPrint('FCM ===> ${Constants.fcmToken}');
}
