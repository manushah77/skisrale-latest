import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skisreal/BotttomNavigation/custom_bottom_navigation_bar_screen.dart';
import 'package:skisreal/Constant/dialoag_widget.dart';
import 'package:skisreal/LoginScreen/login_screen.dart';
import 'package:skisreal/service/service.dart';

class authentication_Controller extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  var logInformKey = GlobalKey<FormState>().obs;
  var passwordReset = GlobalKey<FormState>().obs;
  var isLoading = false.obs;
  loginUser(var userEmail, var userPass) async {
    try {
      isLoading(true);
      Map data = {
        "email": userEmail.toString(),
        "password": userPass.toString(),
      };
      await UserService().postApi("api/login", data).then((value) async {
        // print(value);
        if (value['status'] == "success") {
          if (value['user']['status'] == "0") {
            String token = value['data']['token'];
            String id = value['user']['id'].toString();
            String status = value['user']['status'].toString();

            // Store the token in SharedPreferences
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('token', token);
            prefs.setString('id', id);
            prefs.setString('status', status);

            // print(' My data is , $token');
            // print(' My iddddd is , $id');
            // print(' My status is , $status');
            email.clear();
            pass.clear();
            Get.offAll(() => CustomBottomBar(
              index: 3,

            ));



            Get.snackbar(
              value["status"].toString(),
              value["message"].toString(),
              icon: Icon(Icons.thumb_up),
              duration: Duration(seconds: 3),
              snackPosition:
                  SnackPosition.BOTTOM, // Optional: Position of the snackbar
              backgroundColor: Colors.grey.withOpacity(
                  0.5), // Optional: Background color of the snackbar
              // colorText: Colors.white, // Optional: Text color of the snackbar
            );
          }
          else if (value['user']['status'] == "1") {
            // User is blocked by admin
            email.clear();
            pass.clear();
            Get.snackbar(
              "Blocked by Admin",
              "You are blocked by the admin.",
              icon: Icon(Icons.block),
              duration: Duration(seconds: 3),
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.grey.withOpacity(0.5),
            );
          }

          else {
            email.clear();
            pass.clear();
            Get.snackbar(
              value["status"].toString(),
              value["message"].toString(),
              icon: Icon(Icons.thumb_down),
              duration: Duration(seconds: 3),
              snackPosition:
                  SnackPosition.BOTTOM, // Optional: Position of the snackbar
              backgroundColor: Colors.grey.withOpacity(
                  0.5), // Optional: Background color of the snackbar
              // colorText: Colors.white, // Optional: Text color of the snackbar
            );
          }
        }
        else {
          email.clear();
          pass.clear();
          Get.snackbar(
            value["status"].toString(),
            value["message"].toString(),
            icon: Icon(Icons.thumb_down),
            duration: Duration(seconds: 3),
            snackPosition:
                SnackPosition.BOTTOM, // Optional: Position of the snackbar
            backgroundColor: Colors.grey
                .withOpacity(0.5), // Optional: Background color of the snackbar
            // colorText: Colors.white, // Optional: Text color of the snackbar
          );
        }
      }
      );
    } finally {
      isLoading(false);
    }
  }

  ressetPass(var userEmail) async {
    try {
      isLoading(true);
      Map data = {"email": userEmail.toString()};
      await UserService().postApi("api/forgot", data).then((value) {
        // print(value);
        if (value['msg'] == "Reset password link sent on your email id.") {
          email.clear();
          pass.clear();
          Get.offAll(() => LoginScreen());
          Get.snackbar(
            "Success",
            value["msg"].toString(),
            icon: Icon(Icons.thumb_up),
            duration: Duration(seconds: 5),
            snackPosition:
                SnackPosition.BOTTOM, // Optional: Position of the snackbar
            backgroundColor: Colors.grey
                .withOpacity(0.5), // Optional: Background color of the snackbar
            // colorText: Colors.white, // Optional: Text color of the snackbar
          );
        } else {
          email.clear();
          pass.clear();
          Get.snackbar(
            value["status"].toString(),
            value["message"].toString(),
            icon: Icon(Icons.thumb_down),
            duration: Duration(seconds: 5),
            snackPosition:
                SnackPosition.BOTTOM, // Optional: Position of the snackbar
            backgroundColor: Colors.grey
                .withOpacity(0.5), // Optional: Background color of the snackbar
            // colorText: Colors.white, // Optional: Text color of the snackbar
          );
        }
      });
    } finally {
      isLoading(false);
    }
  }

  signUp(
      File UserImage,
      var userName,
      var userEmail,
      var userPass,
      var userNumber,
      var userGender,
      var userExperienceLevel,
      var userAge,
      var userExperience) async {}
}
