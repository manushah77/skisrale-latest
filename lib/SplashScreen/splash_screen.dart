import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skisreal/BotttomNavigation/custom_bottom_navigation_bar_screen.dart';
import 'package:skisreal/Constant/dialoag_widget.dart';
import 'package:skisreal/LoginScreen/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:skisreal/controller/splash_controller.dart';
import '../BotttomNavigation/Models/commentModel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // String? token;
  // String? status;
  var controller = Get.put(Splash_Controller());


  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 2), () {
      print("i am here");
      controller.retrieveToken().then((value) {
        print(" i am token Function");
        controller.fetchCurrentUser();
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Version 1.0',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF172B4C),
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            letterSpacing: -0.56,
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage('assets/images/newGif.gif'),
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [],
        ),
      ),
    );
  }
}
