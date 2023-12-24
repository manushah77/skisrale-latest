import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skisreal/BotttomNavigation/CommentPage/CommentPage.dart';
import 'package:skisreal/BotttomNavigation/Models/commentModel.dart';
import 'package:skisreal/BotttomNavigation/Models/search_class.dart';
import 'package:skisreal/BotttomNavigation/Screens/HomeScreen/tag_screen.dart';
import 'package:skisreal/service/service.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;

import '../../../Constant/color.dart';
import '../../../Constant/const.dart';
import '../../../Constant/video_widget.dart';
import '../../../controller/homeScreen_controller.dart';
import '../../CommentPage/reply_comment_page.dart';
import '../../custom_bottom_navigation_bar_screen.dart';
import '../AddReportScreen/edit_feed_screen.dart';
import 'home_screen.dart';

class DetailPage extends StatefulWidget {
  String? location;
  String? feedName;
  String? siteName;
  String? img;
  String? video;
  String? description;
  int? feedID;
  int? currentUserId;

  // List<String>? timing;

  DetailPage({
    Key? key,
    this.location,
    this.feedID,
    this.siteName,
    this.video,
    this.currentUserId,
    this.feedName,
    this.img,
    this.description,
  }) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final PageController controller = PageController();
  bool isLike = false;

  bool isLoading = false;

  // Future<void> shreIntent(
  //     String text, String description, String appName, img) async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   print(text);
  //   final urlImage = '$img';
  //   final url = Uri.parse(urlImage);
  //   final response = await http.get(url);
  //   final bytes = response.bodyBytes;
  //
  //   final temp = await getTemporaryDirectory();
  //   final path = '${temp.path}/image.png';
  //   File(path).writeAsBytesSync(bytes);
  //
  //   await Share.shareFiles([path],
  //       text:
  //       '*Title*: $text \n*Description*: $description  \n*AppPackageName*: $appName');
  //
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  Future<void> shareIntent(int feedID) async {
    setState(() {
      isLoading = true;
    });

    await Share.shareUri(
        Uri.parse('https://sk.jeuxtesting.com/userFeedDetails/$feedID'));

    setState(() {
      isLoading = false;
    });
  }

  String? token;
  String? id;

