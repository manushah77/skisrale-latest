import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skisreal/BotttomNavigation/Screens/FavoriteScreen/favorite_detail_screen.dart';
import 'package:skisreal/Constant/color.dart';
import 'package:http/http.dart' as http;
import 'package:skisreal/controller/favouritScreen_controller.dart';

import '../../../Constant/const.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  //token
  final GlobalKey<_FavoriteScreenState> favoriteScreenKey =
      GlobalKey<_FavoriteScreenState>();

  String? token;

  Future<void> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      // id = prefs.getString('id');
      print("this is token $token");
      // print("this is id $id");
    });
    // print('asdadasda $token');
  }

  //fetch favorite api

  Future<List<dynamic>> fetchSites() async {
    final response = await http
        .get(Uri.parse(Consts.BASE_URL + '/api/get_favourite_site'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final data = jsonBody['data'] as List<dynamic>;

      return data;
    } else {
      throw Exception('Failed to fetch sites');
    }
  }

  late Stream<List<dynamic>> stream = Stream.periodic(Duration(seconds: 5))
      .asyncMap((event) async => await fetchSites());
  var controller = Get.put(FavouritScreen_Controller());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // retrieveToken();
    // fetchSites();

    setState(() {
      controller.getfavouritSite();
    });
    retrieveToken().then((value) {
      refresh();
    });
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

  Future refresh() async {
    // fetchFeeds();
    await controller.getfavouritSite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          actions:[
            Padding(
              padding: const EdgeInsets.only(top: 22.0,right: 20),
              child: Text(
                'המועדפים שלי',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
          automaticallyImplyLeading: false,
          backgroundColor: primaryColor,
        ),
      ),
      body: Obx(() => controller.isLoading.value == true
          ? Center(
              child: Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              ),
            )
          : controller.data.isEmpty
              ? RefreshIndicator(
                  color: primaryColor,
                  onRefresh:   refresh,
                  child: ListView(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 300,
                          ),
                          Text('אין אתר מועדף זמין'),
                        ],
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        color: primaryColor,
                        onRefresh: refresh,
                        child: GridView.builder(
                          // physics: ScrollPhysics(),
                          itemCount: controller.data.length,
                          // shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.79 / 1,
                          ),
                          itemBuilder: (BuildContext ctx, indexx) {
                            // Your existing item builder code
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 10),
                              child: InkWell(
                                onTap: () {
                                  PersistentNavBarNavigator.pushNewScreen(
                                      context,
                                      screen: FavoriteScreenDetail(
                                        timing: timing,
                                        image: images,
                                        title:
                                            '${controller.data.value[indexx]['sites']['title']}',
                                        siteName:
                                            '${controller.data.value[indexx]['sites']['website']}',
                                        skitrack:
                                            '${controller.data.value[indexx]['sites']['track']}',
                                        skiSlop:
                                            '${controller.data.value[indexx]['sites']['ski_slops']}',
                                        skilift:
                                            '${controller.data.value[indexx]['sites']['ski_lift']}',
                                        location:
                                            '${controller.data.value[indexx]['sites']['location']}',
                                        description:
                                            '${controller.data.value[indexx]['sites']['description']}',
                                        phone:
                                            '${controller.data.value[indexx]['sites']['phone_number']}',
                                        rate:
                                            '${controller.data.value[indexx]['sites']['rate']}',
                                        siteId: controller.data.value[indexx]
                                            ['sites']['id'],
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
                                              "${controller.data.value[indexx]['sites']['images'][0]['image'].toString()}",
                                          fit: BoxFit.cover,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        color: primaryColor,
                                                        value: downloadProgress
                                                            .progress),
                                              ),
                                          errorWidget: (context, url, error) =>
                                              Center(
                                                child: Image.asset(
                                                  'assets/images/skis.jpg',
                                                ),
                                              )),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${controller.data.value[indexx]['sites']['title']}',
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${controller.data.value[indexx]['sites']['location']}',
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
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                )),
    );
  }
}
