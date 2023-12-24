import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skisreal/LoginScreen/login_screen.dart';
import 'package:skisreal/controller/profile_Controller.dart';

import '../../../Constant/color.dart';
import '../../../Constant/const.dart';
import '../../Models/userModel.dart';
import 'package:http/http.dart' as http;

import 'edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isChecked = false;

// var controller=Get.put(Profile_Controller());

  //token

  String? token;
  var controller = Get.put(Profile_Controller());


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      print(Get.arguments);
    });
    // retrieveToken();
    // fetchCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            elevation: 1,
            flexibleSpace: Padding(
              padding: EdgeInsets.only(top: 35.0, left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 20.0,
                    ),
                    child: Text(
                      'פרופיל',
                      style: TextStyle(
                        color: Color(0xFF172B4C),
                        fontSize: 20,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 12.0, right: 15),
                    child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Image.asset(
                          'assets/icons/la.png',
                          scale: 4,
                        )),
                  ),
                ],
              ),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 390,
                height: 180,
                padding: const EdgeInsets.only(right: 20, bottom: 70),
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/scn.png',
                      ),
                      opacity: 0.5,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.9), BlendMode.dstATop),
                      fit: BoxFit.cover,
                    )),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${Get.arguments["name"].toString()}',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                                textScaleFactor: 1.0,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                  onTap: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => EditProfileScreen(
                                    //       name: currentUser.fullName,
                                    //       img: currentUser.img,
                                    //       skis: currentUser.skisStyle,
                                    //     ),
                                    //   ),
                                    // );
                                    print(Get.arguments["profile_image"]
                                        .toString());
                                    String profile_image = Get
                                        .arguments["profile_image"]
                                        .toString();
                                    String userName =
                                    Get.arguments["name"].toString();
                                    String userSkill =
                                    Get.arguments["ski_style"].toString();
                                    String userSex =
                                    Get.arguments["sex"].toString();
                                    String userExperience = Get
                                        .arguments["experience_level"]
                                        .toString();
                                    String userPhone = Get
                                        .arguments["phone_number"]
                                        .toString();
                                    String userAge = Get
                                        .arguments["age"]
                                        .toString();

                                    Get.to(
                                            () => EditProfileScreen(
                                          img: profile_image,
                                          name: userName,
                                          skis: userSkill,
                                          experience: userExperience,
                                          sex: userSex,
                                          Phone: userPhone,
                                          age: userAge,
                                        ),
                                        arguments: Get.arguments);
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ))
                            ],
                          ),
                          Text(
                            '${Get.arguments["email"].toString()}',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                            textScaleFactor: 1.0,
                          )
                        ],
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        width: 95,
                        height: 95,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: CachedNetworkImage(
                            width: 95,
                            height: 95,
                            imageUrl:
                            "${Get.arguments["profile_image"].toString()}",
                            fit: BoxFit.cover,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Center(
                              child: CircularProgressIndicator(
                                  color: primaryColor,
                                  value: downloadProgress.progress),
                            ),
                            errorWidget: (context, url, error) => CircleAvatar(
                              child: Image.asset(
                                'assets/images/skis.jpg',
                                height: 95,
                                width: 95,
                              ),
                            ),
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              Container(
                width: 390,
                height: 29,
                padding: const EdgeInsets.only(right: 16, bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),

                ),
                child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'פרטים אישיים ',
                      style: TextStyle(
                        color: Color(0xFF72777F),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                      textScaleFactor: 1.0,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),

              //phone

              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'טלפון',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0xFF72777F),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                          textScaleFactor: 1.0,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          '${Get.arguments["phone_number"]}',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0xFF191919),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                          textScaleFactor: 1.0,
                        )
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Image.asset(
                      'assets/icons/call.png',
                      scale: 4,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),

              //birth age

              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'גיל',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0xFF72777F),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          '${Get.arguments["age"].toString()} שנים',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0xFF191919),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Image.asset(
                      'assets/icons/birthday.png',
                      scale: 4,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),

              //gender

              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'מִין',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0xFF72777F),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          '${Get.arguments["sex"].toString()}',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0xFF191919),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Image.asset(
                      'assets/icons/man.png',
                      scale: 4,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 358,
                height: 1,
                decoration: BoxDecoration(color: Color(0xFFEFF3F9)),
              ),

              //1s text

              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'סגנון גלישה',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0xFF72777F),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          '${Get.arguments["ski_style"].toString()}',
                          // "fddsf",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0xFF191919),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              //2nd text

              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'רמת ניסיון',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0xFF72777F),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          '${Get.arguments["experience_level"].toString()}',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0xFF191919),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              //3rd
              //2nd text

              SizedBox(
                height: 25,
              ),
              Container(
                width: 340,
                height: 41,
                color: Colors.grey.withOpacity(0.03),
                child: Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'הגדרות',
                        style: TextStyle(
                          color: Color(0xFF72777F),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
              ),

              //notification

              SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Obx(
                          () => Switch(
                        value: controller.isChecked.value,
                        onChanged: (bool value) {
                          setState(() {
                            controller.isChecked.value = value;
                            // print(value);
                            controller
                                .aboutNotification(controller.isChecked.value);
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 190,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'התראות',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0xFF191919),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Image.asset(
                      'assets/icons/notification.png',
                      scale: 4,
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 30,
              ),

              //logout button

              InkWell(
                onTap: () async {
                  // Store the token in SharedPreferences
                  SharedPreferences prefs =
                  await SharedPreferences.getInstance();
                  prefs.setString('token', '');
                  prefs.setString('id', '');
                  prefs.setString('email', '');
                  prefs.setString('fullName', '');
                  prefs.setString('phone', '');
                  FirebaseMessaging.instance.deleteToken();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    content: Text(
                      "Successfully Logout",
                      style: TextStyle(color: Colors.white, fontSize: 19),
                    ),
                    duration: Duration(seconds: 2),
                  ));
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) => LoginScreen(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0, left: 18),
                  child: Container(
                    width: 380,
                    height: 46,
                    padding: const EdgeInsets.only(right: 16),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'להתנתק',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xFFEB5757),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 16),
                          Image.asset(
                            'assets/icons/logout.png',
                            scale: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
