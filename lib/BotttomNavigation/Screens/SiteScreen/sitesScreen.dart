import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:skisreal/Constant/const.dart';
import '../../../Constant/color.dart';
import '../FavoriteScreen/favorite_detail_screen.dart';

class SitesScreen extends StatefulWidget {
  const SitesScreen({Key? key}) : super(key: key);

  @override
  State<SitesScreen> createState() => _SitesScreenState();
}

class _SitesScreenState extends State<SitesScreen> {

  //token

  String? token;

  void retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      print('My fetch token is $token');
    });
  }

  //fetch tags
  List<dynamic> dataa = [];

  Future<List<dynamic>> fetchSites() async {
    final response = await http
        .get(Uri.parse(Consts.BASE_URL + '/api/get_all_site'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      dataa = jsonBody['data'] as List<dynamic>;
      getImage(dataa[0]['images']);
      getTiming(dataa[0]['timeing']);

      return dataa;
    } else {
      throw Exception('Failed to fetch sites');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveToken();
    fetchSites();
  }

  List<String> images = [];
  List<String> timing = [];

  //get images
  getImage(List img) {
    images.clear();
    for (var all in img) images.add(all['image']);
    // print('my data is $images');
  }

  // get timing
  getTiming(List time) {
    timing.clear();
    for (var all in time) timing.add(all['timing']);
    // print('my data is $images');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              'כל האתרים',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
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
              height: 20,
            ),
            FutureBuilder<List<dynamic>>(
                future: fetchSites(),
                builder: (context, AsyncSnapshot sp) {
                  if (!sp.hasData) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: primaryColor,
                    ));
                  }
                  final List data = sp.data;

                  return GridView.builder(
                      physics: ScrollPhysics(),
                      itemCount: data.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.79 / 1,
                      ),
                      itemBuilder: (BuildContext ctx, indexx) {
                        // print('data is in asda asda ${data[0]['images']}');

                        return Padding(
                          padding: const EdgeInsets.only(left: 15, right: 10),
                          child: InkWell(
                            onTap: () {
                              PersistentNavBarNavigator.pushNewScreen(context,
                                  screen: FavoriteScreenDetail(
                                    timing: timing,
                                    image: images,
                                    title: '${data[indexx]['title']}',
                                    siteName: '${data[indexx]['website']}',
                                    skitrack: '${data[indexx]['track']}',
                                    skiSlop: '${data[indexx]['ski_slops']}',
                                    skilift: '${data[indexx]['ski_lift']}',
                                    location: '${data[indexx]['location']}',
                                    description:
                                        '${data[indexx]['description']}',
                                    phone: '${data[indexx]['phone_number']}',
                                    rate: '${data[indexx]['rate']}',
                                    siteId: data[indexx]['id'],
                                  ),
                                  withNavBar: false,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.fade);
                            },
                            child: Container(
                              width: 173,
                              height: 210,
                              child: Column(
                                children: [
                                  CachedNetworkImage(
                                    width: 173,
                                    height: 160,
                                    imageUrl:
                                        "${data[indexx]['images'][0]['image']}",
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Center(
                                      child: CircularProgressIndicator(
                                          color: primaryColor,
                                          value: downloadProgress.progress),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Center(
                                      child: CircularProgressIndicator(
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${data[indexx]['title']}',
                                          style: TextStyle(
                                            color: Color(0xFF172B4C),
                                            fontSize: 15,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                          ),
                                          // textDirection: TextDirection.rtl,
                                          textScaleFactor: 1.0,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${data[indexx]['location']}',
                                        style: TextStyle(
                                          color: Color(0xFF72777F),
                                          fontSize: 11,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                        ),
                                        // textDirection: TextDirection.rtl,
                                        textScaleFactor: 1.0,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                }),
          ],
        ),
      ),
    );
  }
}
