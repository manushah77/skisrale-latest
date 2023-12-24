import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:skisreal/BotttomNavigation/custom_bottom_navigation_bar_screen.dart';
import 'package:uni_links/uni_links.dart';

class DeepLinkHandler {
  // Define your deep link structure
  static const String deepLinkPrefix = 'https://sk.jeuxtesting.com/';

  // Function to initialize deep link handling
  static Future<void> initDeepLinks() async {
    try {
      String? initialLink = await getInitialLink();
      handleLink(initialLink!);
    } on PlatformException {
      // Handle exception
    }

    // Listen for deep links while the app is running
    getLinksStream().listen((String link) {
      handleLink(link);
    } as void Function(String? event)?);
  }

  // Function to handle deep link
  static void handleLink(String link) {
    if (link != null && link.startsWith(deepLinkPrefix)) {
      // Extract post ID from the deep link
      String postId = link.substring(deepLinkPrefix.length);

      // Now, you can navigate to the specific post using the post ID
      navigateToPost(postId);
    }
  }

  // Function to navigate to the specific post
  static void navigateToPost(String postId) {
    // Implement your navigation logic here
    // For example, you can use the Navigator to push a new screen
    // Replace the code below with your actual navigation logic
    print('Navigating to post with ID: $postId');
    Get.to((CustomBottomBar(index: 3,),),);
  }
}
