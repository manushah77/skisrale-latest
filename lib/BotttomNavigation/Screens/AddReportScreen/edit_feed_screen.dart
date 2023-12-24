import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skisreal/Constant/const.dart';
import 'package:skisreal/Constant/dialoag_widget.dart';
import 'package:skisreal/models/FeedResponse.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

import '../../../Constant/color.dart';
import '../../../Constant/video_widget.dart';
import '../../../controller/edit_feed_controller.dart';
import '../../custom_bottom_navigation_bar_screen.dart';
import 'package:http/http.dart' as http;

class FeedEditScreen extends StatefulWidget {
  String? title;
  String? description;
  String? location;
  String? siteName;
  List<String>? allImgages;

  int? feedId;
  String? video;

  FeedEditScreen({
    Key? key,
    this.title,
    this.location,
    this.feedId,
    this.siteName,
    this.description,
    this.video,
    this.allImgages,
  }) : super(key: key);

  @override
  State<FeedEditScreen> createState() => _FeedEditScreenState();
}

class _FeedEditScreenState extends State<FeedEditScreen> {
  bool isUploadingData = false;

  TextEditingController titleC = TextEditingController();
  TextEditingController descriptionC = TextEditingController();
  TextEditingController locationC = TextEditingController();
  TextEditingController sitNamC = TextEditingController();

  final EditFeed_Controller controller = Get.put(EditFeed_Controller());

  //Get.put<EditFeed_Controller>();

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
    if (feedResponse!.feedDetail.images.length > 0 &&
        feedResponse!.feedDetail.images[0] != null) {
      deleteImage(feedResponse!.feedDetail.images[0]!).then((value) => {});
    }

