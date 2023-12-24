import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skisreal/BotttomNavigation/Models/search_class.dart';
import 'package:skisreal/BotttomNavigation/Screens/SearchScreen/NewTagScreen.dart';
import 'package:skisreal/Constant/const.dart';
import 'package:skisreal/controller/searchScreen_Controller.dart';

import '../../../Constant/color.dart';
import '../../../controller/homeScreen_controller.dart';
import '../../../controller/searchTag_controller.dart';
import '../../../service/service.dart';
import '../FavoriteScreen/favorite_detail_screen.dart';
import '../HomeScreen/detail_page.dart';
import '../HomeScreen/tag_screen.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isSearching = false;

  String? token;

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

  Future<void> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      print('My fetch token is $token');
    });
  }

  String text = '';

  List<dynamic> data = [];
  List<dynamic> searchResults = [];

  Future<List<dynamic>> fetchSites() async {
    final response = await http
        .get(Uri.parse(Consts.BASE_URL + '/api/get_all_site'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      setState(() {
        data = jsonBody['data'] as List<dynamic>;
        searchResults = data; // Initialize search results with all data
      });
      getImage(data[0]['images']);
      getTiming(data[0]['timeing']);

      return data;
    } else {
      throw Exception('Failed to fetch sites');
    }
  }

  List<String> tags = [];
  List? selectedTag;
  Future<List<dynamic>> tagCallFunction(List selectedTags) async {
    try {
      setState(() {
        loader = true;
        selectedTag = selectedTags;

      });

      Map data = {"tages": selectedTag};
      final value = await UserService().postApiwithToken(
        "api/tag_search",
        data,
        controller.token.value.toString(),
      );

      if (value["status"] == "success") {
        List<dynamic> feedsList = value['feed'];
        tags.clear();
        return feedsList;
      } else {
        // Handle the error case here, e.g., show an error message
        print("API call failed: ${value['message']}");
        return [];
      }
    } finally {
      setState(() {
        loader = false;
      });
    }
  }

  Future refresh() async {
    // fetchFeeds();
    controllerTag.searchTag();
    // setState(() {
    //   // Fluttertoast.showToast(msg: 'Your data is uptodate ...!');
    // });
  }

  Future refreshsearch() async {
    // fetchFeeds();
    controller.fetchSite();
    // setState(() {
    //   // Fluttertoast.showToast(msg: 'Your data is uptodate ...!');
    // });
  }

  final myFocusNode = FocusNode();
  var controller = Get.put(SearchScreen_Controller());
  var controllerTag = Get.put(SearchTag_Controller());

  var controllertwo = Get.put(HomeScreen_Controller());

  // List<String> tagArray = [];

  tagArrayFunction() {
    for (var all in controllerTag.data) {
      print('asdasdasdas');
      print(all['tagss']);
      // tagArray == all['tag'];
      // setState(() {
      // });
    }
  }

  void search(String keyword) {
    setState(() {
      controller.data.value = controller.searchData.value.where((item) {
        final title = item['title'].toString().toLowerCase();
        final location = item['location'].toString().toLowerCase();
        return title.contains(keyword.toLowerCase()) || location.contains(keyword.toLowerCase());
      }).toList();
    });
  }

  // List<dynamic> filteredData = []; // Initialize as an empty list
  //

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // retrieveToken().then((value) {
    //   fetchSites();
    //   myFocusNode.unfocus();
    // });
    tagArrayFunction();
    // setState(() {
    //
    // });
    controller.fetchSite();
    controllerTag.searchTag();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    myFocusNode.dispose();
    super.dispose();
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
                'חיפוש',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          automaticallyImplyLeading: false,
          backgroundColor: primaryColor,
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 25,
              ),
              //search text field
              Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 18),
                child: SizedBox(
                  width: 350,
                  height: 60,
                  child: TextFormField(
                    cursorColor: primaryColor,
                    // Update with your primaryColor
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: primaryColor, // Update with your primaryColor
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                    onChanged: (val) {
                      search(val);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please search';
                      }
                      return null;
                    },
                    focusNode: myFocusNode,

                    decoration: InputDecoration(
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(right: 7.0, left: 8),
                        child: InkWell(
                          onTap: () {
                            tagsSheetModel();
                          },
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xffDBDBDB),
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/icons/filter.png',
                                scale: 1.7,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // suffixIcon: IconButton(
                      //   onPressed: () {},
                      //   icon: Image.asset(
                      //     'assets/icons/srch.png',
                      //     scale: 4,
                      //   ),
                      // ),
                      // suffixIconColor: Colors.black12,
                      contentPadding: EdgeInsets.only(
                          top: 10, left: 18, right: 18, bottom: 10),
                      border: InputBorder.none,
                      hintText: 'חיפוש',
                      hintTextDirection: TextDirection.rtl,
                      hintStyle: TextStyle(
                        color: primaryColor.withOpacity(0.5),
                        // Update with your primaryColor
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
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
                          color: primaryColor, // Update with your primaryColor
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              //tag search

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0, left: 15),
                    child: Text(
                      'אתרי סקי',
                      // textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Color(0xFF172B4C),
                        fontSize: 22,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                      textScaleFactor: 1.0,
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 10,
              ),
              Obx(
                () => controller.isLoading.value == true
                    ? Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : controller.data.isEmpty
                        ? Center(child: Text('אין נתונים זמינים'))
                        : Expanded(
                            child: RefreshIndicator(
                              onRefresh: refreshsearch,
                              color: primaryColor,
                              child: ListView.builder(
                                  // reverse: true,
                                  itemCount: controller.data.length,
                                  itemBuilder: (
                                    context,
                                    index,
                                  ) {
                                    return InkWell(
                                      onTap: () {
                                        PersistentNavBarNavigator.pushNewScreen(
                                            context,
                                            screen: FavoriteScreenDetail(
                                              timing: timing,
                                              image: images,
                                              title:
                                                  '${controller.data.value[index]['title']}',
                                              siteName:
                                                  '${controller.data.value[index]['website']}',
                                              skitrack:
                                                  '${controller.data.value[index]['track']}',
                                              skiSlop:
                                                  '${controller.data.value[index]['ski_slops']}',
                                              skilift:
                                                  '${controller.data.value[index]['ski_lift']}',
                                              location:
                                                  '${controller.data.value[index]['location']}',
                                              description:
                                                  '${controller.data.value[index]['description']}',
                                              phone:
                                                  '${controller.data.value[index]['phone_number']}',
                                              rate:
                                                  '${controller.data.value[index]['rate']}',
                                              siteId: controller
                                                  .data.value[index]['id'],
                                            ),
                                            withNavBar: false,
                                            pageTransitionAnimation:
                                                PageTransitionAnimation.fade);
                                      },
                                      child: ListTile(
                                        trailing: Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color:
                                                  primaryColor.withOpacity(0.3),
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                            child: CachedNetworkImage(
                                              width: 50,
                                              height: 50,
                                              imageUrl:
                                                  "${controller.data[index]['images'][0]['image']}",
                                              fit: BoxFit.cover,
                                              progressIndicatorBuilder:
                                                  (context, url,
                                                          downloadProgress) =>
                                                      Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        color: primaryColor,
                                                        value: downloadProgress
                                                            .progress),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      CircleAvatar(
                                                child: Image.asset(
                                                  'assets/images/skis.jpg',
                                                  height: 50,
                                                  width: 50,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              filterQuality: FilterQuality.high,
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          '${controller.data.value[index]['title']}',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color: Color(0xFF172B4C),
                                            fontSize: 16,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        subtitle: Text(
                                          '${controller.data.value[index]['location']}',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color: Color(0xFF72777F),
                                            fontSize: 12,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        leading: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
              ),
            ],
          ),
          if (loader)
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

  bool loader = false;

  //tag bottom model

  TextEditingController searchController = TextEditingController();

  void searchTags(String keywords) {
    setState(() {
      controllerTag.data.value = controllerTag.searchData.where((items) {
        final tagData = items['tags'].toString().toLowerCase();
        return tagData.contains(keywords.toLowerCase());
      }).toList();
    });
  }

  void tagsSheetModel() async {
    // await Future.delayed(Duration(seconds: 2)); // Adding a delay of 2 seconds

    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: 500,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0, left: 18),
                  child: SizedBox(
                    width: 350,
                    height: 60,
                    child: TextFormField(
                      cursorColor: primaryColor,
                      // Update with your primaryColor
                      // textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: primaryColor, // Update with your primaryColor
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                      onChanged: (val) {
                        searchTags(val);
                      },

                      // controller: searchController,
                      decoration: InputDecoration(
                        // prefixIcon: IconButton(
                        //   onPressed: () {
                        //     searchController.clear();
                        //     refresh().then((value)  {
                        //       Fluttertoast.showToast(msg: 'Your data is updated ...!');
                        //
                        //     });
                        //   },
                        //   icon: Icon(Icons.cancel,color: primaryColor,),
                        // ),
                        suffixIcon: Image.asset(
                          'assets/icons/srch.png',
                          scale: 4,
                        ),
                        suffixIconColor: Colors.black12,
                        contentPadding: EdgeInsets.only(
                            top: 10, left: 18, right: 18, bottom: 10),
                        border: InputBorder.none,
                        hintText: 'חיפוש תגים',
                        hintTextDirection: TextDirection.rtl,
                        hintStyle: TextStyle(
                          color: primaryColor.withOpacity(0.5),
                          // Update with your primaryColor
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
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
                            color:
                                primaryColor, // Update with your primaryColor
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'כל התגים',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: primaryColor,
                        ),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          tagCallFunction(tags).then((value) {
                            print('asdadasas adasd ad $value');
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: NewTagScreen(
                                tag: selectedTag,
                                tagData:
                                    value, // Use the fetched and filtered data
                              ),
                              withNavBar: false,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.fade,
                            );
                          });
                        },
                        child: Container(
                          height: 35,
                          width: 100,
                          decoration: ShapeDecoration(
                            color: Color(0xFF00B3D7),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                          ),
                          child: Center(
                            child: Text(
                              'חפש',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: refresh,
                    child: ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        // Create a Set to store unique tags
                        Set<String> uniqueTags = Set<String>();

                        // Iterate through controllerTag.data to filter duplicates
                        for (var tagData in controllerTag.data) {
                          uniqueTags
                              .add(tagData['tags'].toString().toLowerCase());
                        }

                        // Convert the unique tags back to a list
                        List<String> uniqueTagsList = uniqueTags.toList();


                        return Wrap(
                          children:
                              List.generate(uniqueTagsList.length, (indexx) {
                            return PickChip(
                              title: uniqueTagsList[indexx],
                              selectedValues: tags,
                            );
                          }),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        });
  }
}

// List<String> selectedValues = [];

class PickChip extends StatefulWidget {
  String? title;
  List<dynamic>? selectedValues;

  PickChip({Key? key, this.title, this.selectedValues}) : super(key: key);

  @override
  State<PickChip> createState() => _PickChipState();
}

class _PickChipState extends State<PickChip> {
  List list = [];
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, top: 4),
      child: ChoiceChip(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        // padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10 ),
        label: Text(
          '${widget.title}',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: _isSelected == true ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: Color(0xFFDEF3F7),
        elevation: 0,
        selected: _isSelected,
        onSelected: (isSelected) {
          setState(() {
            _isSelected = isSelected;
            if (isSelected) {
              widget.selectedValues!.add(widget.title!);
            } else {
              widget.selectedValues!.remove(widget.title);
            }
          });
        },
        selectedColor: primaryColor.withOpacity(0.8),
      ),
    );
  }
}
