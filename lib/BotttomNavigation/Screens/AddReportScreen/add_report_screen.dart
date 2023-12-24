import 'dart:convert';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skisreal/Constant/const.dart';
import 'package:skisreal/Constant/dialoag_widget.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

import '../../../Constant/color.dart';
import 'package:http/http.dart' as http;

import '../../../controller/adminTags.dart';
import '../SearchScreen/search_screen.dart';

class AddReportScreen extends StatefulWidget {
  const AddReportScreen({Key? key}) : super(key: key);

  @override
  State<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  bool isUploadingData = false;

  TextEditingController titleC = TextEditingController();
  TextEditingController descriptionC = TextEditingController();
  TextEditingController locationC = TextEditingController();
  TextEditingController sitNamC = TextEditingController();
  TextEditingController tagC = TextEditingController();

  final formKey = GlobalKey<FormState>();

  File? video;
  final videoPicker = ImagePicker();
  VideoPlayerController? vpController2;

  pickVideo() async {
    var pickImage = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );

    if (pickImage != null) {
      video = File(pickImage.path);
      vpController2 = VideoPlayerController.file(video!)
        ..initialize().then((_) {
          setState(() {
            if (pickImage != null) {
              video = File(pickImage.path);
            } else {
              print('no image selected');
            }
          });
        });
      vpController2!.pause();
    } else {
      print('no video selected');
    }
  }

  File? imageOne;
  final pickerOne = ImagePicker();
  bool isUploaded = false;
  VideoPlayerController? vpController;
  VideoPlayerController? vpControllerTwo;
  VideoPlayerController? vpControllerThree;
  VideoPlayerController? vpControllerFour;
  VideoPlayerController? vpControllerFive;

  //forVideopicker
  File? videoOne;
  File? videoTwo;
  File? videoThree;
  File? videoFour;
  File? videoFive;

  //for 2 image
  File? imageTwo;
  final pickerTwo = ImagePicker();

  //for 3 image
  File? imageThree;
  final pickerThree = ImagePicker();

  //for 4 image
  File? imageFour;
  final pickerFour = ImagePicker();

  //for 5 image
  File? imageFive;
  final pickerFive = ImagePicker();

  void _removeImage() {
    setState(() {
      imageOne = null;
      videoOne = null;
      vpController = null;
    });
  }

  void _removeImageTwo() {
    setState(() {
      imageTwo = null;
      videoTwo = null;
      vpControllerTwo = null;
    });
  }

  void _removeImageThree() {
    setState(() {
      imageThree = null;
      videoThree = null;
      vpControllerThree = null;
    });
  }

  void _removeImageFour() {
    setState(() {
      imageFour = null;
      videoFour = null;
      vpControllerFour = null;
    });
  }

  void _removeImageFive() {
    setState(() {
      imageFive = null;
      videoFive = null;
      vpControllerFive = null;
    });
  }

  void _removeVideo() {
    setState(() {
      video = null;
      video = null;
      vpControllerFive = null;
    });
  }

  // one dialog
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
                'Select Photos and \n Videos',
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
                          source: ImageSource.gallery);

                      setState(() {
                        if (pickImage != null) {
                          imageOne = File(pickImage.path);
                        } else {
                          print('no image selected');
                        }
                      });
                      myFocusNode.unfocus();

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
                      var pickImage = await pickerOne.pickVideo(
                        source: ImageSource.gallery,
                      );
                      videoOne = File(pickImage!.path);
                      vpController = VideoPlayerController.file(videoOne!)
                        ..initialize().then((value) {
                          setState(() {
                            if (pickImage.path.isNotEmpty) {
                              videoOne = File(pickImage.path);
                            } else {
                              print('no video selected');
                            }
                          });
                        });

                      vpController!.pause();
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.video_camera_back_outlined,
                      size: 70,
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

  //2nd dialog
  void _showBottomSheetTwo() {
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
                'Select Photos and \n Videos',
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
                      var pickImage = await pickerTwo.pickImage(
                          source: ImageSource.gallery);

                      setState(() {
                        if (pickImage != null) {
                          imageTwo = File(pickImage.path);
                        } else {
                          print('no image selected');
                        }
                      });
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
                      var pickImage = await pickerTwo.pickVideo(
                        source: ImageSource.gallery,
                      );
                      videoTwo = File(pickImage!.path);
                      vpControllerTwo = VideoPlayerController.file(videoTwo!)
                        ..initialize().then((value) {
                          setState(() {
                            if (pickImage.path.isNotEmpty) {
                              videoTwo = File(pickImage.path);
                            } else {
                              print('no video selected');
                            }
                          });
                        });

                      vpControllerTwo!.pause();
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.video_camera_back_outlined,
                      size: 70,
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

  // third dialog
  void _showBottomSheetThree() {
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
                'Select Photos and \n Videos',
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
                          source: ImageSource.gallery);

                      setState(() {
                        if (pickImage != null) {
                          imageThree = File(pickImage.path);
                        } else {
                          print('no image selected');
                        }
                      });
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
                      var pickImage = await pickerThree.pickVideo(
                        source: ImageSource.gallery,
                      );
                      videoThree = File(pickImage!.path);
                      vpControllerThree =
                          VideoPlayerController.file(videoThree!)
                            ..initialize().then((value) {
                              setState(() {
                                if (pickImage.path.isNotEmpty) {
                                  videoThree = File(pickImage.path);
                                } else {
                                  print('no video selected');
                                }
                              });
                            });

                      vpControllerThree!.pause();
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.video_camera_back_outlined,
                      size: 70,
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

  //4th dialog
  void _showBottomSheetFour() {
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
                'Select Photos and \n Videos',
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
                      var pickImage = await pickerFour.pickImage(
                          source: ImageSource.gallery);

                      setState(() {
                        if (pickImage != null) {
                          imageFour = File(pickImage.path);
                        } else {
                          print('no image selected');
                        }
                      });
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
                      var pickImage = await pickerFour.pickVideo(
                        source: ImageSource.gallery,
                      );
                      videoFour = File(pickImage!.path);
                      vpControllerFour = VideoPlayerController.file(videoFour!)
                        ..initialize().then((value) {
                          setState(() {
                            if (pickImage.path.isNotEmpty) {
                              videoFour = File(pickImage.path);
                            } else {
                              print('no video selected');
                            }
                          });
                        });

                      vpControllerFour!.pause();
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.video_camera_back_outlined,
                      size: 70,
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

  //5th dialog
  void _showBottomSheetFive() {
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
                'Select Photos and \n Videos',
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
                      var pickImage = await pickerFive.pickImage(
                          source: ImageSource.gallery);

                      setState(() {
                        if (pickImage != null) {
                          imageFive = File(pickImage.path);
                        } else {
                          print('no image selected');
                        }
                      });
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
                      var pickImage = await pickerFive.pickVideo(
                        source: ImageSource.gallery,
                      );
                      videoFive = File(pickImage!.path);
                      vpControllerFive = VideoPlayerController.file(videoFive!)
                        ..initialize().then((value) {
                          setState(() {
                            if (pickImage.path.isNotEmpty) {
                              videoFive = File(pickImage.path);
                            } else {
                              print('no video selected');
                            }
                          });
                        });

                      vpControllerFive!.pause();
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.video_camera_back_outlined,
                      size: 70,
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

  final myFocusNode = FocusNode();

  var controller = Get.put(AdminTag_Controller());
  List<dynamic> tags = [];

  //
  // var response;
  // Future<void> fetchDataa() async {
  //   final url = 'https://sk.jeuxtesting.com/api/getTagsList'; // Replace with your actual API endpoint
  //
  //   try {
  //      response = await http.get(
  //       Uri.parse(url),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Content-Type': 'application/json',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       // If server returns an OK response, parse the JSON
  //       final jsonBody = json.decode(response.body);
  //       response = jsonBody['feed'] as List<dynamic>;
  //       print(response);
  //       return response;
  //
  //     } else {
  //       // If the server did not return a 200 OK response,
  //       // throw an exception.
  //       throw Exception('Failed to load data');
  //     }
  //   } catch (error) {
  //     // Handle network errors or other exceptions
  //     print('Error: $error');
  //     throw Exception('Failed to load data');
  //   }
  // }

  // Future<void> retrieveToken() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     token = prefs.getString('token');
  //     print("this is token $token");
  //   });
  //   // print('asdadasda $token');
  // }

  // void searchTags(String keywords) {
  //   setState(() {
  //     controller.data.value = controller.data.where((items) {
  //       final tagData = items['tags'].toString().toLowerCase();
  //       return tagData.contains(keywords.toLowerCase());
  //     }).toList();
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.retrieveToken().then((value) {
      controller.getAdminTags();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    myFocusNode.dispose();
    super.dispose();
    vpController!.dispose();
    vpController2!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarIconBrightness: Brightness.light,
              systemNavigationBarDividerColor: null,
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.light,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 22.0,right: 20),
                child: Text(
                  'שלחו אלינו דיווח',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ],
            automaticallyImplyLeading: false,
            backgroundColor: primaryColor,
          ),
        ),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),

                //first text

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 22.0),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '* ',
                              style: TextStyle(
                                color: Color(0xFFEB5757),
                                fontSize: 15,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: ' שדות חובה *',
                              style: TextStyle(
                                color: Color(0xFF172B4C),
                                fontSize: 15,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),

                //1st text field

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
                      controller: titleC,

                      // ignore: body_might_complete_normally_nullable
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please title';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        suffixIconColor: Colors.black12,
                        contentPadding: EdgeInsets.only(
                            top: 10, left: 15, right: 13, bottom: 10),
                        border: InputBorder.none,

                        hintText: 'כותרת',
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
                  height: 12,
                ),

                //2nd text field

                Padding(
                  padding: const EdgeInsets.only(right: 20.0, left: 18),
                  child: SizedBox(
                    width: 380,
                    height: 120,
                    child: TextFormField(
                      cursorColor: primaryColor,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                      controller: descriptionC,

                      // ignore: body_might_complete_normally_nullable
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please description';
                        }
                        return null;
                      },
                      maxLines: 10,

                      decoration: InputDecoration(
                        suffixIconColor: Colors.black12,
                        contentPadding: EdgeInsets.only(
                            top: 10, left: 15, right: 13, bottom: 10),
                        border: InputBorder.none,

                        hintText: 'תוכן ההודעה...',
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
                  height: 12,
                ),

                //3rd text field

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
                      controller: locationC,

                      // ignore: body_might_complete_normally_nullable
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your location';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        suffixIconColor: Colors.black12,
                        contentPadding: EdgeInsets.only(
                            top: 10, left: 15, right: 13, bottom: 10),
                        border: InputBorder.none,

                        hintText: 'הוסף מיקום',
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

                // SizedBox(
                //   height: 12,
                // ),
                //
                // //4th text field
                //
                // Padding(
                //   padding: const EdgeInsets.only(right: 20.0, left: 18),
                //   child: SizedBox(
                //     width: 380,
                //     height: 60,
                //     child: TextFormField(
                //       cursorColor: primaryColor,
                //       textDirection: TextDirection.rtl,
                //       style: TextStyle(
                //         color: primaryColor,
                //         fontSize: 14,
                //         fontFamily: 'Inter',
                //         fontWeight: FontWeight.w500,
                //       ),
                //       controller: sitNamC,
                //
                //       // ignore: body_might_complete_normally_nullable
                //       validator: (value) {
                //         if (value!.isEmpty) {
                //           return 'Please enter website name';
                //         }
                //         return null;
                //       },
                //       decoration: InputDecoration(
                //         suffixIconColor: Colors.black12,
                //         contentPadding: EdgeInsets.only(
                //             top: 10, left: 15, right: 13, bottom: 10),
                //         border: InputBorder.none,
                //
                //         hintText: 'שם אתר',
                //         hintTextDirection: TextDirection.rtl,
                //         hintStyle: TextStyle(
                //           color: primaryColor.withOpacity(0.5),
                //           fontSize: 14,
                //           fontFamily: 'Inter',
                //           fontWeight: FontWeight.w500,
                //         ),
                //         // filled: true,
                //         // fillColor: Colors.grey.withOpacity(0.2),
                //         focusedErrorBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(5),
                //         ),
                //         enabledBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(5),
                //           borderSide: BorderSide(
                //             color: Colors.grey.withOpacity(0.4),
                //           ),
                //         ),
                //         errorBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(5),
                //           borderSide: BorderSide(),
                //         ),
                //         focusedBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(5),
                //           borderSide: BorderSide(
                //             color: primaryColor,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),

                SizedBox(
                  height: 12,
                ),

                //5th text field

                // Padding(
                //   padding: const EdgeInsets.only(right: 20.0, left: 18),
                //   child: SizedBox(
                //     width: 380,
                //     height: 60,
                //     child: TextFormField(
                //       cursorColor: primaryColor,
                //       textDirection: TextDirection.rtl,
                //       style: TextStyle(
                //         color: primaryColor,
                //         fontSize: 14,
                //         fontFamily: 'Inter',
                //         fontWeight: FontWeight.w500,
                //       ),
                //       controller: tagC,
                //       focusNode: myFocusNode,
                //       // ignore: body_might_complete_normally_nullable
                //       validator: (value) {
                //         if (value!.isEmpty) {
                //           return 'Please enter your tag';
                //         }
                //         return null;
                //       },
                //       decoration: InputDecoration(
                //         suffixIconColor: Colors.black12,
                //         contentPadding: EdgeInsets.only(
                //             top: 10, left: 15, right: 13, bottom: 10),
                //         border: InputBorder.none,
                //
                //         hintText: 'הוסף תגית',
                //         hintTextDirection: TextDirection.rtl,
                //         hintStyle: TextStyle(
                //           color: primaryColor.withOpacity(0.5),
                //           fontSize: 14,
                //           fontFamily: 'Inter',
                //           fontWeight: FontWeight.w500,
                //         ),
                //         // filled: true,
                //         // fillColor: Colors.grey.withOpacity(0.2),
                //         focusedErrorBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(5),
                //         ),
                //         enabledBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(5),
                //           borderSide: BorderSide(
                //             color: Colors.grey.withOpacity(0.4),
                //           ),
                //         ),
                //         errorBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(5),
                //           borderSide: BorderSide(),
                //         ),
                //         focusedBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(5),
                //           borderSide: BorderSide(
                //             color: primaryColor,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),

                // Padding(
                //   padding: const EdgeInsets.only(right: 20.0, left: 18),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       Text(
                //         'תגים',
                //         style: TextStyle(
                //           fontSize: 17,
                //           fontWeight: FontWeight.w500,
                //           color: primaryColor,
                //         ),
                //         textScaleFactor: 1.0,
                //         textAlign: TextAlign.center,
                //       ),
                //     ],
                //   ),
                // ),
                //
                // Obx(
                //   () =>
                //   controller.isLoading == true && controller.data.value.isEmpty
                //       ? Center(
                //     child: CircularProgressIndicator(
                //       color: primaryColor,
                //     ),
                //   )
                //       :
                //   SizedBox(
                //     height: 150,
                //     child: Padding(
                //       padding: const EdgeInsets.only(right: 20.0, left: 18),
                //       child: ListView.builder(
                //         itemCount: 1,
                //         itemBuilder: (context, index) {
                //           // Create a Set to store unique tags
                //           Set<String> uniqueTags = Set<String>();
                //
                //           // Iterate through controllerTag.data to filter duplicates
                //           for (var tagData in controller.data) {
                //             uniqueTags
                //                 .add(tagData['tags'].toString().toLowerCase());
                //           }
                //
                //           // Convert the unique tags back to a list
                //           List<String> uniqueTagsList = uniqueTags.toList();
                //
                //           // Check if the text field is empty
                //
                //           return Wrap(
                //             children:
                //                 List.generate(uniqueTagsList.length, (indexx) {
                //               return PickChip(
                //                 title: uniqueTagsList[indexx],
                //                 selectedValues: tags,
                //               );
                //             }),
                //           );
                //         },
                //       ),
                //     ),
                //   ),
                // ),
                //
                // SizedBox(
                //   height: 12,
                // ),

                // Padding(
                //   padding:
                //   const EdgeInsets.only(right: 20.0, left: 18, bottom: 20),
                //   child: Container(
                //     width: 380,
                //     height: 50,
                //     child: DropdownButtonHideUnderline(
                //       child: Directionality(
                //         textDirection: TextDirection.rtl,
                //         child: DropdownButton2(
                //           isExpanded: true,
                //           hint: Text(dropdownValueTwo),
                //           items: response.map<DropdownMenuItem<String>>((item) {
                //             return DropdownMenuItem<String>(
                //               value: item['tags'],
                //               child: Text(
                //                 item['tags'],
                //                 style: TextStyle(
                //                   fontSize: 16,
                //                   fontWeight: FontWeight.w500,
                //                   color: primaryColor.withOpacity(0.5),
                //                 ),
                //                 overflow: TextOverflow.ellipsis,
                //               ),
                //             );
                //           }).toList(),
                //           value: hasMadeSelection ? dropdownValueTwo : null,
                //           onChanged: (value) {
                //             setState(() {
                //               dropdownValueTwo = value as String;
                //               hasMadeSelection = true;
                //             });
                //           },
                //           buttonStyleData: ButtonStyleData(
                //             height: 50,
                //             width: 160,
                //             padding: const EdgeInsets.only(left: 18, right: 18),
                //             decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(5),
                //               border: Border.all(
                //                 color: Colors.grey.withOpacity(0.4),
                //               ),
                //             ),
                //           ),
                //           iconStyleData: IconStyleData(
                //             icon: Icon(
                //               Icons.keyboard_arrow_down_rounded,
                //             ),
                //             iconSize: 28,
                //             iconEnabledColor: primaryColor.withOpacity(0.5),
                //             iconDisabledColor: primaryColor.withOpacity(0.5),
                //           ),
                //           dropdownStyleData: DropdownStyleData(
                //             maxHeight: 200,
                //             width: 200,
                //             padding: null,
                //             decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(30),
                //               color: Colors.white,
                //             ),
                //           ),
                //           menuItemStyleData: MenuItemStyleData(
                //             height: 40,
                //             padding: EdgeInsets.only(left: 14, right: 14),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),

                SizedBox(
                  height: 12,
                ),

                //image picker

                // images.isNotEmpty ?Wrap(
                //   children: images.map((imageone){
                //     return Container(
                //         child:Card(
                //           child: Container(
                //             height: 50, width:50,
                //             child: Image.file(File(imageone.path),fit: BoxFit.cover,),
                //           ),
                //         )
                //     );
                //   }).toList(),
                // ):

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  // Add this line to enable horizontal scrolling
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int i = 0; i <= 0; i++)
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 5),
                          child: InkWell(
                            onTap: () {
                              myFocusNode.unfocus();
                              _showBottomSheet();
                            },
                            child: Stack(
                              children: [
                                if (vpController != null &&
                                    vpController!.value.isInitialized)
                                  SizedBox(
                                    height: 70,
                                    width: 70,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: AspectRatio(
                                        aspectRatio:
                                            vpController!.value.aspectRatio,
                                        child: VideoPlayer(vpController!),
                                      ),
                                    ),
                                  ),
                                if (imageOne != null &&
                                    (vpController == null ||
                                        !vpController!.value.isInitialized))
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Image.file(
                                      imageOne!,
                                      fit: BoxFit.cover,
                                      height: 70,
                                      width: 70,
                                    ),
                                  ),
                                if (imageOne == null &&
                                    (vpController == null ||
                                        !vpController!.value.isInitialized))
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Container(
                                      height: 70,
                                      width: 70,
                                      color: Colors.grey.withOpacity(0.2),
                                      child: Image.asset(
                                        'assets/icons/add.png',
                                        scale: 4,
                                      ),
                                    ),
                                  ),
                                if (imageOne != null ||
                                    videoOne !=
                                        null) // Show the close button when image is present
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: InkWell(
                                      onTap: _removeImage,
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle),
                                        child: Center(
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.red,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 5),
                        child: InkWell(
                          onTap: () {
                            myFocusNode.unfocus();

                            _showBottomSheetTwo();
                          },
                          child: Stack(
                            children: [
                              if (vpControllerTwo != null &&
                                  vpControllerTwo!.value.isInitialized)
                                SizedBox(
                                  height: 70,
                                  width: 70,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: AspectRatio(
                                      aspectRatio:
                                          vpControllerTwo!.value.aspectRatio,
                                      child: VideoPlayer(vpControllerTwo!),
                                    ),
                                  ),
                                ),
                              if (imageTwo != null &&
                                  (vpControllerTwo == null ||
                                      !vpControllerTwo!.value.isInitialized))
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Image.file(
                                    imageTwo!,
                                    fit: BoxFit.cover,
                                    height: 70,
                                    width: 70,
                                  ),
                                ),
                              if (imageTwo == null &&
                                  (vpControllerTwo == null ||
                                      !vpControllerTwo!.value.isInitialized))
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Container(
                                    height: 70,
                                    width: 70,
                                    color: Colors.grey.withOpacity(0.2),
                                    child: Image.asset(
                                      'assets/icons/add.png',
                                      scale: 4,
                                    ),
                                  ),
                                ),
                              if (imageTwo != null ||
                                  videoTwo !=
                                      null) // Show the close button when image is present
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: InkWell(
                                    onTap: _removeImageTwo,
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      child: Center(
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.red,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 5),
                        child: InkWell(
                          onTap: () {
                            myFocusNode.unfocus();

                            _showBottomSheetThree();
                          },
                          child: Stack(
                            children: [
                              if (vpControllerThree != null &&
                                  vpControllerThree!.value.isInitialized)
                                SizedBox(
                                  height: 70,
                                  width: 70,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: AspectRatio(
                                      aspectRatio:
                                          vpControllerThree!.value.aspectRatio,
                                      child: VideoPlayer(vpControllerThree!),
                                    ),
                                  ),
                                ),
                              if (imageThree != null &&
                                  (vpControllerThree == null ||
                                      !vpControllerThree!.value.isInitialized))
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Image.file(
                                    imageThree!,
                                    fit: BoxFit.cover,
                                    height: 70,
                                    width: 70,
                                  ),
                                ),
                              if (imageThree == null &&
                                  (vpControllerThree == null ||
                                      !vpControllerThree!.value.isInitialized))
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Container(
                                    height: 70,
                                    width: 70,
                                    color: Colors.grey.withOpacity(0.2),
                                    child: Image.asset(
                                      'assets/icons/add.png',
                                      scale: 4,
                                    ),
                                  ),
                                ),
                              if (imageThree != null ||
                                  videoThree !=
                                      null) // Show the close button when image is present
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: InkWell(
                                    onTap: _removeImageThree,
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      child: Center(
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.red,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 5),
                        child: InkWell(
                          onTap: () {
                            myFocusNode.unfocus();

                            _showBottomSheetFour();
                          },
                          child: Stack(
                            children: [
                              if (vpControllerFour != null &&
                                  vpControllerFour!.value.isInitialized)
                                SizedBox(
                                  height: 70,
                                  width: 70,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: AspectRatio(
                                      aspectRatio:
                                          vpControllerFour!.value.aspectRatio,
                                      child: VideoPlayer(vpControllerFour!),
                                    ),
                                  ),
                                ),
                              if (imageFour != null &&
                                  (vpControllerFour == null ||
                                      !vpControllerFour!.value.isInitialized))
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Image.file(
                                    imageFour!,
                                    fit: BoxFit.cover,
                                    height: 70,
                                    width: 70,
                                  ),
                                ),
                              if (imageFour == null &&
                                  (vpControllerFour == null ||
                                      !vpControllerFour!.value.isInitialized))
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Container(
                                    height: 70,
                                    width: 70,
                                    color: Colors.grey.withOpacity(0.2),
                                    child: Image.asset(
                                      'assets/icons/add.png',
                                      scale: 4,
                                    ),
                                  ),
                                ),
                              if (imageFour != null ||
                                  videoFour !=
                                      null) // Show the close button when image is present
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: InkWell(
                                    onTap: _removeImageFour,
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      child: Center(
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.red,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 15),
                        child: InkWell(
                          onTap: () {
                            myFocusNode.unfocus();

                            _showBottomSheetFive();
                          },
                          child: Stack(
                            children: [
                              if (vpControllerFive != null &&
                                  vpControllerFive!.value.isInitialized)
                                SizedBox(
                                  height: 70,
                                  width: 70,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: AspectRatio(
                                      aspectRatio:
                                          vpControllerFive!.value.aspectRatio,
                                      child: VideoPlayer(vpControllerFive!),
                                    ),
                                  ),
                                ),
                              if (imageFive != null &&
                                  (vpControllerFive == null ||
                                      !vpControllerFive!.value.isInitialized))
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Image.file(
                                    imageFive!,
                                    fit: BoxFit.cover,
                                    height: 70,
                                    width: 70,
                                  ),
                                ),
                              if (imageFive == null &&
                                  (vpControllerFive == null ||
                                      !vpControllerFive!.value.isInitialized))
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Container(
                                    height: 70,
                                    width: 70,
                                    color: Colors.grey.withOpacity(0.2),
                                    child: Image.asset(
                                      'assets/icons/add.png',
                                      scale: 4,
                                    ),
                                  ),
                                ),
                              if (imageFive != null ||
                                  videoFive !=
                                      null) // Show the close button when image is present
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: InkWell(
                                    onTap: _removeImageFive,
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      child: Center(
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.red,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //title video picker
                SizedBox(
                  height: 15,
                ),

                InkWell(
                  onTap: () {
                    myFocusNode.unfocus();

                    pickVideo();
                  },
                  child: video != null
                      ? vpController2!.value.isInitialized
                          ? Stack(
                              children: [
                                SizedBox(
                                  height: 140,
                                  width: 300,
                                  child: AspectRatio(
                                    aspectRatio:
                                        vpController2!.value.aspectRatio,
                                    child: vpController2!.value.isInitialized
                                        ? VideoPlayer(vpController2!)
                                        : Container(
                                            height: 140,
                                            width: 300,
                                            child: Image.file(
                                              video!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: InkWell(
                                    onTap: _removeVideo,
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      child: Center(
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.red,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              // height: 140,
                              // width: 320,
                              // child: Image.file(
                              //   video!,
                              //   fit: BoxFit.cover,
                              // ),
                              )
                      : Padding(
                          padding: const EdgeInsets.only(right: 20.0, left: 18),
                          child: DottedBorder(
                            color: Colors.blue,
                            strokeWidth: 2,
                            dashPattern: [1.3, 5],
                            child: Container(
                              height: 140,
                              width: 320,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/icons/imag.png',
                                    scale: 4,
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    'להעלות תמונות',
                                    style: TextStyle(
                                      color: Color(0xFF172B4C),
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  // SizedBox(
                                  //   height: 3,
                                  // ),
                                  // Text(
                                  //   'מקסימום 5 תמונות',
                                  //   style: TextStyle(
                                  //     color: Color(0xFF72777F),
                                  //     fontSize: 12,
                                  //     fontFamily: 'Inter',
                                  //     fontWeight: FontWeight.w400,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                ),

                //button

                SizedBox(
                  height: 30,
                ),
                isUploadingData == true
                    ? CircularProgressIndicator(
                        color: primaryColor,
                      )
                    : Padding(
                        padding: const EdgeInsets.only(right: 20.0, left: 18),
                        child: InkWell(
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              await addFeed().then((value) {
                                titleC.clear();
                                descriptionC.clear();
                                locationC.clear();
                                sitNamC.clear();
                                tagC.clear();
                                vpController = null;
                                vpControllerTwo = null;
                                vpControllerThree = null;
                                vpControllerFour = null;
                                vpControllerFive = null;
                                vpController2 = null;
                                imageOne = null;
                                imageTwo = null;
                                imageThree = null;
                                imageFour = null;
                                imageFive = null;
                                videoOne = null;
                                videoTwo = null;
                                videoThree = null;
                                videoFour = null;
                                videoFive = null;
                                video = null;
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
                                'שלח',
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
      ),
    );
  }

  //
  // String dropdownValueTwo = 'SelectTags';
  // bool hasMadeSelection = false;

  //token

  String? token;

  // void retrieveToken() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     token = prefs.getString('token');
  //     print('My fetch token is $token');
  //   });
  // }

  Future<void> addFeed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
    // Other sign-up data...
    String title = titleC.text.toString().trim();
    String desc = descriptionC.text.toString().trim();
    String location = locationC.text.toString().trim();
    String siteName = sitNamC.text.toString().trim();
    String tagInput = tagC.text.toString().trim();

    List<File?> images = [imageOne, imageTwo, imageThree, imageFour, imageFive];
    List<File?> videoFiles = [
      videoOne,
      videoTwo,
      videoThree,
      videoFour,
      videoFive
    ]; // Replace with your list of video files

    setState(() {
      isUploadingData = true;
    });

    try {
      // Validate required fields
      if (title.isEmpty || desc.isEmpty
          // || video!.path.isEmpty
          // ||
          // (images.every((image) => image == null) &&
          //     videoFiles.every((video) => video == null))
          ) {
        setState(() {
          isUploadingData = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          content: Text(
            "Please fill all the required fields.",
            style: TextStyle(color: Colors.white, fontSize: 19),
          ),
          duration: Duration(seconds: 2),
        ));
        return;
      }

      // Prepare the API request
      String apiUrl = Consts.BASE_URL + '/api/add_feed';

      // Create a new multipart request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add the token to the request headers
      String accessToken = "$token";
      request.headers['Authorization'] = 'Bearer $accessToken';

      // Add images to the request
      for (int i = 0; i < images.length; i++) {
        if (images[i] != null) {
          var imageStream = http.ByteStream(images[i]!.openRead());
          var length = await images[i]!.length();
          var multipartFile = http.MultipartFile(
            'file[]',
            imageStream,
            length,
            filename:
                'assets/images/$i.png', // Set unique filenames for each image
          );
          request.files.add(multipartFile);
          print('Added image $i: assets/images/$i.png');
        }
      }

      // Add videos to the request
      for (int i = 0; i < videoFiles.length; i++) {
        if (videoFiles[i] != null) {
          final compressVideo = await VideoCompress.compressVideo(
            videoFiles[i]!.path,
            quality: VideoQuality.LowQuality,
            deleteOrigin: false,
          );

          var compressedVideoFile = File(compressVideo!.path.toString());
          var videoMultipartFile = http.MultipartFile(
            'file[]',
            http.ByteStream(compressedVideoFile.openRead()),
            await compressedVideoFile.length(),
            filename:
                'assets/videos/${DateTime.now().millisecondsSinceEpoch}_$i.mp4',
          );
          request.files.add(videoMultipartFile);
          print('Added compressed video $i: ${compressedVideoFile.path}');
        }
      }

      if (video != null) {
        final compressVideo = await VideoCompress.compressVideo(
          video!.path,
          quality: VideoQuality.LowQuality,
          deleteOrigin: false,
        );

        var compressedVideoFile = File(compressVideo!.path.toString());
        var videoMultipartFile = http.MultipartFile(
          'bottom_video',
          http.ByteStream(compressedVideoFile.openRead()),
          await compressedVideoFile.length(),
          filename:
              'assets/videos/${DateTime.now().millisecondsSinceEpoch}_bottom.mp4', // Set unique filename for the compressed bottom video
        );
        request.files.add(videoMultipartFile);
        print('Added compressed bottom video: ${compressedVideoFile.path}');
      }

// Split the input tags string into individual tags
//       List<String> tagsList = tags.toString().split(',').map((tag) => tag.trim()).toList();
//       // Add tags to the request fields
//       for (int i = 0; i < tagsList.length; i++) {
//         request.fields['tages[$i]'] = tagsList[i];
//       }

      // String tagsString = tags.join(',');
      // List<String> tagsList =
      //     tagsString.trim().split(',').map((tag) => tag).toList();
      // for (int i = 0; i < tagsList.length; i++) {
      //   request.fields['tages[$i]'] = tagsList[i];
      // }

      // Add other sign-up field s as needed
      request.fields['title'] = title;
      request.fields['opinion'] = desc;
      request.fields['location'] = location;
      request.fields['website'] = siteName;
      // request.fields['tages[]'] = tagsString;

      // Send the data to the server and wait for the response
      var streamedResponse = await request.send();

      // Convert the streamed response to a regular http.Response
      var response = await http.Response.fromStream(streamedResponse);

      // Handle the API response here
      if (response.statusCode == 200) {
        // Successful add feed
        setState(() {
          isUploadingData = false;
        });

        CustomDialogs.showSnakcbar(context, "Successfully Add feed");

        print(response.body);
        print('Add successfully!');
      } else {
        setState(() {
          isUploadingData = false;
        });
        print(response.body);

        CustomDialogs.showSnakcbar(
            context, "Error during adding feed. Please try again later.");

        // Error during add feed
        print('Error during adding feed: ${response.body}');
      }
    } catch (e) {
      setState(() {
        isUploadingData = false;
      });
      // Handle any other errors
      print('Error: $e');
      CustomDialogs.showSnakcbar(context, "Error: $e");
    }
  }
}