    setState(() {
      imageOne = null;
      videoOne = null;
      feedImgOne = null;
      vpController = null;
    });
  }

  void _removeImageTwo() {
    if (feedResponse!.feedDetail.images.length > 1 &&
        feedResponse!.feedDetail.images[1] != null) {
      deleteImage(feedResponse!.feedDetail.images[1]!)
          .then((value) => {feedResponse!.feedDetail.images[1] = null});
    }
    setState(() {
      imageTwo = null;
      videoTwo = null;
      feedImgTwo = null;
      vpControllerTwo = null;
    });
  }

  void _removeImageThree() {
    if (feedResponse!.feedDetail.images.length > 2 &&
        feedResponse!.feedDetail.images[2] != null) {
      deleteImage(feedResponse!.feedDetail.images[2]!)
          .then((value) => {feedResponse!.feedDetail.images[2] = null});
    }
    setState(() {
      imageThree = null;
      videoThree = null;
      feedImgThree = null;
      vpControllerThree = null;
    });
  }

  void _removeImageFour() {
    if (feedResponse!.feedDetail.images.length > 3 &&
        feedResponse!.feedDetail.images[3] != null) {
      deleteImage(feedResponse!.feedDetail.images[3]!)
          .then((value) => {feedResponse!.feedDetail.images[3] = null});
    }
    setState(() {
      imageFour = null;
      videoFour = null;
      feedImgFour = null;
      vpControllerFour = null;
    });
  }

  void _removeImageFive() {
    if (feedResponse!.feedDetail.images.length > 4 &&
        feedResponse!.feedDetail.images[4] != null) {
      deleteImage(feedResponse!.feedDetail.images[4]!)
          .then((value) => {feedResponse!.feedDetail.images[4] = null});
    }
    setState(() {
      imageFive = null;
      videoFive = null;
      feedImgFive = null;
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
                      var pickImage =
                          await pickerOne.pickImage(source: ImageSource.gallery);

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
                      var pickImage =
                          await pickerOne.pickImage(source: ImageSource.gallery);

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
            padding: const EdgeInsets.only(top: 15),
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

  String? title;
  String? description;
  String? location;
  String? siteName;
  String? feedImgOne;
  String? feedImgTwo;
  String? feedImgThree;
  String? feedImgFour;
  String? feedImgFive;
  String? bottomVideo;

  void _removeVideoBottom() {
    setState(() {
      bottomVideo = null;
      bottomVideo = null;
      // vpControllerFive = null;
    });
  }

  void _removeVideo() {
    setState(() {
      video = null;
      vpController2 = null;
    });
  }

  // String? bottomVideo;

  FeedResponse? feedResponse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // setState(() {
    //   // controller.retrieveToken();
    //
    //   // controller.fetchCurrentUser();
    //
    // });

    controller.fetchFeeds(widget.feedId!).then((value) => {
          setState(() {
            feedResponse = FeedResponse.fromJson(value);
            log('value is $feedResponse');
            titleC.text = feedResponse!.feedDetail.title.toString();
            //value['feed_detail']['title'].toString();
            descriptionC.text = feedResponse!.feedDetail.opinion.toString();
            //value['feed_detail']['opinion'].toString();
            locationC.text = feedResponse!.feedDetail.location.toString();
            value['feed_detail']['location'].toString();
            sitNamC.text = feedResponse!.feedDetail.website.toString();
            value['feed_detail']['website'].toString();

            if (feedResponse!.feedDetail.images.length > 0) {
              feedImgOne = feedResponse!.feedDetail.images[0]?.image.toString();
            }

            if (feedResponse!.feedDetail.images.length > 1) {
              feedImgTwo = feedResponse!.feedDetail.images[1]?.image.toString();
            }

            if (feedResponse!.feedDetail.images.length > 2) {
              feedImgThree =
                  feedResponse!.feedDetail.images[2]?.image.toString();
            }

            if (feedResponse!.feedDetail.images.length > 3) {
              feedImgFour =
                  feedResponse!.feedDetail.images[3]?.image.toString();
            }

            if (feedResponse!.feedDetail.images.length > 4) {
              feedImgFive =
                  feedResponse!.feedDetail.images[4]?.image.toString();
            }

            if (feedResponse!.feedDetail.bottomVideo != null) {
              bottomVideo = feedResponse!.feedDetail.bottomVideo.toString();
            }
          })
        });

    print(widget.feedId!);
    // print(' asdadasd ${widget.allImgages![0].toString()}');
    // bottomVideo = widget.video.toString();
    // titleC.text = controller.data[0]['title'].toString();
    // descriptionC.text = controller.data[0]['opinion'].toString();
    // locationC.text = controller.data[0]['location'].toString();
    // feedImgOne = '${controller.data[0]['images'][0]['image']}';
    // feedImgTwo = '${controller.data[0]['images'][1]['image']}';
    // feedImgThree = '${controller.data[0]['images'][2]['image']}';
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
            title: Padding(
              padding: const EdgeInsets.only(top: 22.0, left: 240),
              child: Text(
                'ערוך עדכון',
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
            automaticallyImplyLeading: false,
            backgroundColor: primaryColor,
          ),
        ),
        body: Obx(
          () => controller.isLoading == true && controller.data.value.isEmpty
              ? Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                )
              : Form(
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
                              onChanged: (newValue) {
                                // Update the textFieldValue whenever the text field is edited
                                setState(() {
                                  title = newValue;
                                });
                              },
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
                              onChanged: (newValue) {
                                // Update the textFieldValue whenever the text field is edited
                                setState(() {
                                  description = newValue;
                                });
                              },
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

                                hintText: 'כתבו את דעתכם כאן...',
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
                              onChanged: (newValue) {
                                // Update the textFieldValue whenever the text field is edited
                                setState(() {
                                  location = newValue;
                                });
                              },
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
                        SizedBox(
                          height: 12,
                        ),

                        //4th text field

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
                              onTap: () {
                                if (sitNamC.text == 'null') {
                                  sitNamC.clear();
                                }
                              },
                              onChanged: (newValue) {
                                // Update the textFieldValue whenever the text field is edited
                                setState(() {
                                  siteName = newValue;
                                });
                              },
                              controller: sitNamC,

                              // ignore: body_might_complete_normally_nullable
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your site name';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                suffixIconColor: Colors.black12,
                                contentPadding: EdgeInsets.only(
                                    top: 10, left: 15, right: 13, bottom: 10),
                                border: InputBorder.none,

                                hintText: '',
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

                        //5th text field

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
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 5),
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
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              child: AspectRatio(
                                                aspectRatio: vpController!
                                                    .value.aspectRatio,
                                                child:
                                                    VideoPlayer(vpController!),
                                              ),
                                            ),
                                          ),
                                        if (imageOne != null &&
                                            (vpController == null ||
                                                !vpController!
                                                    .value.isInitialized))
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            child: Image.file(
                                              imageOne!,
                                              fit: BoxFit.cover,
                                              height: 70,
                                              width: 70,
                                            ),
                                          ),
                                        if (imageOne == null &&
                                            (vpController == null ||
                                                !vpController!
                                                    .value.isInitialized))
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            child: Container(
                                              height: 70,
                                              width: 70,
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              child: feedImgOne == null
                                                  ? Image.asset(
                                                      'assets/icons/add.png',
                                                      scale: 4,
                                                    )
                                                  : Image.network(
                                                      fit: BoxFit.cover,
                                                      feedImgOne.toString(),
                                                      height: 70,
                                                      width: 70,
                                                      errorBuilder:
                                                          (BuildContext context,
                                                              Object exception,
                                                              StackTrace?
                                                                  stackTrace) {
                                                        // Handle the error here
                                                        print("IamgeLoadFail");
                                                        return VideoPlayerWidget(
                                                            feedImgOne!);
                                                      },
                                                    ),
                                            ),
                                          ),
                                        if (imageOne != null ||
                                            videoOne != null ||
                                            feedImgOne !=
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
                                padding:
                                    const EdgeInsets.only(left: 5.0, right: 5),
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
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: AspectRatio(
                                              aspectRatio: vpControllerTwo!
                                                  .value.aspectRatio,
                                              child:
                                                  VideoPlayer(vpControllerTwo!),
                                            ),
                                          ),
                                        ),
                                      if (imageTwo != null &&
                                          (vpControllerTwo == null ||
                                              !vpControllerTwo!
                                                  .value.isInitialized))
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          child: Image.file(
                                            imageTwo!,
                                            fit: BoxFit.cover,
                                            height: 70,
                                            width: 70,
                                          ),
                                        ),
                                      if (imageTwo == null &&
                                          (vpControllerTwo == null ||
                                              !vpControllerTwo!
                                                  .value.isInitialized))
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          child: Container(
                                            height: 70,
                                            width: 70,
                                            color: Colors.grey.withOpacity(0.2),
                                            child: feedImgTwo == null
                                                ? Image.asset(
                                                    'assets/icons/add.png',
                                                    scale: 4,
                                                  )
                                                : Image.network(
                                                    fit: BoxFit.cover,
                                                    feedImgTwo.toString(),
                                                    height: 70,
                                                    width: 70,
                                                    errorBuilder:
                                                        (BuildContext context,
                                                            Object exception,
                                                            StackTrace?
                                                                stackTrace) {
                                                      // Handle the error here
                                                      print("IamgeLoadFail");
                                                      return VideoPlayerWidget(
                                                          feedImgTwo!);
                                                    },
                                                  ),
                                          ),
                                        ),
                                      if (imageTwo != null ||
                                          videoTwo != null ||
                                          feedImgTwo !=
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
                                padding:
                                    const EdgeInsets.only(left: 5.0, right: 5),
                                child: InkWell(
                                  onTap: () {
                                    myFocusNode.unfocus();

                                    _showBottomSheetThree();
                                  },
                                  child: Stack(
                                    children: [
                                      if (vpControllerThree != null &&
                                          vpControllerThree!
                                              .value.isInitialized)
                                        SizedBox(
                                          height: 70,
                                          width: 70,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: AspectRatio(
                                              aspectRatio: vpControllerThree!
                                                  .value.aspectRatio,
                                              child: VideoPlayer(
                                                  vpControllerThree!),
                                            ),
                                          ),
                                        ),
                                      if (imageThree != null &&
                                          (vpControllerThree == null ||
                                              !vpControllerThree!
                                                  .value.isInitialized))
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          child: Image.file(
                                            imageThree!,
                                            fit: BoxFit.cover,
                                            height: 70,
                                            width: 70,
                                          ),
                                        ),
                                      if (imageThree == null &&
                                          (vpControllerThree == null ||
                                              !vpControllerThree!
                                                  .value.isInitialized))
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          child: Container(
                                            height: 70,
                                            width: 70,
                                            color: Colors.grey.withOpacity(0.2),
                                            child: feedImgThree == null
                                                ? Image.asset(
                                                    'assets/icons/add.png',
                                                    scale: 4,
                                                  )
                                                : Image.network(
                                                    fit: BoxFit.cover,
                                                    feedImgThree.toString(),
                                                    height: 70,
                                                    width: 70,
                                                    errorBuilder:
                                                        (BuildContext context,
                                                            Object exception,
                                                            StackTrace?
                                                                stackTrace) {
                                                      // Handle the error here
                                                      print("IamgeLoadFail");
                                                      return VideoPlayerWidget(
                                                          feedImgTwo!);
                                                    },
                                                  ),
                                          ),
                                        ),
                                      if (imageThree != null ||
                                          videoThree != null ||
                                          feedImgThree !=
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
                                padding:
                                    const EdgeInsets.only(left: 5.0, right: 5),
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
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: AspectRatio(
                                              aspectRatio: vpControllerFour!
                                                  .value.aspectRatio,
                                              child: VideoPlayer(
                                                  vpControllerFour!),
                                            ),
                                          ),
                                        ),
                                      if (imageFour != null &&
                                          (vpControllerFour == null ||
                                              !vpControllerFour!
                                                  .value.isInitialized))
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          child: Image.file(
                                            imageFour!,
                                            fit: BoxFit.cover,
                                            height: 70,
                                            width: 70,
                                          ),
                                        ),
                                      if (imageFour == null &&
                                          (vpControllerFour == null ||
                                              !vpControllerFour!
                                                  .value.isInitialized))
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          child: Container(
                                            height: 70,
                                            width: 70,
                                            color: Colors.grey.withOpacity(0.2),
                                            child: feedImgFour == null
                                                ? Image.asset(
                                                    'assets/icons/add.png',
                                                    scale: 4,
                                                  )
                                                : Image.network(
                                                    fit: BoxFit.cover,
                                                    feedImgFour.toString(),
                                                    height: 70,
                                                    width: 70,
                                                    errorBuilder:
                                                        (BuildContext context,
                                                            Object exception,
                                                            StackTrace?
                                                                stackTrace) {
                                                      // Handle the error here
                                                      print("IamgeLoadFail");
                                                      return VideoPlayerWidget(
                                                          feedImgTwo!);
                                                    },
                                                  ),
                                          ),
                                        ),
                                      if (imageFour != null ||
                                          videoFour != null ||
                                          feedImgFour !=
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
                                padding:
                                    const EdgeInsets.only(left: 5.0, right: 15),
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
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: AspectRatio(
                                              aspectRatio: vpControllerFive!
                                                  .value.aspectRatio,
                                              child: VideoPlayer(
                                                  vpControllerFive!),
                                            ),
                                          ),
                                        ),
                                      if (imageFive != null &&
                                          (vpControllerFive == null ||
                                              !vpControllerFive!
                                                  .value.isInitialized))
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          child: Image.file(
                                            imageFive!,
                                            fit: BoxFit.cover,
                                            height: 70,
                                            width: 70,
                                          ),
                                        ),
                                      if (imageFive == null &&
                                          (vpControllerFive == null ||
                                              !vpControllerFive!
                                                  .value.isInitialized))
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          child: Container(
                                            height: 70,
                                            width: 70,
                                            color: Colors.grey.withOpacity(0.2),
                                            child: feedImgFive == null
                                                ? Image.asset(
                                                    'assets/icons/add.png',
                                                    scale: 4,
                                                  )
                                                : Image.network(
                                                    fit: BoxFit.cover,
                                                    feedImgFive.toString(),
                                                    height: 70,
                                                    width: 70,
                                                    errorBuilder:
                                                        (BuildContext context,
                                                            Object exception,
                                                            StackTrace?
                                                                stackTrace) {
                                                      // Handle the error here
                                                      print("IamgeLoadFail");
                                                      return VideoPlayerWidget(
                                                          feedImgTwo!);
                                                    },
                                                  ),
                                          ),
                                        ),
                                      if (imageFive != null ||
                                          videoFive != null ||
                                          feedImgFive !=
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

                        bottomVideo == null
                            ? InkWell(
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
                                        aspectRatio: vpController2!
                                            .value.aspectRatio,
                                        child: vpController2!
                                            .value.isInitialized
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

                                    : Container()
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            right: 20.0, left: 18),
                                        child: DottedBorder(
                                          color: Colors.blue,
                                          strokeWidth: 2,
                                          dashPattern: [1.3, 5],
                                          child: Container(
                                            height: 140,
                                            width: 320,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                              )
                            : InkWell(
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
                                                  aspectRatio: vpController2!
                                                      .value.aspectRatio,
                                                  child: vpController2!
                                                          .value.isInitialized
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
                                            // height: 200,
                                            // width: double.infinity,
                                            // child:
                                            //     VideoPlayerWidget(bottomVideo!),
                                          )
                                    :Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15.0,right: 15),
                                          child: Container(
                                  height: 200,
                                  width: MediaQuery.of(context).size.width/1.12,
                                  child:
                                  VideoPlayerWidget(bottomVideo!),
                                ),
                                        ),
                                        Positioned(
                                          top: 10,
                                          right: 15,
                                          child: InkWell(
                                            onTap: _removeVideoBottom,
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

                        // Padding(
                        //   padding: const EdgeInsets.only(left: 15.0, right: 15),
                        //   child: Container(
                        //     height: 200,
                        //     width: double.infinity,
                        //     child: bottomVideo != null
                        //         ? VideoPlayerWidget(bottomVideo!)
                        //         : Visibility(
                        //             visible: bottomVideo == null,
                        //             child: Center(
                        //               child: Text("The video is not available"),
                        //             ),
                        //           ),
                        //   ),
                        // ),

                        //button

                        SizedBox(
                          height: 30,
                        ),
                        isUploadingData == true
                            ? CircularProgressIndicator(
                                color: primaryColor,
                              )
                            : Padding(
                                padding: const EdgeInsets.only(
                                    right: 20.0, left: 18),
                                child: InkWell(
                                  onTap: () async {
                                    if (formKey.currentState!.validate()) {
                                      await updateFeed().then((value) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CustomBottomBar(
                                                  index: 3,
                                                ),
                                          ),
                                        );
                                        // titleC.clear();
                                        // descriptionC.clear();
                                        // locationC.clear();
                                        // vpController = null;
                                        // vpControllerTwo = null;
                                        // vpControllerThree = null;
                                        // vpControllerFour = null;
                                        // vpControllerFive = null;
                                        // vpController2 = null;
                                        // imageOne = null;
                                        // imageTwo = null;
                                        // imageThree = null;
                                        // imageFour = null;
                                        // imageFive = null;
                                        // videoOne = null;
                                        // videoTwo = null;
                                        // videoThree = null;
                                        // videoFour = null;
                                        // videoFive = null;
                                        // video = null;
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: 380,
                                    height: 48,
                                    decoration: ShapeDecoration(
                                      color: Color(0xFF00B3D7),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4)),
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
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  //token

  String? token;

  // void retrieveToken() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     token = prefs.getString('token');
  //     print('My fetch token is $token');
  //   });
  // }

  bool shouldUpdateVideo = false;

  Future<void> updateFeed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      token = prefs.getString('token');
    });

    String title = titleC.text.toString().trim();
    String desc = descriptionC.text.toString().trim();
    String location = locationC.text.toString().trim();
    String tags = locationC.text.toString().trim();
    String siteName = sitNamC.text.toString();

    List<File?> images = [imageOne, imageTwo, imageThree, imageFour, imageFive];
    List<File?> videoFiles = [
      videoOne,
      videoTwo,
      videoThree,
      videoFour,
      videoFive
    ]; // Replace with your list of video files

    List<String> urls = [];

    if (feedResponse!.feedDetail.images.length > 0 &&
        feedResponse!.feedDetail.images[0] != null) {
      urls.add(feedResponse!.feedDetail.images[0]!.image.toString());
    }

    if (feedResponse!.feedDetail.images.length > 1 &&
        feedResponse!.feedDetail.images[1] != null) {
      urls.add(feedResponse!.feedDetail.images[1]!.image.toString());
    }

    if (feedResponse!.feedDetail.images.length > 2 &&
        feedResponse!.feedDetail.images[2] != null) {
      urls.add(feedResponse!.feedDetail.images[2]!.image.toString());
    }

    if (feedResponse!.feedDetail.images.length > 3 &&
        feedResponse!.feedDetail.images[3] != null) {
      urls.add(feedResponse!.feedDetail.images[3]!.image.toString());
    }

    if (feedResponse!.feedDetail.images.length > 4 &&
        feedResponse!.feedDetail.images[4] != null) {
      urls.add(feedResponse!.feedDetail.images[4]!.image.toString());
    }

    setState(() {
      isUploadingData = true;
    });

    try {
      // Validate required fields
      if (title.isEmpty || desc.isEmpty) {
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

      String apiUrl = Consts.BASE_URL + '/api/edit_feed';
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      String accessToken = "$token";
      request.headers['Authorization'] = 'Bearer $accessToken';
      request.headers['Accept'] = 'application/json';

      // Add images to the request
      for (int i = 0; i < images.length; i++) {
        if (images[i] != null) {
          var imageStream = http.ByteStream(images[i]!.openRead());
          var length = await images[i]!.length();
          var multipartFile = http.MultipartFile(
            'file[]',
            imageStream,
            length,
            filename: 'assets/images/$i.png',
          );
          request.files.add(multipartFile);
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
              'assets/videos/${DateTime.now().millisecondsSinceEpoch}_bottom.mp4',
        );
        request.files.add(videoMultipartFile);
      }

      request.fields['title'] = title;
      request.fields['opinion'] = desc;
      request.fields['location'] = location;
      request.fields['website'] = siteName;
      request.fields['id'] = widget.feedId.toString();

      for (var url in urls) {
        request.fields['file_url[$url]'] = url;
        print("My URL : $url");
      }
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        setState(() {
          isUploadingData = false;
        });
        CustomDialogs.showSnakcbar(context, "Successfully Update feed");

        print(response.body);
        print('Update successfully!');
      } else {
        setState(() {
          isUploadingData = false;
        });
        print(response.body);

        CustomDialogs.showSnakcbar(
            context, "Error during updating feed. Please try again later.");

        print('Error during updating feed: ${response.body}');
      }
    } catch (e) {
      setState(() {
        isUploadingData = false;
      });
      print('Error: $e');

      CustomDialogs.showSnakcbar(context, "Error: $e");
    }
  }

  //delete image
  Future<void> deleteImage(ImageData image) async {
    //get request to delete image
    var url =
        Uri.parse('https://sk.jeuxtesting.com/api/del_feed_image/${image.id}');
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer ${controller.token.value}',
    });
    if (response.statusCode == 200) {
      print('Image deleted successfully');

      CustomDialogs.showSnakcbar(context, "Successfully Delete Image");
    } else {
      print('Error occurred while deleting image ${response.body}');

      CustomDialogs.showSnakcbar(
          context, "Error occurred while deleting image");
    }
  }
}