  Future<void> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      id = prefs.getString('id');
    });
    print(token);
  }

  List<dynamic> data = [];
  List tags = [];
  bool loader = false;

  Future TagCallFunction(List tages) async {
    try {
      setState(() {
        loader = true;
      });
      // String autToken=token!;
      Map data = {"tages": tages};
      await UserService()
          .postApiwithToken("api/tag_search", data, token.toString())
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

  //add like to comment
  Future addLike(int commentId, status) async {
    final response = await http.post(
      Uri.parse(Consts.BASE_URL + '/api/liked_comment'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'comment_id': commentId,
        'status': status,
      }),
    );

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);

      return jsonBody;
    } else {
      undoLike(commentId);
      throw Exception('Failed to add comment');
    }
  }

  List<String> likedComments = [];

  void toggleButton(int commentId) {
    final tile =
        data.firstWhere((item) => item['id'] == commentId, orElse: () => null);

    if (likedComments.contains(commentId.toString())) {
      setState(() {
        likedComments.remove(commentId.toString());
        tile != null
            ? tile['commentLikes_count'] = tile['commentLikes_count'] - 1
            : null;
      });
      addLike(commentId, 0);
    } else {
      setState(() {
        likedComments.add(commentId.toString());
        tile != null
            ? tile['commentLikes_count'] = tile['commentLikes_count'] + 1
            : null;
      });
      addLike(commentId, 1);
    }
  }

  undoLike(commentId) {
    /// show Error message if api fails
    final tile =
        data.firstWhere((item) => item['id'] == commentId, orElse: () => null);

    if (likedComments.contains(commentId.toString())) {
      setState(() {
        likedComments.remove(commentId.toString());
        tile != null
            ? tile['commentLikes_count'] = tile['commentLikes_count'] - 1
            : null;
      });
    } else {
      setState(() {
        likedComments.add(commentId.toString());
        tile != null
            ? tile['commentLikes_count'] = tile['commentLikes_count'] + 1
            : null;
      });
    }
  }

  void _deleteComment(int id) {
    print(id);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Comment',
            style: TextStyle(
              color: Color(0xFF172B4C),
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this comment?',
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
      var url = "${Consts.BASE_URL}/api/delete_comment/${id}";

      var response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
      } else {
        print(response.body);
      }

      refresh();
    });
  }

  Future refresh() async {
    getComment();
  }

  Future getComment() async {
    final response = await http.get(
        Uri.parse(Consts.BASE_URL + '/api/get_all_comment/${widget.feedID}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final responsedData = jsonBody['Comment'] as List<dynamic>;
      List<Comment> feed = (jsonBody['Comment'] as List<dynamic>)
          .map((e) => Comment.fromJson(e))
          .toList();
      for (var e in feed) {
        for (var like in e.commentLikes!) {
          if (id == like.likedBy.toString()) {
            setState(() {
              likedComments.add(e.id.toString());
            });
          }
        }
      }

      setState(() {
        data = responsedData;
      });
    } else {
      print("Comments Fetch Fail");
    }
  }

  //stream builder get data from apis
  // late Stream<List<dynamic>> stream = Stream.periodic(Duration(seconds: 5))
  //     .asyncMap((event) async => await getComment());

  Future fetchFeedsdetail(int feedID) async {
    final response = await http.post(
      Uri.parse(Consts.BASE_URL + '/api/feed_detail'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'feed_id': feedID}),
    );

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final data = jsonBody['feed_detail'];
      return data;
    } else {
      throw Exception('Failed to fetch feeds detail');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    retrieveToken().then((value) {
      getComment();
    });
  }

  var controlleryTwo = Get.put(HomeScreen_Controller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        elevation: 0,
        leading: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10),
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: isLoading == true
                    ? () {}
                    : () async {
                        await shareIntent(widget.feedID!);
                      },
                child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Color(0xff172B4C).withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/icons/Share.png',
                        color: Colors.white,
                        scale: 4,
                      ),
                    )),
              ),
            ),
          ],
        ),
        actions: [
          // widget.currentUserId == int.parse(id!) ?
          // Padding(
          //   padding: const EdgeInsets.only(top: 10),
          //   child: InkWell(
          //     splashColor: Colors.transparent,
          //     highlightColor: Colors.transparent,
          //     hoverColor: Colors.transparent,
          //     onTap: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           //asdadas
          //           builder: (context) => FeedEditScreen(
          //             title: widget.feedName,
          //             description: widget.description,
          //             location: widget.location,
          //             siteName: widget.siteName,
          //             feedId: widget.feedID,
          //           ),
          //         ),
          //       );
          //     },
          //     child: Container(
          //       width: 40,
          //       height: 40,
          //       decoration: BoxDecoration(
          //         color: Color(0xff172B4C).withOpacity(0.6),
          //         shape: BoxShape.circle,
          //       ),
          //       child: Center(
          //         child: Icon(
          //           Icons.edit,
          //           color: Colors.white,
          //         ),
          //       ),
          //     ),
          //   ),
          // )
          //     : Container(),
          SizedBox(
            width: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0, top: 10),
            child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xff172B4C).withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        //asdadas
                        builder: (context) => CustomBottomBar(
                          index: 3,
                        ),
                      ),
                    );
                  },
                  child: Center(
                    child: Image.asset(
                      'assets/icons/la.png',
                      color: Colors.white,
                      scale: 4,
                    ),
                  ),
                )),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder(
                    future: fetchFeedsdetail(widget.feedID!),
                    builder: (context, AsyncSnapshot sp) {
                      if (!sp.hasData) {
                        return Center(
                            child: CircularProgressIndicator(
                          color: primaryColor,
                        ));
                      }
                      final dataa = sp.data;

                      return Column(
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                height: 290,
                                child: PageView.builder(
                                  controller: controller,
                                  itemCount: dataa['images'].length,
                                  itemBuilder: (context, index) {
                                    var mediaUrl =
                                        dataa['images'][index]['image'];
                                    var isImage = mediaUrl.endsWith('.jpg') ||
                                        mediaUrl.endsWith('.png');

                                    if (isImage) {
                                      return CachedNetworkImage(
                                        height: 200,
                                        width: double.infinity,
                                        imageUrl: '${mediaUrl}',
                                        fit: BoxFit.cover,
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                Center(
                                          child: CircularProgressIndicator(
                                              color: primaryColor,
                                              value: downloadProgress.progress),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            CircleAvatar(
                                          child: Image.asset(
                                            'assets/images/skis.jpg',
                                            height: 200,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Container(
                                        height: 200,
                                        width: double.infinity,
                                        child: VideoPlayerWidget(
                                            mediaUrl), // Replace VideoPlayerWidget with your video player implementation
                                      );
                                    }
                                  },
                                ),
                              ),
                              Positioned.fill(
                                top: 240,
                                // left: 150,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: SmoothPageIndicator(
                                    controller: controller,
                                    count: dataa['images'].length == null ? 0: dataa['images'].length,
                                    effect: ScrollingDotsEffect(
                                      activeDotColor: Colors.white,
                                      dotColor: Colors.white60,
                                      strokeWidth: 4,
                                      dotHeight: 6,
                                      dotWidth: 6,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),

                          //person sending name and time
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 18.0),
                                child: Text(
                                  dataa['users'] == null
                                      ? '${DateTime.parse(dataa['created_at']).toLocal()}'
                                          .substring(0, 16)
                                      : '${DateTime.parse(dataa['created_at']).toLocal()}'
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
                              Spacer(),
                              dataa['users'] == null
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'מערכת סקי ישראל',
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(
                                            color: Color(0xFF172B4C),
                                            fontSize: 13,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          dataa['author'] == null
                                              ? ''
                                              : '${dataa['author']}',
                                          // textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color: Color(0xFF172B4C),
                                            fontSize: 12,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      '${dataa['users']['name']}',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: Color(0xFF172B4C),
                                        fontSize: 15,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                              SizedBox(
                                width: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: dataa['users'] == null
                                    ? Container(
                                        width: 32,
                                        height: 32,
                                        decoration: ShapeDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/skis.jpg"),
                                            fit: BoxFit.cover,
                                          ),
                                          shape: OvalBorder(),
                                        ),
                                      )
                                    : Container(
                                        width: 32,
                                        height: 32,
                                        decoration: ShapeDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                "${dataa['users']['profile_image']}"),
                                            fit: BoxFit.cover,
                                          ),
                                          shape: OvalBorder(),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          //title post

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 15.0),
                                  child: Text(
                                    "${dataa['title']}",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
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
                            ],
                          ),

                          SizedBox(
                            height: 15,
                          ),

                          //tag post

                          Align(
                            alignment: Alignment.centerRight,
                            child: Wrap(
                              children: List.generate(
                                dataa['tags'].length,
                                (tagIndex) {
                                  return Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: InkWell(
                                      onTap: () {
                                        var singleTag =
                                            dataa['tags'][tagIndex]['tag'];
                                        TagCallFunction([
                                          dataa['tags'][tagIndex]['tag']
                                        ]).then((value) {
                                          PersistentNavBarNavigator
                                              .pushNewScreen(
                                            context,
                                            screen: TagScreen(
                                              tag: singleTag,
                                              tagData: tags,
                                              FeedId: widget.feedID,
                                            ),
                                            withNavBar: false,
                                            pageTransitionAnimation:
                                                PageTransitionAnimation.fade,
                                          );
                                        });
                                      },
                                      child: Container(
                                        width: 70,
                                        height: 27,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFDEF3F7),
                                        ),
                                        child: Center(
                                          child: FittedBox(
                                            fit: BoxFit.cover,
                                            child: Text(
                                              dataa['tags'][tagIndex]['tag'],
                                              style: TextStyle(
                                                color: Color(0xFF172B4C),
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          //description post

                          SingleChildScrollView(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 15.0, left: 15),
                              child: Text(
                                dataa['opinion'],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                                textScaleFactor: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                maxLines: 200,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: 390,
                            height: 4,
                            decoration: BoxDecoration(color: Color(0xFFEFF3F9)),
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          //bottom video text

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Text(
                                  'סרטון תחתון',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Color(0xFF172B4C),
                                    fontSize: 24,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          //bottom video

                          SizedBox(
                            height: 20,
                          ),

                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 15),
                            child: Container(
                              height: 200,
                              width: double.infinity,
                              child: dataa['bottom_video'] != null
                                  ? VideoPlayerWidget(dataa['bottom_video']!)
                                  : Visibility(
                                      visible: dataa['bottom_video'] == null,
                                      child: Center(
                                        child:
                                            Text("The video is not available"),
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      );
                    }),

                //text after detail

                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //go to comment page

                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentPage(
                                feedId: widget.feedID,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'הוסף תגובה',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0xFF172B4C),
                            fontSize: 19,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),

                    Spacer(),

                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Text(
                        'תגובות',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xFF172B4C),
                          fontSize: 24,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    padding: EdgeInsets.only(bottom: 15),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${DateTime.parse(data[index]['created_at']).toLocal()}'
                                          .substring(0, 11),
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: Color(0xFF73787F),
                                        fontSize: 12,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Spacer(),
                                    //user name

                                    Text(
                                      data[index]['user'] == null
                                          ? "Admin"
                                          : '${data[index]['user']['name']}',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: Color(0xFF172B4C),
                                        fontSize: 16,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    data[index]['user'] == null
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15.0),
                                            child: Container(
                                              width: 32,
                                              height: 32,
                                              decoration: ShapeDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      "assets/images/skis.jpg"),
                                                  fit: BoxFit.cover,
                                                ),
                                                shape: OvalBorder(),
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15.0),
                                            child: Container(
                                              width: 32,
                                              height: 32,
                                              decoration: ShapeDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      "${data[index]['user']['profile_image']}"),
                                                  fit: BoxFit.cover,
                                                ),
                                                shape: OvalBorder(),
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ),

                              Container(
                                // color: Colors.grey.withOpacity(0.2),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 15.0,
                                      left: 15,
                                      top: 10,
                                      bottom: 5),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '${data[index]['text']}',
                                      style: TextStyle(
                                        color: Color(0xFF44474C),
                                        fontSize: 14,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      // textDirection: TextDirection.rtl,
                                      textScaleFactor: 1,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 4,
                                      softWrap: false,
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 3,
                              ),
                              //like , and reply of comment

                              Container(
                                width: 358,
                                height: 32,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          data[index]['user']['id'] ==
                                                  int.parse(id!)
                                              ? Center(
                                                  child: InkWell(
                                                    onTap: () {
                                                      _deleteComment(
                                                          data[index]['id']);
                                                    },
                                                    child: Icon(
                                                      Icons.more_vert,
                                                      size: 20,
                                                      color: Color(0xFF172B4C),
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                          Center(
                                            child: Container(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${data[index]['reply_count']}',
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      color: Color(0xFF172B4C),
                                                      fontSize: 14,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ReplyCommentPage(
                                                            commentID:
                                                                data[index]
                                                                    ['id'],
                                                            userImage:
                                                                '${data[index]['user']['profile_image']}',
                                                            userName:
                                                                '${data[index]['user']['name']}',
                                                            mainTxt:
                                                                '${data[index]['text']}',
                                                            feedId:
                                                                widget.feedID,
                                                            allComment:
                                                                data[index]
                                                                    ['reply'],
                                                            dateTime:
                                                                '${DateTime.parse(data[index]['user']['created_at']).toLocal()}'
                                                                    .substring(
                                                                        0, 16),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      width: 20,
                                                      height: 20,
                                                      child: Icon(
                                                        Icons.reply_all_rounded,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 40),
                                          Container(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                // Text(
                                                //   '${data[index]['comments_count'].toString()}',
                                                //   textAlign:
                                                //       TextAlign.right,
                                                //   style:
                                                //       const TextStyle(
                                                //     color: Color(
                                                //         0xFF172B4C),
                                                //     fontSize: 14,
                                                //     fontFamily:
                                                //         'Inter',
                                                //     fontWeight:
                                                //         FontWeight
                                                //             .w500,
                                                //   ),
                                                // ),
                                                const SizedBox(width: 8),
                                                Center(
                                                  child: InkWell(
                                                    onTap: () {
                                                      PersistentNavBarNavigator
                                                          .pushNewScreen(
                                                              context,
                                                              screen:
                                                                  CommentPage(
                                                                feedId: widget
                                                                    .feedID,
                                                              ),
                                                              withNavBar: false,
                                                              pageTransitionAnimation:
                                                                  PageTransitionAnimation
                                                                      .fade);
                                                    },
                                                    child: Container(
                                                      width: 20,
                                                      height: 20,
                                                      child: Image.asset(
                                                        'assets/icons/Comment.png',
                                                        scale: 3,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 40),
                                          Container(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '${data[index]['commentLikes_count']}',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    color: Color(0xFF172B4C),
                                                    fontSize: 14,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Center(
                                                  child: InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    onTap: () {
                                                      toggleButton(
                                                        data[index]['id'],
                                                      );
                                                    },
                                                    child: Icon(
                                                      likedComments.contains(
                                                              data[index]['id']
                                                                  .toString())
                                                          ? Icons.favorite
                                                          : Icons
                                                              .favorite_border,
                                                      size: 20,
                                                      color: likedComments
                                                              .contains(data[
                                                                          index]
                                                                      ['id']
                                                                  .toString())
                                                          ? Colors.red
                                                          : primaryColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: 3,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  // reverse: true,
                                  padding: EdgeInsets.only(bottom: 15),
                                  itemCount: data[index]['reply'].length,
                                  // physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, ind) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 18.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 15.0),
                                                child: Container(
                                                  width: 32,
                                                  height: 32,
                                                  decoration: ShapeDecoration(
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          "${data[index]['reply'][ind]['reply_by']['profile_image']}"),
                                                      fit: BoxFit.cover,
                                                    ),
                                                    shape: OvalBorder(),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                '${data[index]['reply'][ind]['reply_by']['name']}',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  color: Color(0xFF172B4C),
                                                  fontSize: 16,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                '${DateTime.parse(data[index]['reply'][ind]['created_at']).toLocal()}'
                                                    .substring(0, 11),
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  color: Color(0xFF73787F),
                                                  fontSize: 12,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            // color: Colors.grey.withOpacity(0.2),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15.0, left: 15),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  '${data[index]['reply'][ind]['text']}',
                                                  style: TextStyle(
                                                    color: Color(0xFF44474C),
                                                    fontSize: 14,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  textScaleFactor: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 7,
                                                  softWrap: false,
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ],
                      );
                    }),
              ],
            ),
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
    );
  }
}
