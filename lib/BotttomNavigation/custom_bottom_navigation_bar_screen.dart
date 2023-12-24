import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:skisreal/BotttomNavigation/Screens/AddReportScreen/add_report_screen.dart';
import 'package:skisreal/BotttomNavigation/Screens/FavoriteScreen/favorite_screen.dart';
import 'package:skisreal/BotttomNavigation/Screens/HomeScreen/home_screen.dart';
import 'package:skisreal/BotttomNavigation/Screens/SearchScreen/search_screen.dart';
import 'package:skisreal/BotttomNavigation/Screens/SiteScreen/sitesScreen.dart';
import 'package:skisreal/LoginScreen/login_screen.dart';


class CustomBottomBar extends StatefulWidget {
  int index = 3;
   CustomBottomBar({required this.index});

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  @override
  Widget build(BuildContext context) {
    PersistentTabController _controller;

    _controller = PersistentTabController(initialIndex: widget.index);

    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      onItemSelected: (v) {
        print(v);
        if (v == 2) {}
      },
      popAllScreensOnTapAnyTabs: false,
      popAllScreensOnTapOfSelectedTab: false,
      // confineInSafeArea: true,
      backgroundColor: Colors.white,
      // Default is Colors.white.
      // handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset: true,
      // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true,
      // Default is true.
      hideNavigationBarWhenKeyboardShows: true,
      // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style3, // Choose the nav bar style with this property.
    );
  }

  List<Widget> _buildScreens() {
    return [
      AddReportScreen(),
      SearchScreen(),
      FavoriteScreen(),
      // SitesScreen(),
      HomeScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Image.asset(
          'assets/icons/add.png',
          scale: 4,
        ),
        // title: ("Home"),
        // activeColorPrimary: CupertinoColors.activeBlue,
        // inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset(
          'assets/icons/search.png',
          scale: 4,
        ),
        // title: ("Home"),
        // activeColorPrimary: CupertinoColors.activeBlue,
        // inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset(
          'assets/icons/Save.png',
          scale: 4,
        ),
        // title: ("Home"),
        // activeColorPrimary: CupertinoColors.activeBlue,
        // inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      // PersistentBottomNavBarItem(
      //   icon: Image.asset(
      //     'assets/icons/global.png',
      //     scale: 3,
      //     color: Color(0xff00B3D7).withOpacity(0.7),
      //   ),
      //   // title: ("Home"),
      //   // activeColorPrimary: CupertinoColors.activeBlue,
      //   // inactiveColorPrimary: CupertinoColors.systemGrey,
      // ),
      PersistentBottomNavBarItem(
        icon: Image.asset(
          'assets/icons/home-2.png',
          scale: 4,
        ),
        // title: ("Home"),
        // activeColorPrimary: CupertinoColors.activeBlue,
        // inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }
}
