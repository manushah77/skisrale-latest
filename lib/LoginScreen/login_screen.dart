import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skisreal/BotttomNavigation/custom_bottom_navigation_bar_screen.dart';
import 'package:skisreal/Constant/color.dart';
import 'package:skisreal/Constant/dialoag_widget.dart';
import 'package:skisreal/ForgetPasswordScreen/fogetpassword_screen.dart';
import 'package:http/http.dart' as http;
import 'package:skisreal/controller/authentication_controller.dart';
import '../Constant/const.dart';
import '../SignUpScreen/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool ispasswordvisible = true;

  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  bool isUpload = false;
  final formKey = GlobalKey<FormState>();
  var controller = Get.put(authentication_Controller());


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => exit(0),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: controller.logInformKey.value,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 60,
                ),
                Center(
                  child: Container(
                    width: 231,
                    height: 76,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/login_logo.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 18.0),
                      child: Text(
                        'ברוך הבא',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xFF191919),
                          fontSize: 15,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.20,
                        ),
                        textScaleFactor: 1.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),

                //2nd txt

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 18.0),
                      child: Text(
                        'התחברו כדי להתחיל את החוויה',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xFF191919),
                          fontSize: 24,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          // letterSpacing: -0.64,
                        ),
                        textScaleFactor: 1.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),

                //3rd txt

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 18.0),
                      child: Text(
                        'האפליקציה שתעזור לכם לגלוש טוב יותר',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                        textScaleFactor: 1.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),

                //email text field
                Padding(
                  padding: const EdgeInsets.only(right: 18.0, left: 18),
                  child: SizedBox(
                    width: 380,
                    height: 80,
                    child: TextFormField(
                      cursorColor: primaryColor,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                      controller: controller.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        var email = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                        if (value == null || value == '') {
                          return 'Enter Your Email';
                        } else if (email.hasMatch(value)) {
                          return null;
                        } else
                          return "Wrong Email Address";
                      },
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {});
                          },
                          icon: Image.asset(
                            'assets/icons/email.png',
                            color: iconColor,
                            scale: 4,
                          ),
                        ),
                        suffixIconColor: Colors.black12,
                        contentPadding: EdgeInsets.only(
                          top: 10,
                          left: 15,
                          right: 13,
                          bottom: 10,
                        ),
                        border: InputBorder.none,
                        hintText: 'דואר אלקטרוני',
                        hintTextDirection: TextDirection.rtl,
                        hintStyle: TextStyle(
                          color: primaryColor.withOpacity(0.5),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.4),
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),

                //password text field

                Padding(
                  padding: const EdgeInsets.only(right: 18.0, left: 18),
                  child: SizedBox(
                    width: 380,
                    height: 80,
                    child: TextFormField(
                      cursorColor: primaryColor,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                      controller: controller.pass,

                      // ignore: body_might_complete_normally_nullable
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Password';
                        } else if (value.length < 6) {
                          return 'Must be more than 6 charater';
                        }
                        return null;
                      },
                      obscureText: ispasswordvisible,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: Image.asset(
                            'assets/icons/lock.png',
                            scale: 4,
                          ),
                        ),
                        suffixIconColor: Colors.black12,
                        prefixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              ispasswordvisible = !ispasswordvisible;
                            });
                          },
                          icon: Icon(
                            size: 20,
                            ispasswordvisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: primaryColor,
                          ),
                        ),
                        contentPadding: EdgeInsets.only(
                            top: 10, left: 15, right: 13, bottom: 10),
                        border: InputBorder.none,

                        hintText: 'סיסמה',
                        hintTextDirection: TextDirection.rtl,
                        hintStyle: TextStyle(
                          color: primaryColor.withOpacity(0.5),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                        // filled: true,
                        // fillColor: Colors.grey.withOpacity(0.2),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.4),
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                //forget password

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: InkWell(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => ForgetPasswordScreen(),
                          //   ),
                          // );
                          Get.to(() => ForgetPasswordScreen());
                        },
                        child: Text(
                          'שכחתי את הסיסמה ?',
                          style: TextStyle(
                            color: Color(0xFF172B4C),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    )
                  ],
                ),

                //buttton

                SizedBox(
                  height: 30,
                ),
                Obx(
                      () => controller.isLoading.value == true
                      ? CircularProgressIndicator(
                    color: primaryColor,
                  )
                      : Padding(
                    padding: const EdgeInsets.only(right: 20.0, left: 18),
                    child: InkWell(
                      onTap: () {
                        if (controller.logInformKey.value.currentState!
                            .validate()) {
                          controller.loginUser(
                              controller.email.value.text,
                              controller.pass.value.text);
                          // loginUser(emailC.text, passwordC.text)
                          //     .then((value) {
                          //   if (value) {
                          //     // getTokenFromSharedPreferences();

                          //     Navigator.pushReplacement(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => CustomBottomBar(),
                          //       ),
                          //     );
                          //   }
                          // });
                        }
                      },
                      child: Container(
                        width: 380,
                        height: 48,
                        decoration: ShapeDecoration(
                          color: Color(0xFF00B3D7),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                        ),
                        child: Center(
                          child: Text(
                            'להתחבר',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                //for sign up page
                SizedBox(
                  height: 15,
                ),

                InkWell(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => SignupScreen(),
                    //   ),
                    // );
                    Get.to(() => SignupScreen());
                  },
                  child: Text(
                    'הירשם',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Color(0xFF191919),
                      fontSize: 15,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.20,
                    ),
                  ),
                ),

                //or login via

                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 2,
                      width: 125,
                      color: Color(0xffF0F3FA),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      'או המשך עם',
                      style: TextStyle(
                        color: Color(0xFF8C8985),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Container(
                      height: 2,
                      width: 125,
                      color: Color(0xffF0F3FA),
                    ),
                  ],
                ),

                //facebook login

                SizedBox(
                  height: 25,
                ),

                Padding(
                  padding: const EdgeInsets.only(right: 20.0, left: 18),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _loginWithFacebook(context);
                      });
                    },
                    child: Container(
                      width: 380,
                      height: 60,
                      padding: const EdgeInsets.only(right: 16, bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Color(0xFFEFF3F9),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(4),
                        // shape: RoundedRectangleBorder(
                        //   side: BorderSide(width: 1.5, color: Color(0xFFEFF3F9)),
                        //   borderRadius: BorderRadius.circular(4),
                        // ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'התחבר עם פייסבוק',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF172B4C),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Image.asset(
                              'assets/icons/fb.png',
                              scale: 3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                //google login
                SizedBox(
                  height: 25,
                ),

                isUpload == true ? CircularProgressIndicator(
                  color: primaryColor,

                ) :

                Padding(
                  padding: const EdgeInsets.only(right: 20.0, left: 18),
                  child: InkWell(
                    onTap: () {

                      retrieveToken().then((value) {
                        print('my asdasda asd a$token');
                        _signInWithGoogle(token!);

                      });

                    },
                    child: Container(
                      width: 380,
                      height: 60,
                      padding: const EdgeInsets.only(right: 16, bottom: 16),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side:
                          BorderSide(width: 1.5, color: Color(0xFFEFF3F9)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(width: 20),
                          Text(
                            'היכנס עם גוגל',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF172B4C),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Image.asset(
                            'assets/icons/google.png',
                            scale: 3,
                          ),
                        ],
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
      ),
    );
  }

  String? token;
  String? namee;

  Future<void> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('auth_token');
      namee = prefs.getString('name');

      print("this is token $token");
      print("this is token $namee");
    });
    // print('asdadasda $token');
  }

  Future<void> _loginWithFacebook(BuildContext context) async {
    final fb = FacebookLogin();

// Log in

    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    switch (res.status) {
      case FacebookLoginStatus.success:
      // Logged in

      // Send access token to server for validation and auth
        final FacebookAccessToken? accessToken = res.accessToken;
        print('Access token: ${accessToken!.token}');

        // Get profile data
        final profile = await fb.getUserProfile();
        print('Hello, ${profile!.name}! You ID: ${profile.userId}');

        // Get user profile image url
        final imageUrl = await fb.getProfileImageUrl(width: 100);
        print('Your profile image: $imageUrl');

        // Get email (since we request email permission)
        final email = await fb.getUserEmail();
        // But user can decline permission
        if (email != null) print('And your email is $email');

        break;
      case FacebookLoginStatus.cancel:
      // User cancel log in
        break;
      case FacebookLoginStatus.error:
      // Log in failed
        print('Error while log in: ${res.error}');
        break;
    }
    // try {
    //   final result = await FacebookAuth.instance.login();

    //   if (result.status == LoginStatus.success) {
    //     print(result);
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text('Sign in canceled'),
    //       ),
    //     );
    //   }
    // } catch (error) {
    //   print('Error signing in with Facebook: $error');
    // }
  }

  String? name;
  String? email;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _signInWithGoogle(String token) async {
    GoogleSignInAccount? account = await _googleSignIn.signIn();

    _socialIsignUP(namee!,token);
  }

  //social sign up

  Future<void> _socialIsignUP(String name,
      String accessToken,) async {
    String apiURl = Consts.BASE_URL + "/api/social_login";
    var bodyData = {
      "full_name": name,
      // "authType": type,
      "authToken": accessToken,
      // "profile_image": image,
      // "email": email,
    };

    setState(() {
      isUpload = true;
    });

    var result = await http.post(
      Uri.parse(apiURl),
      body: bodyData,
    );

    setState(() {
      isUpload = true;
    });

    try {
      if (result.statusCode == 200) {
        setState(() {
          isUpload = true;
        });




        Map<String, dynamic> data = json.decode(result.body);
        print(data);
        int id = data['user']['id'];
        String userName = data['user']['name'];
        String userEmail = data['user']['email'];
        String userPhoto = data['user']['profile_image'] ?? '';
        String authToken = data['user']['auth_token'];
        String token = data['data']['token'];
        String userStatus = data['user']['status'];


        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('id', id.toString());
        prefs.setString('name', userName);
        prefs.setString('email', userEmail);
        prefs.setString('profile_image', userPhoto);
        prefs.setString('auth_token', authToken);
        prefs.setString('token', token);

        if (userStatus == 1) {
          CustomDialogs.showSnakcbar(context, 'You are blocked by the admin');

        }

        else {

          CustomDialogs.showSnakcbar(context, 'You are Successfully Login');



          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CustomBottomBar(
                index: 3,
              ),
            ),
          );
        }
      } else {
        CustomDialogs.showSnakcbar(context, 'Server returned status code ${result.statusCode}');
      }

      setState(() {
        isUpload = false;
      });

      // print(response.body);
    } catch (e) {
      setState(() {
        isUpload = false;
      });
      // Handle any other errors
      // print('Error: $e');
      CustomDialogs.showSnakcbar(context, 'Error is $e');
    }
  }


  dynamic data;

}
