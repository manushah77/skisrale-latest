import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skisreal/BotttomNavigation/custom_bottom_navigation_bar_screen.dart';
import 'package:skisreal/Constant/color.dart';
import 'package:skisreal/Constant/dialoag_widget.dart';
import 'package:skisreal/service/service.dart';

import '../../../Constant/const.dart';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  String? age;
  String? skis;
  String? sex;
  String? experience;
  String? img;
  String? name;

  String? Phone;

  EditProfileScreen(
      {this.name,
      this.img,
      this.skis,
      this.experience,
      this.Phone,
      this.sex,
      this.age,
      Key? key})
      : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameC = TextEditingController();
  TextEditingController phnC = TextEditingController();
  late int countyLenght;

  TextEditingController ageC = TextEditingController();
  String dropdownValue = 'מגדר';
  String dropdownValueTwo = ' סגנון גלישה'; // Set a default value
  bool hasMadeSelection = false;
  bool hasMadeSelectionoOne = false;
  bool hasMadeSelectionTwo = false;
  String experienceLevel = " רמת ניסיון";
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  File? imageOne;
  final pickerOne = ImagePicker();
  String? nam;
  String? image;
  int? id;
  String? skisType;

  String? phone;
  String? ag;
  String? token;

  Future<void> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      var idT = prefs.getString('id');
      id = int.parse(idT!);
    });
  }




  void _showBottomSheet() {
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
              ),
            ],
          );
        });
  }

 // ----- show avatar images ----- //

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.img);
    nameC.text = widget.name.toString();
    phnC.text = widget.Phone.toString();
    ageC.text = widget.age.toString();
    skisType = widget.skis;
    image = widget.img.toString();
    dropdownValueTwo = skisType.toString();
    dropdownValue = widget.sex ?? '';
    experienceLevel = widget.experience ?? '';
    print(skisType);

    // dropdownValue = Get.arguments["sex"].toString() ?? '';
    // dropdownValueTwo = Get.arguments["ski_style"].toString() ?? '';
    // experienceLevel = Get.arguments["experience_level"].toString() ?? '';
    setState(() {});
    // print(dropdownValue + dropdownValueTwo + experienceLevel);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        // extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarIconBrightness: Brightness.light,
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.light,
            ),
            elevation: 0,
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
                      'עדכן פרופיל',
                      style: TextStyle(
                        color: Colors.white,
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
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                          'assets/icons/la.png',
                          scale: 4,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: primaryColor,
            ),
          ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
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
                        child: CachedNetworkImage(
                          height: 140,
                          width: 140,
                          imageUrl: "${image}",
                          fit: BoxFit.cover,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(
                                color: Colors.white,
                                value: downloadProgress.progress),
                          ),
                          errorWidget: (context, url, error) => CircleAvatar(
                            child: Image.asset(
                              'assets/images/skis.jpg',
                              height: 140,
                              width: 140,
                            ),
                          ),
                        ),
                      ),
              ),

              SizedBox(
                height: 20,
              ),

              //name txt

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0, left: 15),
                    child: Text(
                      'שם משתמש',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Color(0xFF172B4C),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                      textScaleFactor: 1.0,
                    ),
                  ),
                ],
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
                    onChanged: (newValue) {
                      // Update the textFieldValue whenever the text field is edited
                      setState(() {
                        nam = newValue;
                      });
                    },
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

                      hintText: 'Name',
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
                height: 10,
              ),

              //age text

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0, left: 15),
                    child: Text(
                      'גיל',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Color(0xFF172B4C),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                      textScaleFactor: 1.0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),

              //age txt field

              Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 18),
                child: SizedBox(
                  width: 380,
                  height: 70,
                  child: TextFormField(
                    cursorColor: primaryColor,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                    maxLength: 2,
                    onTap: () {
                      if (ageC.text == 'null') {
                        ageC.clear();
                      }
                    },
                    onChanged: (newValue) {
                      // Update the textFieldValue whenever the text field is edited
                      setState(() {
                        ag = newValue;
                      });
                    },
                    controller: ageC,
                    keyboardType: TextInputType.number,

                    // ignore: body_might_complete_normally_nullable
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter number';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          'assets/icons/birthday.png',
                          height: 20,
                          width: 20,
                          color: iconColor,
                        ),
                      ),
                      suffixIconColor: Colors.black12,
                      contentPadding: EdgeInsets.only(
                          top: 10, left: 15, right: 13, bottom: 10),
                      border: InputBorder.none,

                      hintText: 'age',
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
                height: 10,
              ),

              //phn number text

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0, left: 15),
                    child: Text(
                      'מספר טלפון',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Color(0xFF172B4C),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                      textScaleFactor: 1.0,
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 20,
              ),



              Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 18),
                child: SizedBox(
                  width: 380,
                  height: 60,
                  child: TextFormField(
                    cursorColor: primaryColor,
                    // textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                    keyboardType: TextInputType.phone,
                    onTap: () {
                      if (phnC.text == 'null') {
                        phnC.clear();
                      }
                    },
                    maxLength: 13,
                    onChanged: (newValue) {
                      // Update the textFieldValue whenever the text field is edited
                      setState(() {
                        phone = newValue;
                      });
                    },
                    controller: phnC,

                    // ignore: body_might_complete_normally_nullable
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter number';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          'assets/icons/call.png',
                          height: 20,
                          width: 20,
                          color: iconColor,
                        ),
                      ),
                      suffixIconColor: Colors.black12,
                      contentPadding: EdgeInsets.only(
                          top: 10, left: 15, right: 13, bottom: 10),
                      border: InputBorder.none,

                      hintText: 'Phone',
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
                height: 10,
              ),

              //gender text

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0, left: 15),
                    child: Text(
                      'מין',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Color(0xFF172B4C),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                      textScaleFactor: 1.0,
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 10,
              ),

              //gender drop down

              Padding(
                padding:
                    const EdgeInsets.only(right: 20.0, left: 18, bottom: 20),
                child: Container(
                  width: 380,
                  height: 50,
                  child: DropdownButtonHideUnderline(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: DropdownButton2(
                        isExpanded: true,
                        hint: Text(dropdownValue),
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
                        value: hasMadeSelection ? dropdownValue : null,
                        onChanged: (value) {
                          setState(() {
                            dropdownValue = value as String;
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
                height: 5,
              ),


              // ski lvl text

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0, left: 15),
                    child: Text(
                      'סגנון גלישה',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Color(0xFF172B4C),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                      textScaleFactor: 1.0,
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 10,
              ),

              //Board Level dropdown
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
                        hint: Text(dropdownValueTwo),
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
                        value: hasMadeSelectionTwo ? dropdownValueTwo : null,
                        onChanged: (value) {
                          setState(() {
                            dropdownValueTwo = value as String;
                            hasMadeSelectionTwo =
                            true; // Update the selection status
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
                height: 20,
              ),
              //Experience lvl text

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0, left: 15),
                    child: Text(
                      'רמת ניסיון',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Color(0xFF172B4C),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                      textScaleFactor: 1.0,
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 10,
              ),

              // experience level
              Padding(
                padding:
                const EdgeInsets.only(right: 20.0, left: 18, bottom: 20),
                child: Container(
                  width: 380,
                  height: 50,
                  child: DropdownButtonHideUnderline(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: DropdownButton2(
                        isExpanded: true,
                        hint: Text(experienceLevel),
                        items: <String>[
                          'מַתחִיל',
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
                        value: hasMadeSelectionoOne ? experienceLevel : null,
                        onChanged: (value) {
                          setState(() {
                            experienceLevel = value as String;
                            hasMadeSelectionoOne =
                            true; // Update the selection status
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
              //
              // SizedBox(
              //   height: 20,
              // ),
              SizedBox(
                height: 35,
              ),

              isLoading
                  ? CircularProgressIndicator(
                      color: primaryColor,
                    )
                  : Padding(
                      padding: const EdgeInsets.only(right: 20.0, left: 18),
                      child: InkWell(
                        onTap: () async {
                          // Navigator.pop(context);

                          // if (image != null && nameC.text != null) {
                          //   CustomDialogs.showSnakcbar(
                          //       context, "Please Select Image is mendetory");
                          //   return;
                          // }

                          setState(() {
                            isLoading = true;
                          });
                          await _updateProfile(
                              nameC.text, ageC.text, phnC.text.toString());
                          setState(() {
                            isLoading = false;
                          });
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
                              'עדכון',
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
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateProfile(name, agee, phn) async {
    await retrieveToken();

    var url = Uri.parse(Consts.BASE_URL + '/api/update_profile/$id');
    if (imageOne == null) {
      final response = await http.post(
        Uri.parse(Consts.BASE_URL + '/api/update_profile/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + token.toString(),
        },
        body: json.encode({
          'name': name,
          'ski_style': dropdownValueTwo,
          'sex': dropdownValue,
          'experience_level': experienceLevel,
          'image_url': image,
          "phone_number": phn,
          "age": agee,
        }),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        //show suceess dialog
        CustomDialogs.showSnakcbar(context, 'Profile Updated Successfully');

        Get.offAll(() => CustomBottomBar(
          index: 3,

        ));
      } else {
        print(response.body);


        //show error dialog

        CustomDialogs.showSnakcbar(context, 'Error Updating Profile');


      }
    } else {
      var request = http.MultipartRequest('POST', url);
      var multipartFile = http.MultipartFile(
        'profile_image',
        imageOne!.readAsBytes().asStream(),
        imageOne!.lengthSync(),
        filename: 'assets/images/1.png',
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(multipartFile);

      // Add other sign-up fields as needed
      request.fields['name'] = name;
      request.fields['ski_style'] = dropdownValueTwo;
      request.fields['sex'] = dropdownValue;
      request.fields['experience_level'] = experienceLevel;
      request.fields['phone_number'] = phn;
      request.fields['age'] = agee;
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        //show suceess dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile Updated Successfully'),
            backgroundColor: primaryColor,
          ),
        );
        Get.offAll(() => CustomBottomBar(index: 3,));
      } else {
        print(response.body);
        //show error dialog
        CustomDialogs.showSnakcbar(context, 'Error Updating Profile');

      }
    }
  }
}
