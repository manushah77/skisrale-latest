// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:skisreal/BotttomNavigation/Models/search_class.dart';
// import 'package:skisreal/BotttomNavigation/Screens/HomeScreen/detail_page.dart';
// import 'package:skisreal/LoginScreen/login_screen.dart';
// import 'package:skisreal/SplashScreen/splash_screen.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'firebase_options.dart';
// import 'notification/NotificationService.dart';
//
// // Future<void> handleBackgroundMessage(RemoteMessage message) async {
// //   print("title: ${message.notification!.title}");
// //   print("body: ${message.notification!.body}");
// //   print("payload: ${message.data}");
// // }
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
//   SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(
//       systemNavigationBarIconBrightness: Brightness.light,
//       systemNavigationBarDividerColor: null,
//       statusBarColor: Colors.white,
//       statusBarIconBrightness: Brightness.dark,
//       statusBarBrightness: Brightness.light,
//     ),
//   );
//
//   MyAppFunction();
//
//
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   await _firebaseMessaging.requestPermission();
//   _firebaseMessaging.setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//   String? token = await _firebaseMessaging.getToken();
//   await FirebaseMessaging.instance.setAutoInitEnabled(true);
//   print("FCM Token: $token");
//
//   //subscribe to topic
//   await FirebaseMessaging.instance.subscribeToTopic('all');
//
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     print('Got a message whilst in the foreground!');
//     if (message.notification != null) {
//       notify(message);
//     }
//   });
//
//   runApp( MyApp());
// }
//
// Future<void> handleBackgroundMessage(RemoteMessage message) async {
//   print("Handling a background message: ${message.messageId}");
//   if (message.data.containsKey('url')) {
//     final url = message.data['url'];
//     // Extract and print the ID from the URL
//     print("ID from URL: ${extractIdFromUrl(url)}");
//   }
// }
//
// Future<void> notify(RemoteMessage message) async {
//   final NotificationService _notificationService = NotificationService();
//   await _notificationService.init();
//   await _notificationService.showNotification(
//     id: 0,
//     title: message.notification!.title!,
//     body: message.notification!.body!,
//   );
//   // Extract and print the ID from the URL
//   final url = message.data['url'];
//   print("ID from URL: ${extractIdFromUrl(url)}");
// }
//
// String extractIdFromUrl(String? url) {
//   // Implement the logic to extract the ID from the URL
//   // For example, if your URL is like "https://example.com/feed?id=123",
//   // you can extract the ID as follows:
//   if (url != null) {
//     Uri uri = Uri.parse(url);
//     if (uri.queryParameters.containsKey('id')) {
//       return uri.queryParameters['id']!;
//     }
//   }
//   return "ID not found";
// }
//
//
// void MyAppFunction() {
//   FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
//     if (message?.data.containsKey('website_url') == true) {
//       final url = message!.data['website_url'];
//       openURL(url);
//     }
//   });
//
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     print("onResume: ${message.data}");
//     if (message.data.containsKey('website_url')) {
//       final url = message.data['website_url'];
//       // Handle the URL here, e.g., show a dialog or navigate to a web view.
//       openURL(url);
//     }
//   });
// }
//
// // void openURL(String? url) async {
// //   if (url != null) {
// //     try {
// //       // Use a package like url_launcher to open the URL.
// //       await launchUrl(Uri.parse(url));
// //     } catch (e) {
// //       print('Error launching URL: $e');
// //     }
// //   } else {
// //     print('Invalid URL: $url');
// //   }
// // }
//
// void openURL(String? url) async {
//   if (url != null) {
//     try {
//       Uri uri = Uri.parse(url);
//       // Check if the URL contains information to navigate to the feed detail page
//       if (uri.pathSegments.contains('feed') && uri.queryParameters.containsKey('id')) {
//         String feedId = uri.queryParameters['id']!;
//         // Navigate to the FeedDetailPage
//         Navigator.push(
//           // Use the context from the currently running app
//           Get.context!,
//           MaterialPageRoute(
//             builder: (context) => DetailPage(feedID: int.parse(feedId.toString()),),
//           ),
//         );
//       } else {
//         // Handle other URLs as needed
//         await launchUrl(uri);
//       }
//     } catch (e) {
//       print('Error launching URL: $e');
//     }
//   } else {
//     print('Invalid URL: $url');
//   }
// }
//
//
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Handling a background message: ${message.messageId}");
//   if (message.data.containsKey('url')) {
//     final url = message.data['url'];
//     openURL(url);
//   }
// }
//
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: SplashScreen(),
//     );
//   }
// }
