import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skisreal/BotttomNavigation/Models/feed_model.dart';
import 'package:skisreal/BotttomNavigation/custom_bottom_navigation_bar_screen.dart';
import '../../../Constant/color.dart';
import '../../../Constant/const.dart';
import '../../../controller/homeScreen_controller.dart';
import '../../CommentPage/CommentPage.dart';
import '../HomeScreen/detail_page.dart';
import '../HomeScreen/home_screen.dart';

class NewTagScreen extends StatefulWidget {
  List? tagData;
  List? tag;
  int? FeedId;

  NewTagScreen({Key? key, this.tagData, this.tag, this.FeedId})
      : super(key: key);

  @override
  State<NewTagScreen> createState() => _NewTagScreenState();
}

class _NewTagScreenState extends State<NewTagScreen> {
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

  //token

  String? token;
  String? id;
  List<String> likedPosts = [];
  List<dynamic> data = [];

  Future<void> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      id = prefs.getString('id');
    });
  }

  List<String> images = [];

  getImages(List img) {
    images.clear();
    for (var all in img) images.add(all['image']);
    // print('my data is $images');
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
      throw Exception('Failed to add comment');
    }
  }

  void toggleButton(int feedID) {
    final tile = widget.tagData!
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

  var controller = Get.put(HomeScreen_Controller());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      // controller.retrieveToken();
      controller.fetchFeeds();
      controller.fetchCurrentUser();
      retrieveToken().then((value) {
        fetchFeeds();
      });
      print('asdasasdassa ${widget.tag}');
    });
  }

  Future refresh() async {
    final url = Uri.parse('https://sk.jeuxtesting.com/api/tag_search');
    final http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      final List newItem = json.decode(response.body);

      setState(() {
        data = newItem.map<String>((item) {
          final number = data[0]['id'];
          return number;
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String appBarTitle = widget.tagData != null && widget.tagData!.isNotEmpty
        ? widget.tagData![0]['tags']
    [0]['tag'].toString()
        : 'כל התגים';


    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            title: Padding(
              padding: const EdgeInsets.only(top: 22.0),
              child: Text(
                '#${appBarTitle}',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
                textScaleFactor: 1.0,
              ),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: primaryColor,
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, right: 15),
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomBottomBar(
                          index: 1,
                        ),
                      ),
                    );
                  },
                  child: Center(
                    child: Image.asset(
                      'assets/icons/la.png',
                      color: Colors.white,
                      scale: 4.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: refresh,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: widget.tagData!.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [

                              //nam of sender, time and type who share the post
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 18.0),
                                    child: Text(
                                      '${DateTime.parse(widget.tagData![index]['created_at']).toLocal()}'
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
                                  widget.tagData![index]['users'] == null
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
                                        widget.tagData![index]
                                        [
                                        'author'] ==
                                            null
                                            ? ''
                                            : '${widget.tagData![index]['author'].toString()}',

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
                                    '${widget.tagData![index]['users']['name'].toString()}',
                                    // "dfds",
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      color: Color(0xFF172B4C),
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 18.0),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: primaryColor.withOpacity(0.3),
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(50.0),
                                        child: CachedNetworkImage(
                                          width: 40,
                                          height: 40,
                                          imageUrl: widget.tagData![index]
                                          ['users'] ==
                                              null
                                              ? 'assets/images/skis.jpg'
                                              : "${widget.tagData![index]['users']['profile_image'].toString()}",
                                          fit: BoxFit.cover,
                                          progressIndicatorBuilder: (context,
                                              url, downloadProgress) =>
                                              Center(
                                                child: CircularProgressIndicator(
                                                    color: primaryColor,
                                                    value:
                                                    downloadProgress.progress),
                                              ),
                                          errorWidget: (context, url, error) =>
                                              CircleAvatar(
                                                child: Image.asset(
                                                  'assets/images/skis.jpg',
                                                  height: 40,
                                                  width: 40,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                          filterQuality: FilterQuality.high,
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

                              widget.tagData![index]['images'] != null &&
                                      widget
                                          .tagData![index]['images'].isNotEmpty
                                  ? InkWell(
                                      onTap: () {
                                        PersistentNavBarNavigator.pushNewScreen(
                                            context,
                                            screen: DetailPage(
                                              currentUserId:
                                              widget.tagData![index]
                                              ['users'] ==
                                                  null
                                                  ? 0
                                                  : widget.tagData![index]
                                              ['users']['id'],
                                              feedName: widget.tagData![index]
                                              ['title'],
                                              description: widget
                                                  .tagData![index]['opinion'],
                                              location: widget.tagData![index]
                                              ['location'],
                                              feedID: widget.tagData![index]
                                              ['id'],
                                              video: widget.tagData![index]
                                              ['bottom_video'],
                                              img: (widget.tagData![index]['images'] != null &&
                                                  widget.tagData![index]['images'].isNotEmpty)
                                                  ? widget.tagData![index]['images'][0]['image']
                                                  : 'assets/images/skis.jpg', // Provide a default image path
                                            ),
                                            withNavBar: false,
                                            pageTransitionAnimation:
                                            PageTransitionAnimation.fade);
                                        },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 15.0, left: 15),
                                        child: CachedNetworkImage(
                                          width: 380,
                                          height: 230,
                                          imageUrl:
                                              '${widget.tagData![index]['images'][0]['image']}',
                                          fit: BoxFit.cover,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Center(
                                            child: CircularProgressIndicator(
                                              color: primaryColor,
                                              value: downloadProgress.progress,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
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
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        right: 18.0,
                                      ),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () {
                                          PersistentNavBarNavigator.pushNewScreen(
                                              context,
                                              screen: DetailPage(
                                                currentUserId:
                                                widget.tagData![index]
                                                ['users'] ==
                                                    null
                                                    ? 0
                                                    : widget.tagData![index]
                                                ['users']['id'],
                                                feedName: widget.tagData![index]
                                                ['title'],
                                                description: widget
                                                    .tagData![index]['opinion'],
                                                location: widget.tagData![index]
                                                ['location'],
                                                feedID: widget.tagData![index]
                                                ['id'],
                                                video: widget.tagData![index]
                                                ['bottom_video'],
                                                img: (widget.tagData![index]['images'] != null &&
                                                    widget.tagData![index]['images'].isNotEmpty)
                                                    ? widget.tagData![index]['images'][0]['image']
                                                    : 'assets/images/skis.jpg', // Provide a default image path
                                              ),
                                              withNavBar: false,
                                              pageTransitionAnimation:
                                              PageTransitionAnimation.fade);
                                        },
                                        child: Text(
                                          '${widget.tagData![index]['title']}',
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

                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 18.0, left: 15),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: (){
                                      PersistentNavBarNavigator.pushNewScreen(
                                          context,
                                          screen: DetailPage(
                                            currentUserId:
                                            widget.tagData![index]
                                            ['users'] ==
                                                null
                                                ? 0
                                                : widget.tagData![index]
                                            ['users']['id'],
                                            feedName: widget.tagData![index]
                                            ['title'],
                                            description: widget
                                                .tagData![index]['opinion'],
                                            location: widget.tagData![index]
                                            ['location'],
                                            feedID: widget.tagData![index]
                                            ['id'],
                                            video: widget.tagData![index]
                                            ['bottom_video'],
                                            img: (widget.tagData![index]['images'] != null &&
                                                widget.tagData![index]['images'].isNotEmpty)
                                                ? widget.tagData![index]['images'][0]['image']
                                                : 'assets/images/skis.jpg', // Provide a default image path
                                          ),
                                          withNavBar: false,
                                          pageTransitionAnimation:
                                          PageTransitionAnimation.fade);
                                    },
                                    child: Text(
                                      '${widget.tagData![index]['opinion']}',
                                      style: const TextStyle(
                                        color: Color(0xFF44474C),
                                        fontSize: 12,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      textDirection: TextDirection.rtl,
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
                                height: 20,
                              ),
                              widget.tagData![index][
                              'location'] ==
                                  null ? Container():
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 18.0, left: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${widget.tagData![index]['location']}',
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(
                                            color: Color(0xFF172B4C),
                                            fontSize: 13,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
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
                                height: 20,
                              ),
                              //hashtag text

                              Align(
                                alignment: Alignment.centerRight,
                                child: Wrap(
                                  children: List.generate(
                                    widget.tagData![index]['tags'].length,
                                    (tagIndex) {
                                      return Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: ShowTag(
                                          title: widget.tagData![index]['tags']
                                              [tagIndex]['tag'],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),

                              const SizedBox(
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
                                      left:
                                          BorderSide(color: Color(0xFFEFF3F9)),
                                      top: BorderSide(
                                          width: 0.50,
                                          color: Color(0xFFEFF3F9)),
                                      right:
                                          BorderSide(color: Color(0xFFEFF3F9)),
                                      bottom:
                                          BorderSide(color: Color(0xFFEFF3F9)),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15.0),
                                        child: InkWell(
                                          onTap: () async {
                                            List<String> imagePaths = [];
                                            for (var imageData in widget
                                                .tagData![index]['images']) {
                                              String imageUrl =
                                                  imageData['image'];
                                              imagePaths.add(imageUrl);
                                            }

                                            if (imagePaths.isNotEmpty) {
                                              await shareIntent(
                                                widget
                                                    .tagData![index]
                                                ["title"],
                                                // 'https://sk.jeuxtesting.com/userFeedDetails/${ widget
                                                //     .tagData![index]["id"]}',
                                                widget
                                                    .tagData![index]
                                                ["opinion"],
                                                imagePaths,);
                                            } else {
                                              print(
                                                  "No image paths available.");
                                            }
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
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${widget.tagData![index]['comments_count']}',
                                                    textAlign: TextAlign.right,
                                                    style: const TextStyle(
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
                                                      PersistentNavBarNavigator
                                                          .pushNewScreen(
                                                              context,
                                                              screen:
                                                                  CommentPage(
                                                                feedId: widget
                                                                        .tagData![
                                                                    index]['id'],
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
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 40),
                                            Container(
                                              child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '${widget.tagData![index]['like_count']}',
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xFF172B4C),
                                                        fontSize: 14,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      onTap: () {
                                                        toggleButton(
                                                          widget.tagData![index]
                                                              ['id'],
                                                        );
                                                      },
                                                      child: Icon(
                                                        likedPosts.contains(
                                                                widget.tagData![
                                                                        index]
                                                                        ['id']
                                                                    .toString())
                                                            ? Icons.favorite
                                                            : Icons
                                                                .favorite_border,
                                                        size: 20,
                                                        color: likedPosts
                                                                .contains(widget
                                                                    .tagData![
                                                                        index]
                                                                        ['id']
                                                                    .toString())
                                                            ? Colors.red
                                                            : Colors.grey,
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
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          );
                        }),
                  ),
                )
              ],
            ),
            if (isLoading)
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
      ),
    );
  }
}
