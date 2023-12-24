import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skisreal/BotttomNavigation/CommentPage/reply_comment_page.dart';
import 'package:skisreal/BotttomNavigation/Models/commentModel.dart';
import 'package:skisreal/BotttomNavigation/custom_bottom_navigation_bar_screen.dart';
import 'package:skisreal/Constant/const.dart';

import '../../Constant/color.dart';
import 'package:http/http.dart' as http;

import '../../Constant/dialoag_widget.dart';

class CommentPage extends StatefulWidget {
  int? feedId;

  CommentPage({this.feedId, Key? key}) : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  String? token;
  String? id;

  bool isLike = false;
  List<String> likedComments = [];
  List<dynamic> data = [];

  Future<void> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      id = prefs.getString('id');
    });
    print(token);
  }

  //add comment

  bool isUpload = false;

  Future addComment(int feedID, String txt) async {
    try {
      setState(() {
        isUpload = true;
      });
      final response = await http.post(
        Uri.parse(Consts.BASE_URL + '/api/comment'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'feed_id': feedID,
          'text': txt,
        }),
      );
      setState(() {
        isUpload = true;
      });
      if (response.statusCode == 200) {
        // setState(() {
        //   isUpload = true;
        // });
        final jsonBody = json.decode(response.body);
        final data = jsonBody['data'];
        setState(() {
          isUpload = false;
        });
        return data;
      } else {
        setState(() {
          isUpload = false;
        });
        // throw Exception('Please add comment');
        CustomDialogs.showSnakcbar(context, 'Please add comment');

      }
    } catch (e) {
      setState(() {
        isUpload = false;
      });
      CustomDialogs.showSnakcbar(context, 'Error $e');
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

  Future getComment() async {
    final response = await http.get(
        Uri.parse(Consts.BASE_URL + '/api/get_all_comment/${widget.feedId}'),
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
        print(data);
      });
    } else {
      throw Exception('Failed to fetch comment');
    }
  }

  TextEditingController msg = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveToken().then((value) {
      getComment();
    });
    print(widget.feedId!);
  }

  Future refresh() async {
    getComment();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarIconBrightness: Brightness.dark,
              systemNavigationBarDividerColor: null,
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.light,
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 22.0),
              child: Text(
                'תגובה',
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
                    Get.offAll(() => CustomBottomBar(index: 3,));
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
        body: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            data.isEmpty ?
            Expanded(
              child: Center(
                child: Text('אין תגובה זמינה'),
              ),
            )
                :
            Expanded(
              child: RefreshIndicator(
                onRefresh: refresh,
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
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
                                    mainAxisAlignment: MainAxisAlignment.end,
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
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05,
                                            ),
                                            Text(
                                              '${data[index]['reply_count']}',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Color(0xFF172B4C),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
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
                                                      commentID: data[index]
                                                          ['id'],
                                                      userImage:
                                                          '${data[index]['user']['profile_image']}',
                                                      userName:
                                                          '${data[index]['user']['name']}',
                                                      mainTxt:
                                                          '${data[index]['text']}',
                                                      feedId: widget.feedId,
                                                      allComment: data[index]
                                                          ['reply'],
                                                      dateTime:
                                                          '${DateTime.parse(data[index]['user']['created_at']).toLocal()}'
                                                              .substring(0, 11),
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
                                            const SizedBox(width: 8),
                                            Center(
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                hoverColor: Colors.transparent,
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
                                                      : Icons.favorite_border,
                                                  size: 20,
                                                  color: likedComments.contains(
                                                          data[index]['id']
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
              ),
            ),
            chatInput(),
          ],
        ),
      ),
    );
  }

  Widget chatInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Scrollbar(
                    controller: _scrollController,
                    child: Container(
                      constraints: BoxConstraints(maxHeight: 100),
                      child: TextFormField(
                        scrollController: _scrollController,
                        cursorColor: primaryColor,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: primaryColor,
                        ),
                        controller: msg,
                        onTap: () {},
                        maxLines: null,
                        //grow automatically
                        keyboardType: TextInputType.multiline,
                        cursorHeight: 17,
                        decoration: InputDecoration(
                          suffixIconColor: Colors.grey.withOpacity(0.4),
                          contentPadding:
                              EdgeInsets.only(top: 10, left: 16, right: 16),
                          border: InputBorder.none,
                          hintText: 'Post your comment',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black26,
                          ),
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.1),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: primaryColor.withOpacity(0.2),
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: primaryColor.withOpacity(0.2),
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          isUpload == true
              ? Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                )
              : MaterialButton(
                  minWidth: 43,
                  height: 43,
                  color: primaryColor,
                  shape: CircleBorder(),
                  onPressed: () {
                    addComment(widget.feedId!, msg.text.toString())
                        .then((value) {
                      msg.clear();
                      retrieveToken().then((value) {
                        getComment();
                      });
                    });
                  },
                  child: Center(
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
        ],
      ),
    );
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
}
