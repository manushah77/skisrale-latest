import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skisreal/BotttomNavigation/Screens/HomeScreen/detail_page.dart';
import 'package:skisreal/SplashScreen/splash_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'firebase_options.dart';
import 'notification/NotificationService.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor: null,
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  MyAppFunction();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  await _firebaseMessaging.requestPermission();
  _firebaseMessaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  String? token = await _firebaseMessaging.getToken();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  print("FCM Token: $token");

  // Subscribe to topic
  await FirebaseMessaging.instance.subscribeToTopic('all');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      notify(message);
    }
  });

  runApp(MyApp());
}

// Future<void> handleBackgroundMessage(
//     RemoteMessage message, BuildContext context) async {
//   print("Handling a background message: ${message.messageId}");
//   if (message.data.containsKey('url')) {
//     final url = message.data['url'];
//     openURL(url);
//   }
// }

Future<void> notify(RemoteMessage message) async {

  String title = message.data['title'];
  String image = message.data['image'] ?? '';
  String url = message.data['website_url'] ?? "No URL provided";
  String body = message.data['description'] ?? '';
  String postId = extractIdFromUrl(url);

  await NotificationService.init();
  NotificationService().sendNotification(
    title: title,
    body: body ?? '',
    picture: image,
    postId: postId,
  );
}


String extractIdFromUrl(String? url) {
  if (url != null) {
    Uri uri = Uri.parse(url);
    if (uri.queryParameters.containsKey('id')) {
      return uri.queryParameters['id']!;
    }
  }
  return "ID not found";
}

void MyAppFunction() {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    notify(message);
  });

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      handleNotificationTap(message);
    }
  });
}

void handleNotificationTap(RemoteMessage message) {
  if (message.data.containsKey('website_url')) {
    final url = message.data['website_url'];
    openURL(url);
  }
}

void openURL(String? url) async {
  if (url != null) {
    try {
      Uri uri = Uri.parse(url);
      print('URL: $url');

      if (uri.pathSegments.contains('feed_detail') &&
          uri.queryParameters.containsKey('id')) {
        String feedId = uri.queryParameters['id']!;
        print('Feed ID Open Url: $feedId');

        Navigator.of(Get.context!).push(MaterialPageRoute(
          builder: (context) => DetailPage(feedID: int.parse(feedId)),
        ));
      } else {
        print('Launching URL: $url');
        await launch(url);
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  } else {
    print('Invalid URL: $url');
  }
}

// @pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  notify(message);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationService.onActionReceivedMethod,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: SplashScreen(),
    );
  }
}

