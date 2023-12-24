import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skisreal/BotttomNavigation/CommentPage/CommentPage.dart';
import 'package:skisreal/BotttomNavigation/Models/feed_model.dart';
import 'package:skisreal/BotttomNavigation/Screens/HomeScreen/detail_page.dart';
import 'package:skisreal/BotttomNavigation/Screens/HomeScreen/tag_screen.dart';
import 'package:skisreal/BotttomNavigation/Screens/ProfileScreen/profile_screen.dart';
import 'package:http/http.dart' as http;
import 'package:skisreal/Constant/const.dart';
import 'package:skisreal/Constant/dialoag_widget.dart';
import 'package:skisreal/controller/homeScreen_controller.dart';
import 'package:skisreal/service/service.dart';
import 'package:uni_links/uni_links.dart';

import '../../../Constant/color.dart';
import '../../Models/userModel.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //token
  var controller = Get.put(HomeScreen_Controller());
  String? token;
  String? id;
  List<String> likedPosts = [];
  List<dynamic> data = [];

  Future<void> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      id = prefs.getString('id');
      print("this is token $token");
      print("this is id $id");
    });
    // print('asdadasda $token');
  }

  //add like to feed
  Future addLike(int feedID, status) async {
    final response = await http.post(
      Uri.parse(Consts.BASE_URL + '/api/liked_feed'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'feed_id': feedID,
        'status': status,
      }),
    );

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);

      return jsonBody;
    } else {
      undoLike(feedID);
      throw Exception('Failed to add like');
    }
  }

  void toggleButton(int feedID) {
    final tile = controller.data.value
        .firstWhere((item) => item['id'] == feedID, orElse: () => null);

    if (likedPosts.contains(feedID.toString())) {
      setState(() {
        likedPosts.remove(feedID.toString());
        tile != null ? tile['like_count'] = tile['like_count'] - 1 : null;
      });
      addLike(feedID, 0);
    } else {
      setState(() {
        likedPosts.add(feedID.toString());
        tile != null ? tile['like_count'] = tile['like_count'] + 1 : null;
      });
      addLike(feedID, 1);
    }
  }

  undoLike(feedID) {
    /// show Error message if api fails
    final tile =
        data.firstWhere((item) => item['id'] == feedID, orElse: () => null);

    if (likedPosts.contains(feedID.toString())) {
      setState(() {
        likedPosts.remove(feedID.toString());
        tile != null ? tile['like_count'] = tile['like_count'] - 1 : null;
      });
    } else {
      setState(() {
        likedPosts.add(feedID.toString());
        tile != null ? tile['like_count'] = tile['like_count'] + 1 : null;
      });
    }
  }

  Future fetchFeeds() async {
    final response = await http
        .get(Uri.parse(Consts.BASE_URL + '/api/get_all_feed'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      var responsedData = jsonBody['feed'] as List<dynamic>;
      getImages(responsedData[0]['images']);
      List<FeedElement> feed = (jsonBody['feed'] as List<dynamic>)
          .map((e) => FeedElement.fromJson(e))
          .toList();
      for (var e in feed) {
        for (var like in e.likes!) {
          if (id == like.likedBy.toString()) {
            setState(() {
              likedPosts.add(e.id.toString());
            });
          }
        }
      }
      setState(() {
        data = responsedData;
      });
    } else {
      throw Exception('Failed to fetch feeds, ${response.statusCode} $token');
    }
  }

  //fetch user

  Future<User> fetchCurrentUser() async {
    final response = await http
        .get(Uri.parse(Consts.BASE_URL + '/api/user_profile'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      // print(jsonBody.toString());
      if (jsonBody['status'] == 'success') {
        final userJson = jsonBody['user'];
        // setState(() {
        //   base64Image = userJson['profile_image'];
        // });
        return User.fromJson(userJson);
      } else {
        throw Exception(jsonBody['message']);
      }
    } else {
      throw Exception(
          'Failed to connect to the API. Error code: ${response.statusCode}');
    }
  }

  //report feed api

  Future addReportFeed(int feedId) async {
    final response = await http.patch(
        Uri.parse(Consts.BASE_URL + '/api/report_feed/$feedId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      CustomDialogs.showSnakcbar(context, 'Report Submit');
      return jsonBody;
    } else {
      throw Exception(
          'Failed to connect to the API. Error code: ${response.statusCode}');
    }
  }

  StreamSubscription? _sub;

  Future<void> initUniLinks() async {
    // ... check initialLink

    // Attach a listener to the stream
    _sub = linkStream.listen((String? link) {
      // Parse the link and warn the user, if it is not correct
      if (link != null) {
        var uri = Uri.parse(link);
        if (uri.queryParameters['id'] != null) {
          print('object');
        }
      }
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initUniLinks();
    // fetchCurrentUser();

    setState(() {
      // controller.retrieveToken();
      controller.fetchFeeds();
      controller.fetchCurrentUser();
      retrieveToken().then((value) {
        fetchFeeds();
      });
    });
    retrieveToken().then((value) {
      refresh();
    });
  }

  List<String> images = [];

  getImages(List img) {
    images.clear();
    for (var all in img) images.add(all['image']);
    // print('my data is $images');
  }

  Future refresh() async {
    // fetchFeeds();
    await controller.fetchFeeds();
    setState(() {
      // Fluttertoast.showToast(msg: 'הנתונים שלך מעודכנים...!',gravity: ToastGravity.SNACKBAR);
    });
  }

  List tags = [];
  bool loader = false;

  // List<String> srachTags = [];

  Future TagCallFunction(List tages) async {
    try {
      setState(() {
        loader = true;
      });
      // String autToken=token!;
      Map data = {"tages": tages};
      await UserService()
          .postApiwithToken(
              "api/tag_search", data, controller.token.value.toString())
          .then((value) {
        // print(value);
        if (value["status"] == "success") {
          List<dynamic> feedsList = value['feed'];
          tags.clear();
          feedsList.forEach((element) {
            tags.add(element);
          });
          // print(feedsList);

          return feedsList;
        } else {}
      });
    } finally {
      setState(() {
        loader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: AppBar(
            elevation: 1,
            leading: Obx(() => controller.userLoader.value == true
                ? InkWell(
                    onTap: () {},
                    child: Image.asset(
                      'assets/icons/Profile.png',
                      scale: 4,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 8),
                    child: InkWell(
                      onTap: () {
                        Get.to(() => ProfileScreen(),
                            arguments: controller.loginUser.value,
                            transition: Transition.fade);
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: primaryColor,
                              width: 1,
                            ),
                            shape: BoxShape.circle),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: primaryColor,
                          backgroundImage: NetworkImage(controller
                              .loginUser.value["profile_image"]
                              .toString()),
                          // radi,
                        ),
                      ),
                    ),
                  )),
            automaticallyImplyLeading: false,
            flexibleSpace: const Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: Image(
                image: AssetImage(
                  'assets/images/skisHome.png',
                ),
                fit: BoxFit.contain,
                height: 100,
                width: 100,
              ),
            ),
            backgroundColor: Colors.white,
          ),
        ),
        body: Obx(
          () => controller.isLoading == true
              ? Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                )
              : controller.data.isEmpty
                  ? RefreshIndicator(
                      color: primaryColor,
                      onRefresh: refresh,
                      child: ListView(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 300,
                              ),
                              Text('אין עדכונים זמינים\''),
                            ],
                          ),
                        ],
                      ),
                    )
                  : Stack(
                      children: [
                        Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: RefreshIndicator(
                                color: primaryColor,
                                onRefresh: refresh,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: controller.data.length,
                                    itemBuilder: (context, index) {
                                      // String names =
                                      //     '${controller.data.value[index]['tags'][0]['tag']}';
                                      // var splitNames = names.split(',');
                                      // List<String> splitList = List.from(
                                      //     splitNames); // Simply clone the splitNames list

                                      return Column(
                                        children: [
                                          //nam of sender, time and type who share the post
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 18.0),
                                                child: Text(
                                                  controller.data.value[index]
                                                              ['users'] ==
                                                          null
                                                      ? '${DateTime.parse(controller.data.value[index]['created_at']).toLocal()}'  .substring(0, 16)
                                                      : '${DateTime.parse(controller.data.value[index]['created_at']).toLocal()}'
                                                          .substring(0, 16),
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    color: Color(0xFF73787F),
                                                    fontSize: 12,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              controller.data.value[index]
                                                          ['users'] ==
                                                      null
                                                  ? Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          'מערכת סקי ישראל',
                                                          textAlign:
                                                              TextAlign.right,
                                                          style:
                                                              const TextStyle(
                                                            color: Color(
                                                                0xFF172B4C),
                                                            fontSize: 12,
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        Text(
                                                          controller.data.value[
                                                                          index]
                                                                      [
                                                                      'author'] ==
                                                                  null
                                                              ? ''
                                                              : '${controller.data.value[index]['author'].toString()}',

                                                          style:
                                                              const TextStyle(
                                                            color: Color(
                                                                0xFF172B4C),
                                                            fontSize: 12,
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : Text(
                                                      '${controller.data.value[index]['users']['name'].toString()}',
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xFF172B4C),
                                                        fontSize: 16,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 18.0),
                                                child: Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: primaryColor
                                                          .withOpacity(0.3),
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50.0),
                                                    child: CachedNetworkImage(
                                                      width: 40,
                                                      height: 40,
                                                      imageUrl: controller.data
                                                                          .value[
                                                                      index]
                                                                  ['users'] ==
                                                              null
                                                          ? 'assets/images/skis.jpg'
                                                          : "${controller.data.value[index]['users']['profile_image'].toString()}",
                                                      fit: BoxFit.cover,
                                                      progressIndicatorBuilder:
                                                          (context, url,
                                                                  downloadProgress) =>
                                                              Center(
                                                        child: CircularProgressIndicator(
                                                            color: primaryColor,
                                                            value:
                                                                downloadProgress
                                                                    .progress),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Container(
                                                        height: 45,
                                                        width: 45,
                                                        child: Image.asset(
                                                          'assets/images/skis.jpg',
                                                          height: 40,
                                                          width: 40,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      filterQuality:
                                                          FilterQuality.high,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(
                                            height: 15,
                                          ),

                                          //image
                                          controller.data[index]['images'] !=
                                                      null &&
                                                  controller
                                                      .data[index]['images']
                                                      .isNotEmpty
                                              ? InkWell(
                                                  onTap: () {
                                                    PersistentNavBarNavigator
                                                        .pushNewScreen(context,
                                                            screen: DetailPage(
                                                              currentUserId: controller
                                                                              .data[index]
                                                                          [
                                                                          'users'] ==
                                                                      null
                                                                  ? 0
                                                                  : controller.data[
                                                                          index]
                                                                      [
                                                                      'users']['id'],
                                                              siteName: controller
                                                                          .data
                                                                          .value[
                                                                      index]
                                                                  ['website'],
                                                              feedName: controller
                                                                          .data
                                                                          .value[
                                                                      index]
                                                                  ['title'],
                                                              description: controller
                                                                          .data
                                                                          .value[
                                                                      index]
                                                                  ['opinion'],
                                                              location: controller
                                                                          .data
                                                                          .value[
                                                                      index]
                                                                  ['location'],
                                                              img: controller
                                                                          .data
                                                                          .value[index]
                                                                      ['images']
                                                                  [0]['image'],
                                                              feedID: controller
                                                                      .data
                                                                      .value[
                                                                  index]['id'],
                                                              video: controller
                                                                          .data
                                                                          .value[
                                                                      index][
                                                                  'bottom_video'],
                                                            ),
                                                            withNavBar: false,
                                                            pageTransitionAnimation:
                                                                PageTransitionAnimation
                                                                    .fade);
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 15.0,
                                                            left: 15),
                                                    child: CachedNetworkImage(
                                                      width: 380,
                                                      height: 230,
                                                      imageUrl:
                                                          '${controller.data[index]['images'][0]['image']}',
                                                      fit: BoxFit.cover,
                                                      progressIndicatorBuilder:
                                                          (context, url,
                                                                  downloadProgress) =>
                                                              Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: primaryColor,
                                                          value:
                                                              downloadProgress
                                                                  .progress,
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          CircleAvatar(
                                                        child: Image.asset(
                                                          'assets/images/skis.jpg',
                                                          width: 380,
                                                          height: 230,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                          const SizedBox(
                                            height: 15,
                                          ),

                                          //title post

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              controller.data.value[index]
                                                          ['users'] ==
                                                      null
                                                  ? Container()
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 18.0),
                                                      child: PopupMenuButton(
                                                        icon: Icon(
                                                            Icons.more_horiz),
                                                        onSelected: (value) {
                                                          if (value == 1) {
                                                            retrieveToken()
                                                                .then((value) {
                                                              addReportFeed(
                                                                  controller
                                                                          .data
                                                                          .value[
                                                                      index]['id']);
                                                            });
                                                          } else {
                                                            retrieveToken()
                                                                .then((value) {
                                                              _deleteFeed(controller
                                                                      .data
                                                                      .value[
                                                                  index]['id']);
                                                            });
                                                          }
                                                        },
                                                        itemBuilder:
                                                            (BuildContext bc) {
                                                          return [
                                                            PopupMenuItem(
                                                              child: Text(
                                                                  "Report"),
                                                              value: 1,
                                                            ),
                                                            // controller.data[index]
                                                            //                 [
                                                            //                 'users']
                                                            //             [
                                                            //             'id'] ==
                                                            //         int.parse(
                                                            //             id!)
                                                            //     ? PopupMenuItem(
                                                            //         child: Text(
                                                            //             "Delete"),
                                                            //         value: 2,
                                                            //       )
                                                            //     : PopupMenuItem(
                                                            //         child: Text(
                                                            //             "Cancel"),
                                                            //       ),
                                                          ];
                                                        },
                                                      )),
                                              // Spacer(),
                                              Expanded(
                                                child: InkWell(
                                                  splashColor: Colors.transparent,
                                                  highlightColor: Colors.transparent,
                                                  onTap: () {
                                                    PersistentNavBarNavigator.pushNewScreen(
                                                      context,
                                                      screen: DetailPage(
                                                        currentUserId: controller.data[index]['users'] == null
                                                            ? 0
                                                            : controller.data[index]['users']['id'],
                                                        siteName: controller.data.value[index]['website'],
                                                        feedName: controller.data.value[index]['title'],
                                                        description: controller.data.value[index]['opinion'],
                                                        location: controller.data.value[index]['location'],
                                                        // Check if images list is not empty before accessing the image
                                                        img: (controller.data.value[index]['images'] != null &&
                                                            controller.data.value[index]['images'].isNotEmpty)
                                                            ? controller.data.value[index]['images'][0]['image']
                                                            : 'assets/images/skis.jpg', // Provide a default image path
                                                        feedID: controller.data.value[index]['id'],
                                                        video: controller.data.value[index]['bottom_video'],
                                                      ),
                                                      withNavBar: false,
                                                      pageTransitionAnimation: PageTransitionAnimation.fade,
                                                    );
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(
                                                      right: 18.0,
                                                    ),
                                                    child: Text(
                                                      '${controller.data.value[index]['title'].toString()}',
                                                      textAlign: TextAlign.right,
                                                      style: const TextStyle(
                                                        color: Color(0xFF172B4C),
                                                        fontSize: 20,
                                                        fontFamily: 'Inter',
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                      maxLines: 4,
                                                      overflow: TextOverflow.ellipsis,
                                                      textScaleFactor: 1.0,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),

                                          //description post

                                          InkWell(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () {
                                              PersistentNavBarNavigator
                                                  .pushNewScreen(context,
                                                  screen: DetailPage(
                                                    currentUserId: controller
                                                        .data[index]
                                                    [
                                                    'users'] ==
                                                        null
                                                        ? 0
                                                        : controller.data[
                                                    index]
                                                    [
                                                    'users']['id'],
                                                    siteName: controller
                                                        .data
                                                        .value[
                                                    index]
                                                    ['website'],
                                                    feedName: controller
                                                        .data
                                                        .value[
                                                    index]
                                                    ['title'],
                                                    description: controller
                                                        .data
                                                        .value[
                                                    index]
                                                    ['opinion'],
                                                    location: controller
                                                        .data
                                                        .value[
                                                    index]
                                                    ['location'],
                                                    img: (controller.data.value[index]['images'] != null &&
                                                        controller.data.value[index]['images'].isNotEmpty)
                                                        ? controller.data.value[index]['images'][0]['image']
                                                        : 'assets/images/skis.jpg', // Provide a default image path
                                                    feedID: controller
                                                        .data
                                                        .value[
                                                    index]['id'],
                                                    video: controller
                                                        .data
                                                        .value[
                                                    index][
                                                    'bottom_video'],
                                                  ),
                                                  withNavBar: false,
                                                  pageTransitionAnimation:
                                                  PageTransitionAnimation
                                                      .fade);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 18.0, left: 15),
                                              child: Align(
                                                alignment: Alignment.centerRight,
                                                child: Text(
                                                  '${controller.data.value[index]['opinion'].toString()}',
                                                  style: const TextStyle(
                                                    color: Color(0xFF44474C),
                                                    fontSize: 12,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  textScaleFactor: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                  softWrap: false,
                                                  textAlign: TextAlign.right,
                                                ),
                                              ),
                                            ),
                                          ),

                                          //location

                                          const SizedBox(
                                            height: 15,
                                          ),
                                          controller.data.value[
                                          index][
                                          'location'] ==
                                              null ? Container():
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 18.0, left: 15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                  '${controller.data.value[index]['location'].toString()}',
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xFF172B4C),
                                                        fontSize: 13,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                      textScaleFactor: 1.0,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Image.asset(
                                                  'assets/icons/loc.png',
                                                  scale: 4,
                                                ),
                                              ],
                                            ),
                                          ),

                                          const SizedBox(
                                            height: 15,
                                          ),

                                          //hashtag text

                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Wrap(
                                              children: List.generate(
                                                controller
                                                    .data[index]['tags'].length,
                                                (tagIndex) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        var singleTag =
                                                            controller.data[
                                                                        index]
                                                                    ['tags'][
                                                                tagIndex]['tag'];
                                                        TagCallFunction([
                                                          controller.data[index]
                                                                  ['tags']
                                                              [tagIndex]['tag']
                                                        ]).then((value) {
                                                          PersistentNavBarNavigator
                                                              .pushNewScreen(
                                                            context,
                                                            screen: TagScreen(
                                                              tagData: tags,
                                                              tag: singleTag,
                                                              FeedId: controller
                                                                      .data[
                                                                  index]['id'],
                                                            ),
                                                            withNavBar: false,
                                                            pageTransitionAnimation:
                                                                PageTransitionAnimation
                                                                    .fade,
                                                          );
                                                        });
                                                      },
                                                      child: ShowTag(
                                                        title: controller
                                                                    .data[index]
                                                                ['tags']
                                                            [tagIndex]['tag'],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),

                                          //like comment share row

                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0, left: 10),
                                            child: Container(
                                              width: 358,
                                              height: 32,
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                  left: BorderSide(
                                                      color: Color(0xFFEFF3F9)),
                                                  top: BorderSide(
                                                      width: 0.50,
                                                      color: Color(0xFFEFF3F9)),
                                                  right: BorderSide(
                                                      color: Color(0xFFEFF3F9)),
                                                  bottom: BorderSide(
                                                      color: Color(0xFFEFF3F9)),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 15.0),
                                                    child: InkWell(
                                                      onTap: isLoading == true
                                                          ? () {}
                                                          : () async {
                                                              List<String>
                                                                  imagePaths =
                                                                  [];
                                                              for (var imageData
                                                                  in controller
                                                                              .data[
                                                                          index]
                                                                      [
                                                                      'images']) {
                                                                String
                                                                    imageUrl =
                                                                    imageData[
                                                                        'image'];
                                                                imagePaths.add(
                                                                    imageUrl);
                                                              }
                                                              await shareIntent(
                                                                controller.data[
                                                                        index]
                                                                    ["title"],
                                                                // 'https://sk.jeuxtesting.com/userFeedDetails/${controller.data[index]["id"]}',
                                                                controller.data[
                                                                        index]
                                                                    ["opinion"],
                                                                imagePaths,
                                                              );
                                                              // controller
                                                              //     .data[index]
                                                              // ["id"],);
                                                            },
                                                      child: Container(
                                                        width: 20,
                                                        height: 20,
                                                        child: Image.asset(
                                                          'assets/icons/Share.png',
                                                          scale: 4,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        right: 8),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                '${controller.data.value[index]['comments_count'].toString()}',
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                style:
                                                                    const TextStyle(
                                                                  color: Color(
                                                                      0xFF172B4C),
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      'Inter',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 8),
                                                              InkWell(
                                                                onTap: () {
                                                                  PersistentNavBarNavigator.pushNewScreen(
                                                                      context,
                                                                      screen:
                                                                          CommentPage(
                                                                        feedId: controller
                                                                            .data
                                                                            .value[index]['id'],
                                                                      ),
                                                                      withNavBar:
                                                                          false,
                                                                      pageTransitionAnimation:
                                                                          PageTransitionAnimation
                                                                              .fade);
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 20,
                                                                  height: 20,
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/icons/Comment.png',
                                                                    scale: 3,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 40),
                                                        Container(
                                                          child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  '${controller.data.value[index]['like_count'].toString()}',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Color(
                                                                        0xFF172B4C),
                                                                    fontSize:
                                                                        14,
                                                                    fontFamily:
                                                                        'Inter',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 8),
                                                                InkWell(
                                                                  splashColor:
                                                                      Colors
                                                                          .transparent,
                                                                  highlightColor:
                                                                      Colors
                                                                          .transparent,
                                                                  hoverColor: Colors
                                                                      .transparent,
                                                                  onTap: () {
                                                                    toggleButton(
                                                                      controller
                                                                          .data
                                                                          .value[index]['id'],
                                                                    );
                                                                  },
                                                                  child: Icon(
                                                                    likedPosts.contains(controller
                                                                            .data
                                                                            .value[index][
                                                                                'id']
                                                                            .toString())
                                                                        ? Icons
                                                                            .favorite
                                                                        : Icons
                                                                            .favorite_border,
                                                                    size: 20,
                                                                    color: likedPosts.contains(controller
                                                                            .data
                                                                            .value[index][
                                                                                'id']
                                                                            .toString())
                                                                        ? Colors
                                                                            .red
                                                                        : primaryColor,
                                                                  ),
                                                                ),
                                                              ]),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          // SvgPicture.asset(assetName),
                                        ],
                                      );
                                    }),
                              ),
                            )
                          ],
                        ),
                        if (loader == true || isLoading == true)
                          Container(
                            color: Colors.black.withOpacity(0.7),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            ),
                          ),
                      ],
                    ),
        ));
  }

  bool isLoading = false;

  // Future<void> shareIntent(int feedID) async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //
  //   await Share.shareUri(
  //       Uri.parse('https://sk.jeuxtesting.com/userFeedDetails/$feedID'));
  //
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  //share intent

  Future<void> shareIntent(String text, String description,
      List<String> imgUrls) async {
    setState(() {
      isLoading = true;
    });

    List<String> imagePaths = [];

    if (imgUrls != null && imgUrls.isNotEmpty) {
      for (String imgUrl in imgUrls) {
        final url = Uri.parse(imgUrl);
        final response = await http.get(url);
        final bytes = response.bodyBytes;

        final temp = await getTemporaryDirectory();
        final path = '${temp.path}/${imgUrl.hashCode}.png';
        File(path).writeAsBytesSync(bytes);

        imagePaths.add(path);
      }
    }

    final message =
        '*Title*: $text\n*Description*: $description';
        // '*Title*: $text\n*Description*: $description\n*AppPackageName*: $appName';

    if (imagePaths.isNotEmpty) {
      await Share.shareFiles(
        imagePaths,
        text: message,
      );
    } else {
      await Share.share(
        message,
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  void _deleteFeed(int id) {
    print(id);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Feed',
            style: TextStyle(
              color: Color(0xFF172B4C),
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this Feed?',
            style: TextStyle(
              color: Color(0xFF172B4C),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF172B4C),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _confirmDialog(id);
                Navigator.pop(context);
              },
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Color(0xFF172B4C),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmDialog(int id) async {
    retrieveToken().then((value) async {
      var url = "${Consts.BASE_URL}/api/delete_feed/${id}";

      var response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        CustomDialogs.showSnakcbar(context, 'Feed Deleted Successfully');
      } else {
        CustomDialogs.showSnakcbar(context, 'Feed Deleted Successfully');
        print(response.body);
      }
      refresh();
    });
  }
}

class ShowTag extends StatefulWidget {
  String? title;

  ShowTag({Key? key, this.title}) : super(key: key);

  @override
  State<ShowTag> createState() => _ShowTagState();
}

class _ShowTagState extends State<ShowTag> {
  List list = [];
  bool _isSelected = true;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      selectedShadowColor: Colors.black,
      // side: BorderSide(
      //   color: _isSelected ? Color(0xffE6C758) : Colors.transparent,
      //   width: _isSelected ? 4 : 0,
      // ),
      padding: EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 6,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      // padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      label: Text(
        '${widget.title}',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),

      // backgroundColor: Color(0xFFDEF3F7),
      elevation: 1,
      selected: _isSelected,
      selectedColor: Color(0xFFDEF3F7),
    );
  }
}
