import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skisreal/BotttomNavigation/CommentPage/comment_card.dart';
import 'package:skisreal/Constant/const.dart';
import 'package:skisreal/Constant/dialoag_widget.dart';

import '../../Constant/color.dart';
import 'package:http/http.dart' as http;

class ReplyCommentPage extends StatefulWidget {
  int? commentID;
  String? mainTxt;
  String? userName;
  String? userImage;
  int? feedId;
  List? allComment = [];
  String? dateTime;

  ReplyCommentPage(
      {this.commentID,
      this.mainTxt,
      this.allComment,
      this.userImage,
      this.userName,
      this.feedId,
      this.dateTime,
      Key? key})
      : super(key: key);

  @override
  State<ReplyCommentPage> createState() => _ReplyCommentPageState();
}

class _ReplyCommentPageState extends State<ReplyCommentPage> {
  String? token;
  bool isLike = false;

  void retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
  }

  bool isUpload = false;

  Future<List<dynamic>> getComment() async {
    final response = await http.get(
        Uri.parse(Consts.BASE_URL + '/api/comment_detail/${widget.commentID}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final data = jsonBody['Comment']['reply'];
      // print('asdadasda $jsonBody');

      return data;
    } else {
      throw Exception('Failed to fetch reply comment');
    }
  }

  //stream builder get data from apis
  late Stream<List<dynamic>> stream = Stream.periodic(Duration(seconds: 2))
      .asyncMap((event) async => await getComment());

  Future addReplyComment(int feedID, String txt) async {
    try {
      setState(() {
        isUpload = true;
      });
      final response = await http.post(
        Uri.parse(Consts.BASE_URL + '/api/reply_comment'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'comment_id': feedID,
          'text': txt,
        }),
      );
      setState(() {
        isUpload = true;
      });
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        final data = jsonBody['data'];
        // print(data);
        setState(() {
          isUpload = false;
        });
        return data;
      } else {
        setState(() {
          isUpload = false;
        });
        throw Exception('Failed to add reply comment');
      }
    } catch (e) {
      setState(() {
        isUpload = false;
      });
      CustomDialogs.showSnakcbar(context, 'Error $e');
    }
  }

  TextEditingController msg = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveToken();
    getComment();
    // addReplyComment(widget.commentID!, msg.text.toString());
    // print(widget.commentID!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              'Reply Comment',
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
                  Navigator.pop(context);
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
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      '${widget.dateTime}',
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
                  Text(
                    '${widget.userName}',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Color(0xFF172B4C),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: NetworkImage("${widget.userImage}"),
                          fit: BoxFit.cover,
                        ),
                        shape: OvalBorder(),
                      ),
                    ),
                  ),
                ],
              ),

              Container(
                // color: Colors.grey.withOpacity(0.2),
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 15.0, left: 15, top: 10, bottom: 5),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${widget.mainTxt}',
                      style: TextStyle(
                        color: Color(0xFF44474C),
                        fontSize: 16,
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

              SizedBox(
                height: 3,
              ),
              //like , and reply of comment

              // Container(
              //   width: 358,
              //   height: 32,
              //   decoration: BoxDecoration(
              //     border: Border.all(
              //       color: Colors.grey.withOpacity(0.3),
              //     ),
              //   ),
              //   child: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       Container(
              //         padding: const EdgeInsets.only(right: 8),
              //         child: Row(
              //           mainAxisSize: MainAxisSize.min,
              //           mainAxisAlignment: MainAxisAlignment.end,
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             const SizedBox(width: 40),
              //             Container(
              //               child: Row(
              //                 mainAxisSize: MainAxisSize.min,
              //                 mainAxisAlignment: MainAxisAlignment.start,
              //                 crossAxisAlignment: CrossAxisAlignment.center,
              //                 children: [
              //                   Text(
              //                     '100',
              //                     textAlign: TextAlign.right,
              //                     style: TextStyle(
              //                       color: Color(0xFF172B4C),
              //                       fontSize: 14,
              //                       fontFamily: 'Inter',
              //                       fontWeight: FontWeight.w500,
              //                     ),
              //                   ),
              //                   const SizedBox(width: 8),
              //                   InkWell(
              //                     onTap: (){
              //                       setState(() {
              //                         isLike = true;
              //                       });
              //
              //                     },
              //                     child: Icon(
              //                       isLike == true ? Icons.favorite :
              //                       Icons.favorite_border,
              //                       size: 20,
              //                       color:  isLike == true ? Colors.red : Colors.grey,
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              SizedBox(
                height: 3,
              ),
            ],
          ),
          StreamBuilder<List<dynamic>>(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List? data = snapshot.data;
                  return Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        // reverse: true,
                        itemCount: data!.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 15.0),
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        decoration: ShapeDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                "${data[index]['reply_by']['profile_image']}"),
                                            fit: BoxFit.cover,
                                          ),
                                          shape: OvalBorder(),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${data[index]['reply_by']['name']}',
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
                                        '${data[index]['text']}',
                                        style: TextStyle(
                                          color: Color(0xFF44474C),
                                          fontSize: 14,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                        ),
                                        textDirection: TextDirection.rtl,
                                        textScaleFactor: 1,
                                        overflow: TextOverflow.ellipsis,
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
                                //like , and reply of comment

                                // Container(
                                //   width: 358,
                                //   height: 32,
                                //   decoration: BoxDecoration(
                                //     border: Border.all(
                                //       color: Colors.grey.withOpacity(0.3),
                                //     ),
                                //   ),
                                //   child: Row(
                                //     mainAxisSize: MainAxisSize.min,
                                //     mainAxisAlignment: MainAxisAlignment.end,
                                //     crossAxisAlignment: CrossAxisAlignment.center,
                                //     children: [
                                //       Container(
                                //         padding: const EdgeInsets.only(right: 8),
                                //         child: Row(
                                //           mainAxisSize: MainAxisSize.min,
                                //           mainAxisAlignment:
                                //               MainAxisAlignment.end,
                                //           crossAxisAlignment:
                                //               CrossAxisAlignment.start,
                                //           children: [
                                //             const SizedBox(width: 40),
                                //             Container(
                                //               child: Row(
                                //                 mainAxisSize: MainAxisSize.min,
                                //                 mainAxisAlignment:
                                //                     MainAxisAlignment.start,
                                //                 crossAxisAlignment:
                                //                     CrossAxisAlignment.center,
                                //                 children: [
                                //                   Text(
                                //                     '100',
                                //                     textAlign: TextAlign.right,
                                //                     style: TextStyle(
                                //                       color: Color(0xFF172B4C),
                                //                       fontSize: 14,
                                //                       fontFamily: 'Inter',
                                //                       fontWeight: FontWeight.w500,
                                //                     ),
                                //                   ),
                                //                   const SizedBox(width: 8),
                                //                   InkWell(
                                //                     onTap: () {
                                //                       setState(() {
                                //                         isLike = true;
                                //                       });
                                //                     },
                                //                     child: Icon(
                                //                       isLike == true
                                //                           ? Icons.favorite
                                //                           : Icons.favorite_border,
                                //                       size: 20,
                                //                       color: isLike == true
                                //                           ? Colors.red
                                //                           : Colors.grey,
                                //                     ),
                                //                   ),
                                //                 ],
                                //               ),
                                //             ),
                                //           ],
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),

                                SizedBox(
                                  height: 3,
                                ),
                              ],
                            ),
                          );
                        }),
                  ));
                }
                return Expanded(
                  child: Center(
                      child: CircularProgressIndicator(
                    color: primaryColor,
                  )),
                );
              }),
          chatInput(),
        ],
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
                          hintText: 'Reply comment',
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
                    addReplyComment(widget.commentID!, msg.text.toString())
                        .then((value) {
                      msg.clear();
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
}
