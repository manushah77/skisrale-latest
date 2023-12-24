import 'dart:convert';
import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skisreal/BotttomNavigation/custom_bottom_navigation_bar_screen.dart';
import 'package:skisreal/Constant/color.dart';
import 'package:http/http.dart' as http;
import 'package:skisreal/Constant/const.dart';
import 'package:skisreal/Constant/dialoag_widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isLoading = false;
  bool isLoadingTwo = false;
  int? countyLenght;

  String? dropdownValueTwo;
  String? dropdownValue;
  String? dropdownValueThree;
  bool hasMadeSelection = false;
  bool hasMadeSelectionoOne = false;
  bool hasMadeSelectionTwo = false;

  bool ispasswordvisible = true;
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  TextEditingController ageC = TextEditingController();
  TextEditingController skiExperience = TextEditingController();

  final formKey = GlobalKey<FormState>();

  String selectedCountryCode = '+972'; // Default country code

  void handleCountryChange(Country country) {
    setState(() {
      selectedCountryCode = '+${country.dialCode}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
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
                    padding: const EdgeInsets.only(right: 20.0),
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
                ],
              ),
              SizedBox(
                height: 16,
              ),

              InkWell(
                onTap: () {
                  _showAvatarSheet();
                },
                child: imageOne != null
                    ? ClipOval(
                  child: Image.file(
                    imageOne!,
                    fit: BoxFit.cover,
                    height: 140,
                    width: 140,
                  ),
                )
                    : ClipOval(
                  child: Container(
                    height: 140,
                    width: 140,
                    color: Colors.grey.withOpacity(0.2),
                    child: Image.asset(
                      'assets/icons/ad.png',
                      color: primaryColor,
                      scale: 4,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              //firstname txt field

              Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 18),
                child: SizedBox(
                  width: 380,
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
                    controller: nameC,

                    // ignore: body_might_complete_normally_nullable
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          'assets/icons/pp.png',
                          height: 20,
                          width: 20,
                          color: iconColor,
                        ),
                      ),
                      suffixIconColor: Colors.black12,
                      contentPadding: EdgeInsets.only(
                          top: 10, left: 15, right: 13, bottom: 10),
                      border: InputBorder.none,

                      hintText: 'jhonathondoe',
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

              //email text field
              Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 18),
                child: SizedBox(
                  width: 380,
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
                    controller: emailC,
                    keyboardType: TextInputType.emailAddress,
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
                          scale: 4,
                          color: iconColor,
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

              //password text field

              Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 18),
                child: SizedBox(
                  width: 380,
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
                    controller: passwordC,

                    // ignore: body_might_complete_normally_nullable
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter password';
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
                height: 15,
              ),

              // phone number

              Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 18),
                child: SizedBox(
                  width: 380,
                  height: 73,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: IntlPhoneField(
                      textAlign: TextAlign.start,
                      showCountryFlag: false,
                      invalidNumberMessage: 'Enter Valid Digits',
                      dropdownIcon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey,
                      ),
                      cursorColor: primaryColor,
                      controller: phoneC,
                      validator: (_) {
                        if (_ == null || _ == '') {
                          return 'Enter number';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: '',
                        hintTextDirection: TextDirection.rtl,
                        hintStyle: TextStyle(
                          color: primaryColor.withOpacity(0.5),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                        labelStyle: TextStyle(
                          color: primaryColor,
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
                      initialCountryCode: 'IL',
                      onChanged: (value) {},
                      onCountryChanged: handleCountryChange,

                      // onCountryChanged: (country) {
                      //   // print(country.maxLength);
                      //   countyLenght = country.maxLength;
                      //   // this.phoneNo = country.toString();
                      // },
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 15,
              ),

              //gender drop down

              Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 18),
                child: Container(
                  width: 380,
                  height: 50,
                  child: DropdownButtonHideUnderline(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: DropdownButton2(
                        isExpanded: true,

                        hint: Text('מגדר'),

                        items: <String>[
                          'זכר',
                          'נקבה',
                          'אחר',
                        ]
                            .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: primaryColor.withOpacity(0.5),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                            .toList(),
                        value: hasMadeSelection ? dropdownValueTwo : null,
                        onChanged: (value) {
                          setState(() {
                            dropdownValueTwo = value as String;
                            hasMadeSelection = true;

                          });
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          width: 160,
                          padding: const EdgeInsets.only(left: 18, right: 18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ),
                        ),
                        iconStyleData: IconStyleData(
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                          ),
                          iconSize: 28,
                          iconEnabledColor: primaryColor.withOpacity(0.5),
                          iconDisabledColor: primaryColor.withOpacity(0.5),
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          width: 200,
                          padding: null,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                        ),
                        menuItemStyleData: MenuItemStyleData(
                          height: 40,
                          padding: EdgeInsets.only(left: 14, right: 14),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 15,
              ),

              //ski experince lvl

              Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 18),
                child: Container(
                  width: 380,
                  height: 50,
                  child: DropdownButtonHideUnderline(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: DropdownButton2(
                        isExpanded: true,
                        hint: Text('רמת ניסיון'),

                        items: <String>[
                          'מתחיל',
                          'ביניים',
                          'מקצועי',
                        ]
                            .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: primaryColor.withOpacity(0.5),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                            .toList(),
                        value: hasMadeSelectionoOne ? dropdownValue : null,
                        onChanged: (value) {
                          setState(() {
                            dropdownValue = value as String;
                            hasMadeSelectionoOne = true;
                          });
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          width: 160,
                          padding: const EdgeInsets.only(left: 18, right: 18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ),
                        ),
                        iconStyleData: IconStyleData(
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                          ),
                          iconSize: 28,
                          iconEnabledColor: primaryColor.withOpacity(0.5),
                          iconDisabledColor: primaryColor.withOpacity(0.5),
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          width: 200,
                          padding: null,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                        ),
                        menuItemStyleData: MenuItemStyleData(
                          height: 40,
                          padding: EdgeInsets.only(left: 14, right: 14),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 15,
              ),

              //agr text field
              Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 18),
                child: SizedBox(
                  width: 380,
                  height: 65,
                  child: TextFormField(
                    cursorColor: primaryColor,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                    controller: ageC,
                    maxLength: 2,

                    // ignore: body_might_complete_normally_nullable
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Age';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          'assets/icons/birthday.png',
                          scale: 4,
                        ),
                      ),
                      suffixIconColor: Colors.black12,
                      contentPadding: EdgeInsets.only(
                          top: 10, left: 15, right: 13, bottom: 10),
                      border: InputBorder.none,

                      hintText: 'גיל',
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

              //expeirce text field
              Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 18),
                child: Container(
                  width: 380,
                  height: 50,
                  child: DropdownButtonHideUnderline(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: DropdownButton2(

                        isExpanded: true,
                        hint: Text('סגנון גלישה'),
                        items: <String>[
                          'סנובורד',
                          'סקי',
                        ]
                            .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: primaryColor.withOpacity(0.5),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                            .toList(),
                        value: hasMadeSelectionTwo ? dropdownValueThree : null,
                        onChanged: (value) {
                          setState(() {
                            dropdownValueThree = value as String;
                            hasMadeSelectionTwo=true;
                          });
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          width: 160,
                          padding: const EdgeInsets.only(left: 18, right: 18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ),
                        ),
                        iconStyleData: IconStyleData(
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                          ),
                          iconSize: 28,
                          iconEnabledColor: primaryColor.withOpacity(0.5),
                          iconDisabledColor: primaryColor.withOpacity(0.5),
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          width: 200,
                          padding: null,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                        ),
                        menuItemStyleData: MenuItemStyleData(
                          height: 40,
                          padding: EdgeInsets.only(left: 14, right: 14),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              //buttton

              SizedBox(
                height: 30,
              ),
              isLoading == true
                  ? CircularProgressIndicator(
                color: primaryColor,
              )
                  : Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 18),
                child: InkWell(
                  onTap: () async {
                    // Navigator.pop(context);
                    if (formKey.currentState!.validate()) {

                      String phone = phoneC.text.toString();
                      String formattedPhoneNumber = '$selectedCountryCode$phone';
                      print(formattedPhoneNumber);

                      _signUp().then((value) {
                        getTokenFromSharedPreferences();
                      });
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
                      ),
                    ),
                  ),
                ),
              ),

              //or login via

              SizedBox(
                height: 30,
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

              //facebook login

              SizedBox(
                height: 25,
              ),

              Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 18),
                child: InkWell(
                  onTap: () {
                    _loginWithFacebook(context);
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

              isLoadingTwo
                  ? CircularProgressIndicator(
                color: primaryColor,
              )
                  : Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 18),
                child: InkWell(
                  onTap: () {
                    _signInWithGoogle();
                  },
                  child: Container(
                    width: 380,
                    height: 60,
                    padding: const EdgeInsets.only(right: 16, bottom: 16),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            width: 1.5, color: Color(0xFFEFF3F9)),
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
    );
  }

  // String imgURL = ''; // Initialize this as an empty string
  File? imageOne;
  final pickerOne = ImagePicker();

  // bool isUploaded = false;

  Future<File> getImageFileFromAssets(String path) async {
    final ByteData data = await rootBundle.load('assets/$path');
    final List<int> bytes = data.buffer.asUint8List();

    final String tempPath = (await getTemporaryDirectory()).path;
    final String filePath = '$tempPath/${path.split('/').last}'; // Get the last part of the path
    final File tempFile = File(filePath);

    await tempFile.writeAsBytes(bytes, flush: true);
    return tempFile;
  }



  void _showAvatarSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (_) {
        return ListView(
          padding: EdgeInsets.only(top: 15),
          shrinkWrap: true,
          children: [
            Text(
              'Upload Avatar\n photos',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    fixedSize: Size(110, 110),
                    elevation: 1,
                    shape: CircleBorder(),
                  ),
                  onPressed: () async {
                    // Image.file(await getImageFileFromAssets('images/avaman.png'));
                    imageOne =await getImageFileFromAssets('images/iconM.jpg');
                    setState(() {});

                    Navigator.pop(context);
                  },
                  child: Image.asset('assets/images/iconM.jpg',scale: 3,),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    fixedSize: Size(110, 110),
                    shape: CircleBorder(),
                    elevation: 1,
                  ),
                  onPressed: ()  async{
                    imageOne =await getImageFileFromAssets('images/iconW.jpg');
                    setState(() {});

                    Navigator.pop(context);
                  },
                  child: Image.asset('assets/images/iconW.jpg',scale: 3,),
                ),

              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Upload Profile\n photos',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    fixedSize: Size(110, 110),
                    elevation: 1,
                    shape: CircleBorder(),
                  ),
                  onPressed: () async {
                    var pickImage = await pickerOne.pickImage(
                      source: ImageSource.gallery,
                      maxHeight: 1080,
                      maxWidth: 1080,
                    );
                    if (pickImage != null) {
                      // Crop the selected image
                      CroppedFile? croppedImage = await ImageCropper().cropImage(
                        sourcePath: pickImage.path,
                      );

                      if (croppedImage != null) {
                        setState(() {
                          imageOne = File(croppedImage.path); // Convert CroppedFile to File
                        });
                      }
                    } else {
                      print('No image selected');
                    }
                    Navigator.pop(context);
                  },
                  child: Image.asset('assets/images/gal.png'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    fixedSize: Size(110, 110),
                    shape: CircleBorder(),
                    elevation: 1,
                  ),
                  onPressed: () async {
                    var pickImage = await pickerOne.pickImage(
                      source: ImageSource.camera,
                      maxHeight: 1080,
                      maxWidth: 1080,
                    );
                    if (pickImage != null) {
                      // Crop the selected image
                      CroppedFile? croppedImage = await ImageCropper().cropImage(
                        sourcePath: pickImage.path,
                      );

                      if (croppedImage != null) {
                        setState(() {
                          imageOne = File(croppedImage.path); // Convert CroppedFile to File
                        });
                      }
                    } else {
                      print('No image selected');
                    }
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    'assets/images/camera.png',
                    color: Colors.grey.withOpacity(0.8),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),          ],
        );
      },
    );
  }

  String? name;
  String? email;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _signInWithGoogle() async {
    try {
      GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sign in canceled'),
          ),
        );
      } else {
        String authToken = "";
        GoogleSignInAuthentication auth = await account.authentication;
        authToken = auth.accessToken!;
        name = account.displayName ?? "";
        email = account.email ?? "";
        print(account);
        _socialIsignUP(account.displayName!, account.email, account.photoUrl!,
            account.serverAuthCode!, 'Social');
      }
    } catch (error) {
      print('Error signing in: $error');
    }
  }

  //social sign up
  Future<void> _socialIsignUP(String name, String email, String image,
      String accessToken, String type) async {
    String apiURl = Consts.BASE_URL + "/api/social_signup";
    var bodyData = {
      "fullName": name,
      "authType": type,
      "authToken": accessToken,
      "profile_image": image,
      "email": email,
    };

    setState(() {
      isLoadingTwo = true;
    });

    var result = await http.post(
      Uri.parse(apiURl),
      body: bodyData,
    );

    setState(() {
      isLoadingTwo = true;
    });

    try {
      if (result.statusCode == 200) {
        setState(() {
          isLoadingTwo = true;
        });

        Map<String, dynamic> data = json.decode(result.body);
        print(data);
        int id = data['user']['id'];
        String userName = data['user']['name'];
        String userEmail = data['user']['email'];
        String userPhoto = data['user']['profile_image'] ?? '';
        String authToken = data['user']['auth_token'];
        String token = data['data']['token'];
        String userStatus = data['user']['status']; // Assuming the status field exists


        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('id', id.toString());
        prefs.setString('name', userName);
        prefs.setString('email', userEmail);
        prefs.setString('profile_image', userPhoto);
        prefs.setString('auth_token', authToken);
        prefs.setString('token', token);
        prefs.setString('status', userStatus.toString());

        CustomDialogs.showSnakcbar(context, data['message']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CustomBottomBar(
              index: 3,

            ),
          ),
        );
      }

      setState(() {
        isLoadingTwo = false;
      });

      // print(response.body);
    } catch (e) {
      setState(() {
        isLoadingTwo = false;
      });
      // Handle any other errors
      // print('Error: $e');
      CustomDialogs.showSnakcbar(context, 'Error is $e');
    }
  }

  //facebook login

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

  //sign up with form

  Future<void> _signUp() async {
    if (imageOne == null) {
      // Handle case when no image is selected
      CustomDialogs.showSnakcbar(context, 'Pick Profile Image');
      return;
    }

    // Other sign-up data...
    String name = nameC.text.toString() ?? '';
    String email = emailC.text.toString() ?? '';
    String password = passwordC.text.toString() ?? '';
    String age = ageC.text.toString() ?? '';
    String phone = phoneC.text.toString() ?? '';
    String experience_level = dropdownValue.toString() ?? '';
    String ski_style = dropdownValueThree.toString() ?? '';
    String sex = dropdownValueTwo.toString() ?? '';
    File? image = imageOne;

    setState(() {
      isLoading = true;
    });

    try {
      // Prepare the API request
      String apiUrl = Consts.BASE_URL + '/api/signup';

      // Create a new multipart request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // // Add the image file to the request as a multipart/form-data field
      var imageStream = http.ByteStream(image!.openRead());
      var length = await image.length();
      var multipartFile = http.MultipartFile(
        'profile_image',
        imageStream,
        length,
        filename: 'assets/images/1.png',
      );
      request.files.add(multipartFile);

      // if (imageOne != null) {
      //   var imageStream = http.ByteStream(image!.openRead());
      //   var length = await image.length();
      //   var multipartFile = http.MultipartFile(
      //     'profile_image',
      //     imageStream,
      //     length,
      //     filename: 'assets/images/1.png',
      //   );
      //   request.files.add(multipartFile);
      // } else {
      //   // Upload a default image from assets if no image is selected
      //   var defaultImage = await rootBundle.load('assets/images/skis.jpg');
      //   var defaultMultipartFile = http.MultipartFile.fromBytes(
      //     'profile_image',
      //     defaultImage.buffer.asUint8List(),
      //     filename: 'assets/images/default.png',
      //   );
      //   request.files.add(defaultMultipartFile);
      // }


      String formattedPhoneNumber = '$selectedCountryCode$phone';
      // print(formattedPhoneNumber);


      // Add other sign-up fields as needed
      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['password'] = password;
      request.fields['age'] = age;
      request.fields['phone_number'] = formattedPhoneNumber;
      request.fields['experience_level'] = experience_level;
      request.fields['ski_style'] = ski_style;
      request.fields['sex'] = sex;
      request.fields['login_type'] = 'Form';

      // Send the data to the server and wait for the response
      var streamedResponse = await request.send();

      // Convert the streamed response to a regular http.Response
      var response = await http.Response.fromStream(streamedResponse);

      var data = jsonDecode(response.body.toString());

      // Handle the API response here
      print(data);
      if (response.statusCode == 200) {
        // Successful sign-up
        setState(() {
          isLoading = true;
        });

        CustomDialogs.showSnakcbar(context, 'Successfully Signup');

        String token = data['data']['token'];
        String id = data['user']['id'].toString();
        String email = data['user']['email'];
        String nam = data['user']['name'];
        String status = data['user']['status'].toString();

        // Store the token in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token);
        prefs.setString('id', id);
        prefs.setString('name', nam);
        prefs.setString('status', status);

        print(
          'The nam and the token and id is : $nam , $token, $id ,$email,$status',
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CustomBottomBar(
              index: 3,

            ),
          ),
        );

        // print(response.body);
        // print('Sign-up successful!');
      } else {
        setState(() {
          isLoading = false;
        });
        // print(response.body);

        CustomDialogs.showSnakcbar(context, 'Email Already Exist');

        // Error during sign-up
        // print('Error during sign-up: ${response.body}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle any other errors
      // print('Error: $e');
      CustomDialogs.showSnakcbar(context, 'Error is $e');
    }
  }
}

//global token get

Future getTokenFromSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}
