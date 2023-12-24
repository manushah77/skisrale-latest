import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:skisreal/BotttomNavigation/Screens/HomeScreen/detail_page.dart';
import 'package:skisreal/main.dart';

class NotificationService {
  static Future<void> init() async {
    AwesomeNotifications().initialize(
      'resource://drawable/launcher_icon',
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic notifications',
          defaultColor: Colors.teal,
          ledColor: Colors.teal,
          playSound: true,
          enableLights: true,
          enableVibration: true,
        ),
      ],
    );
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    if (receivedAction.actionType == ActionType.SilentAction ||
        receivedAction.actionType == ActionType.SilentBackgroundAction) {
      print(
          'Message sent via notification input: "${receivedAction.buttonKeyInput}"');
    } else {
      print('Message sent via notification ');
    }

    var payload = receivedAction.payload;

    if (payload?['postId'] != null) {
      int id = int.parse(payload!['postId']!);
      Future.delayed(Duration(seconds: 4), () {
        Navigator.of(navigatorKey.currentContext!).push(
          MaterialPageRoute(
            builder: (context) => DetailPage(feedID: id),
          ),
        );
      });
    }
  }

  Future<void> sendNotification(
      {required String title,
      required String body,
      required String picture,
      required String postId}) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();

    if (!isAllowed) {
      isAllowed = await displayNotificationRationale();
    }

    if (!isAllowed) {
      return;
    }

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 1,
          channelKey: 'basic_channel',
          title: title,
          body: body,
          largeIcon: picture,
          bigPicture: picture,
          payload: {
            'postId': postId,
          },
          notificationLayout: NotificationLayout.BigPicture),
    );
  }

  Future<bool> displayNotificationRationale() async {
    bool userAuthorized = false;
    BuildContext context = navigatorKey.currentContext!;
    await showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(
            'Get Notified!',
            style: Theme.of(context).textTheme.headline6,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/animated-bell.gif',
                      height: MediaQuery.of(context).size.height * 0.3,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Allow Awesome Notifications to send you beautiful notifications!',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text(
                'Deny',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () async {
                userAuthorized = true;
                Navigator.of(ctx).pop();
              },
              child: Text(
                'Allow',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: Colors.deepPurple),
              ),
            ),
          ],
        );
      },
    );
    return userAuthorized &&
        await AwesomeNotifications().requestPermissionToSendNotifications();
  }
}
