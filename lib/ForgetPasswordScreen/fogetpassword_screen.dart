import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skisreal/Constant/dialoag_widget.dart';
import 'package:skisreal/controller/authentication_controller.dart';
import '../Constant/color.dart';
import 'package:http/http.dart' as http;

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController emailC = TextEditingController();
  var controller = Get.put(authentication_Controller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, right: 15),
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Center(
                child: Image.asset(
                  'assets/icons/la.png',
                  color: primaryColor,
                  scale: 4.5,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: controller.passwordReset.value,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
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
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Text(
                      'שכחת את הסיסמא?',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Color(0xFF191919),
                        fontSize: 17,
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

              //email text field
              Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 18),
                child: SizedBox(
                  width: 350,
                  height: 60,
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
                    // ignore: body_might_complete_normally_nullable
                    validator: (value) {
                      var email = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                      if (value == null || value == '') {
                        return 'Enter Your Email';
                      } else if (email.hasMatch(value)) {
                        return null;
                      } else
                        return "Wrong Email Adress";
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
                          top: 10, left: 15, right: 13, bottom: 10),
                      border: InputBorder.none,
                      hintText: 'jhonathondoe12@gmail',
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
                height: 15,
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
                            if (controller.passwordReset.value.currentState!
                                .validate()) {
                              controller
                                  .ressetPass(controller.email.value.text);
                              // Forget(emailC.text.toString()).then((value) {
                              //   Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => LoginScreen(),
                              //     ),
                              //   );
                              // });
                            }
                          },
                          child: Container(
                            width: 350,
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
            ],
          ),
        ),
      ),
    );
  }

  //forget password

  // Future Forget(String email) async {
  //   try {
  //     setState(() {
  //       isUploaded = true;
  //     });
  //     http.Response response = await http
  //         .post(Uri.parse('https://sk.jeuxtesting.com/api/forgot'), body: {
  //       'email': email,
  //     });
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(response.body.toString());
  //       setState(() {
  //         isUploaded = true;
  //       });
  //       print(data);
  //       CustomDialogs.showSnakcbar(context, 'Check Your Email Spam Folder');
  //     } else {
  //       setState(() {
  //         isUploaded = false;
  //       });
  //       var data = jsonDecode(response.body.toString());
  //       CustomDialogs.showSnakcbar(context, 'Email Does not Exist');

  //       print(response.statusCode);
  //       print(data.toString());
  //     }
  //   } catch (e) {
  //     setState(() {
  //       isUploaded = false;
  //     });
  //     CustomDialogs.showSnakcbar(context, '${e.toString()}');
  //   }
  // }
}
