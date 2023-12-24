import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skisreal/BotttomNavigation/Screens/FavoriteScreen/barchat.dart';
import 'package:skisreal/BotttomNavigation/Screens/FavoriteScreen/image_zoom_screen.dart';
import 'package:skisreal/BotttomNavigation/Screens/FavoriteScreen/map_check.dart';
import 'package:skisreal/Constant/dialoag_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../Constant/color.dart';
import '../../../Constant/const.dart';
import '../../Models/weather_model.dart';
import 'package:collection/collection.dart';

class FavoriteScreenDetail extends StatefulWidget {
  String? title;
  String? phone;
  String? location;
  String? siteName;
  String? skilift;
  String? skitrack;
  String? skiSlop;
  String? description;
  String? rate;
  List<String>? image;
  List<String>? timing;
  int? siteId;

  FavoriteScreenDetail({
    this.image,
    this.siteId,
    this.siteName,
    this.location,
    this.description,
    this.title,
    this.phone,
    this.rate,
    this.skilift,
    this.skiSlop,
    this.skitrack,
    this.timing,
  });

  @override
  State<FavoriteScreenDetail> createState() => _FavoriteScreenDetailState();
}

class _FavoriteScreenDetailState extends State<FavoriteScreenDetail> {
  final PageController controller = PageController();
  bool isFavorite = false;
  String selectedTime = 'AM'; // Default selection

  String? token;
  Color iconColor = Colors.white;
  String? id;
  double latitude = 0.0;
  double longitude = 0.0;

  Future<void> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      id = prefs.getString('id');
    });
    // print('asdadasda $token');
  }

  Future addFavorite(int siteID, status) async {
    final response = await http.post(
      Uri.parse('https://skisrael.co.il/api/add_favourite_site'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'site_id': siteID,
        'status': status,
      }),
    );

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      print(jsonBody);
      setState(() {});
      return jsonBody;
    } else {
      throw Exception('Failed to add favorite');
    }
  }

  List data = [];

  Future<List<dynamic>> fetchFavoriteSites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });

    final response = await http
        .get(Uri.parse(Consts.BASE_URL + '/api/get_favourite_site'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      data = jsonBody['data'] as List<dynamic>;

      var favSite =
          data.where((element) => element['user_id'].toString() == id).toList();
      var isFav = favSite.firstWhereOrNull((element) =>
          (element['site_id'] == widget.siteId && element['status'] == '1'));
      if (isFav != null) {
        setState(() {
          isFavorite = true;
          iconColor = Colors.green;
        });
      } else {
        setState(() {
          isFavorite = false;
          iconColor = Colors.white;
        });
      }

      return data;
    } else {
      throw Exception('Failed to fetch ');
    }
  }

  Future fetchSitedetail(int siteId) async {
    final response = await http.post(
      Uri.parse(Consts.BASE_URL + '/api/site_detail'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'site_id': siteId}),
    );
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final data = jsonBody['data'];
      return data;
    } else {
      throw Exception('Failed to site detail');
    }
  }

  void toggleButton(int siteID) {
    if (isFavorite) {
      setState(() {
        isFavorite = false;
        iconColor = Colors.white;
      });

      addFavorite(siteID, 0);
    } else {
      setState(() {
        isFavorite = true;
        iconColor = Colors.green;
      });
      addFavorite(siteID, 1);
    }
  }

  bool isLoading = false;

  Future addRating(int siteID, userID, rating) async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await http.post(
        Uri.parse(Consts.BASE_URL + '/api/addRatting'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'siteId': siteID,
          'userId': userID,
          'rating': rating,
        }),
      );
      setState(() {
        isLoading = true;
      });
      if (response.statusCode == 200) {
        // setState(() {
        //   isUpload = true;
        // });
        final jsonBody = json.decode(response.body);
        final data = jsonBody['data'];
        setState(() {
          isLoading = false;
        });
        return data;
      } else {
        setState(() {
          isLoading = false;
        });
        // throw Exception('Please add comment');
        CustomDialogs.showSnakcbar(context, 'Please give rating');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      CustomDialogs.showSnakcbar(context, 'Error $e');
    }
  }

  Future refresh() async {
    // fetchFeeds();
    await fetchSitedetail(widget.siteId!);
    setState(() {});
  }

  String convertTimestampToTimeString(int timestamp) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var formattedTime = '${dateTime.hour}:${dateTime.minute}';
    return formattedTime;
  }

  WeatherModel? weather_model;

  String? temp;
  String? presure;
  String? hum;
  String? desc;
  String? status;
  int? sunrise;
  int? sunset;
  String? sunriseString;
  String? sunsetString;

  void fetchWeather() async {
    Uri uri = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=${widget.location}&units=metric&appid=452f3ae96ec121fccc31f1bc0c3cc9f4");
    var res = await http.get(uri);
    var decodebody = json.decode(res.body);
    // print(decodebody);
    setState(() {
      weather_model = WeatherModel.fromJson(decodebody);
      temp = '${weather_model!.temp}';
      presure = '${weather_model!.pressure}';
      hum = '${weather_model!.humidity}';
      desc = '${weather_model!.des}';
      status = '${weather_model!.weather_status}';
      sunrise = weather_model!.sunrise;
      sunset = weather_model!.sunset;

      int sunriseTimestamp = sunrise!;
      int sunsetTimestamp = sunset!;

      sunriseString = convertTimestampToTimeString(sunriseTimestamp);
      sunsetString = convertTimestampToTimeString(sunsetTimestamp);
    });
    print('asdadasd asda sd a $sunset');
  }

  @override
  void initState() {
    super.initState();
    retrieveToken().then((value) {
      fetchFavoriteSites().then((value) {
        fetchWeather();
      });
      fetchSitedetail(widget.siteId!);
      print('my id is $id');
      print('my siteId is ${widget.siteId}');
    });

    print(widget.siteId!);
    print(convertAddressToLatLng(widget.location!));
    // temp = '${weather_model!.temp}';
  }

  void launchURL(String? url) async {
    if (url != null && await canLaunchUrl(Uri.parse(url))) {
      try {
        await launchUrl(Uri.parse(url));
      } catch (e) {
        print('Error launching URL: $e');
      }
    } else {
      print('Invalid URL: $url');
    }
  }

  Future<void> convertAddressToLatLng(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      Location location = locations.first;
      setState(() {
        latitude = location.latitude;
        longitude = location.longitude;
      });
      print('Latitude: $latitude, Longitude: $longitude');
    } catch (e) {
      print('Error converting address to LatLng: $e');
    }
  }

  int selectedStars = 0; // Initialize with the default rating

  //fetch snow api
  void fetchWeatherSnowApi() async {
    // String cityValue = 'sahiwal';

    Uri uri = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=${widget.location}&units=metric&appid=452f3ae96ec121fccc31f1bc0c3cc9f4");
    var res = await http.get(uri);
    var decodebody = json.decode(res.body);
    // print(decodebody);
    setState(() {
      weather_model = WeatherModel.fromJson(decodebody);
      temp = '${weather_model!.temp}';
      presure = '${weather_model!.pressure}';
      hum = '${weather_model!.humidity}';
      desc = '${weather_model!.des}';
      status = '${weather_model!.weather_status}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: primaryColor,
          title: Padding(
            padding: const EdgeInsets.only(top: 22.0),
            child: InkWell(
                onTap: () {
                  toggleButton(
                    widget.siteId!,
                  );
                },
                child: Image.asset(
                  'assets/icons/sav.png',
                  color: iconColor,
                  scale: 4.5,
                )),
          ),
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
      body: FutureBuilder(
          future: fetchSitedetail(widget.siteId!),
          builder: (context, AsyncSnapshot sp) {
            if (!sp.hasData) {
              return Center(
                  child: CircularProgressIndicator(
                color: primaryColor,
              ));
            }
            final dataa = sp.data;

            return SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 230,
                        child: PageView.builder(
                          controller: controller,
                          itemCount: dataa['images'].length,
                          itemBuilder: (context, index) {
                            // if (imageUrls == '') {
                            //   Image.asset('assets/images/men.png');
                            // } else {
                            //   imageUrls[index];
                            // }
                            return CachedNetworkImage(
                              height: 300,
                              width: double.infinity,
                              imageUrl: '${dataa['images'][index]['image']}',
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Center(
                                child: CircularProgressIndicator(
                                    color: primaryColor,
                                    value: downloadProgress.progress),
                              ),
                              errorWidget: (context, url, error) => Center(
                                child: Image.asset(
                                  'assets/images/skis.jpg',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned.fill(
                        top: 200,
                        // left: 150,
                        child: Align(
                          alignment: Alignment.center,
                          child: SmoothPageIndicator(
                            controller: controller,
                            count: dataa['images'].length,
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
                    height: 5,
                  ),

                  // rating container

                  Container(
                    height: 45,
                    child: ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        bool hasRated = dataa['rating_data'] != null &&
                            dataa['rating_data'].any((rating) =>
                                rating['userId'] == int.parse(id.toString()) &&
                                rating['siteId'] == widget.siteId);

                        return Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              !hasRated
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        isLoading == true
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: primaryColor,
                                                ),
                                              )
                                            : MaterialButton(
                                                onPressed: () {
                                                  addRating(widget.siteId!, id,
                                                      selectedStars);
                                                  print(
                                                      'my selected rating is $selectedStars');
                                                },
                                                child: Text(
                                                  'שלח',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                color: primaryColor,
                                                minWidth: 80,
                                                height: 25,
                                              ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: List.generate(5, (index) {
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedStars = index + 1;
                                                });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 5.0),
                                                child: index < selectedStars
                                                    ? Icon(
                                                        Icons.star,
                                                        color: Colors.green,
                                                        size: 28,
                                                      )
                                                    : Icon(
                                                        Icons.star_border,
                                                        size: 28,
                                                        color: Colors.green,
                                                      ),
                                              ),
                                            );
                                          }),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      'דירגתם את האתר הזה ',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: Color(0xFF172B4C),
                                        fontSize: 15,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${dataa['rating']}/5 '.substring(0, 3),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0xFF172B4C),
                            fontSize: 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          ': דירוג ממוצע',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0xFF172B4C),
                            fontSize: 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // title text

                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${widget.title}',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0xFF172B4C),
                            fontSize: 20,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                          textScaleFactor: 1.0,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  //2nd text

                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'פרטי התקשרות',
                          textAlign: TextAlign.right,
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

                  //location

                  SizedBox(
                    height: 20,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right: 15.0, left: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              widget.location == "null"
                                  ? ''
                                  : '${widget.location}',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Color(0xFF172B4C),
                                fontSize: 13,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                              textScaleFactor: 1.0,
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Image.asset(
                          'assets/icon/pin.png',
                          color: primaryColor,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  //phone
                  widget.phone == "null"
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    widget.phone == "null" || widget.phone == ''
                                        ? ''
                                        : '${widget.phone}',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Color(0xFF172B4C),
                                      fontSize: 13,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textScaleFactor: 1.0,
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Image.asset(
                                'assets/icon/call.png',
                                scale: 1,
                              ),
                            ],
                          ),
                        ),

                  //global

                  SizedBox(
                    height: 20,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right: 15.0, left: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              launchUrl(Uri.parse(widget.siteName.toString()));
                            },
                            child: Text(
                              widget.siteName == "null"
                                  ? ''
                                  : '${widget.siteName}',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 13,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.underline,
                              ),
                              textScaleFactor: 1,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: false,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Image.asset(
                          'assets/icon/global.png',
                          scale: 1,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: 320,
                    height: 1,
                    decoration: BoxDecoration(color: Color(0xFFEFF3F9)),
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  //temperature detail text title

                  Text(
                    'מידע על האתר',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Color(0xFF172B4C),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  //temperature detail text1

                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //left container

                        Container(
                          height: 145,
                          width: 164,
                          child: Column(
                            children: [
                              dataa['seate_elevator'] == null
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${dataa['seate_elevator']} מעליות מושב',
                                          style: TextStyle(
                                            color: Color(0xFF172B4C),
                                            fontSize: 12,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                          ),
                                          textScaleFactor: 1.0,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Image.asset(
                                          'assets/icon/11.png',
                                          scale: 4,
                                        ),
                                      ],
                                    ),
                              SizedBox(
                                height: 10,
                              ),
                              dataa['car_lift'] == null
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${dataa['car_lift']} מעליות קרון  ',
                                          style: TextStyle(
                                            color: Color(0xFF172B4C),
                                            fontSize: 12,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                          ),
                                          textScaleFactor: 1.0,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Image.asset(
                                          'assets/icon/12.png',
                                          scale: 4,
                                        ),
                                      ],
                                    ),
                              SizedBox(
                                height: 10,
                              ),
                              dataa['t-bar_lift'] == null
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${dataa['t-bar_lift']}  מעליות טי-בר',
                                          style: TextStyle(
                                            color: Color(0xFF172B4C),
                                            fontSize: 12,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                          ),
                                          textScaleFactor: 1.0,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Image.asset(
                                          'assets/icon/13.png',
                                          scale: 4,
                                        ),
                                      ],
                                    ),
                              SizedBox(
                                height: 10,
                              ),
                              dataa['snow_park'] == null
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'סנופארק: ${dataa['snow_park']} ',
                                          textScaleFactor: 1.0,
                                          style: TextStyle(
                                            color: Color(0xFF172B4C),
                                            fontSize: 12,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Image.asset(
                                          'assets/icon/14.png',
                                          scale: 4,
                                        ),
                                      ],
                                    ),
                              SizedBox(
                                height: 10,
                              ),
                              dataa['site_hieght'] == null
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'גובה אתר ${dataa['site_hieght']} ',
                                          textScaleFactor: 1.0,
                                          style: TextStyle(
                                            color: Color(0xFF172B4C),
                                            fontSize: 12,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Image.asset(
                                          'assets/icon/15.png',
                                          scale: 4,
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),

                        //right container

                        Container(
                          height: 145,
                          width: 170,
                          child: Column(
                            children: [
                              dataa['track'] == null
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              ' ק”מ מסלולים',
                                              style: TextStyle(
                                                color: Color(0xFF172B4C),
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                              ),
                                              textScaleFactor: 1.0,
                                            ),
                                            Text(
                                              ' ${dataa['track']}',
                                              style: TextStyle(
                                                color: Color(0xFF172B4C),
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                              ),
                                              textScaleFactor: 1.0,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Image.asset(
                                          'assets/icon/way.png',
                                          scale: 4,
                                        ),
                                      ],
                                    ),
                              SizedBox(
                                height: 10,
                              ),
                              dataa['green_lanes'] == null
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              ' מסלולים ירוקים',
                                              style: TextStyle(
                                                color: Color(0xFF172B4C),
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                              ),
                                              textScaleFactor: 1.0,
                                            ),
                                            Text(
                                              ' ${dataa['green_lanes']}',
                                              style: TextStyle(
                                                color: Color(0xFF172B4C),
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                              ),
                                              textScaleFactor: 1.0,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Image.asset(
                                          'assets/icon/green.png',
                                          scale: 4,
                                        ),
                                      ],
                                    ),
                              SizedBox(
                                height: 10,
                              ),
                              dataa['blue_lane'] == null
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              ' מסלולים כחולים',
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                color: Color(0xFF172B4C),
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              ' ${dataa['blue_lane']}',
                                              style: TextStyle(
                                                color: Color(0xFF172B4C),
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                              ),
                                              textScaleFactor: 1.0,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Image.asset(
                                          'assets/icon/blue.png',
                                          scale: 4,
                                        ),
                                      ],
                                    ),
                              SizedBox(
                                height: 10,
                              ),
                              dataa['red_track'] == null
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              ' מסלולים אדומים',
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                color: Color(0xFF172B4C),
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              ' ${dataa['red_track']}',
                                              style: TextStyle(
                                                color: Color(0xFF172B4C),
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                              ),
                                              textScaleFactor: 1.0,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Image.asset(
                                          'assets/icon/red.png',
                                          scale: 4,
                                        ),
                                      ],
                                    ),
                              SizedBox(
                                height: 10,
                              ),
                              dataa['black_track'] == null
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              ' מסלולים שחורים',
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                color: Color(0xFF172B4C),
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              ' ${dataa['black_track']}',
                                              style: TextStyle(
                                                color: Color(0xFF172B4C),
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                              ),
                                              textScaleFactor: 1.0,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Image.asset(
                                          'assets/icon/black.png',
                                          scale: 4,
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //temperature image text
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: 320,
                    height: 1,
                    decoration: BoxDecoration(color: Color(0xFFEFF3F9)),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          ':תחזית',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0xFF172B4C),
                            fontSize: 17,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                          textScaleFactor: 1.0,
                        ),
                      ],
                    ),
                  ),

                  //temperature image

                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomGoogleMap(
                            lat: latitude,
                            long: longitude,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 200,
                      width: 350,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(1.00, 0.00),
                          end: Alignment(-1, 0),
                          colors: [
                            Color(0xFF1DA6EA),
                            Color(0xFF3A7BD5),
                            Color(0xFF00D2FF),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                temp == null
                                    ? Text(
                                        'No Location',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    : Text(
                                        '${temp}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 45,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                Text(
                                  presure == null ? '' : '\u00B0',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 45,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${widget.location}',
                                      // 'Sahiwal',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    Image.asset(
                                      'assets/icons/loc.png',
                                      scale: 5,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                Image.asset(
                                  'assets/images/snow.png',
                                  scale: 5,
                                  color: Colors.transparent,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //left container

                              Container(
                                height: 70,
                                width: 170,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 70,
                                        ),
                                        Text(
                                          presure == null || presure!.isEmpty
                                              ? "presure"
                                              : '${presure}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                          ),
                                          textScaleFactor: 1.0,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Image.asset(
                                          'assets/icons/wind.png',
                                          scale: 4,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 70,
                                        ),
                                        Text(
                                          status == null || status!.isEmpty
                                              ? "status"
                                              : '${status}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                          ),
                                          textScaleFactor: 1.0,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Image.asset(
                                          'assets/icons/cloud.png',
                                          scale: 4,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                height: 45,
                                width: 1,
                                color: Colors.white38,
                              ),

                              //right container

                              Container(
                                height: 70,
                                width: 170,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          sunsetString == null ||
                                                  sunsetString!.isEmpty
                                              ? "sunset"
                                              : sunsetString.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                          ),
                                          textScaleFactor: 1.0,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Image.asset(
                                          'assets/icons/sun1.png',
                                          scale: 4,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          sunriseString == null ||
                                                  sunriseString!.isEmpty
                                              ? "sunrise"
                                              : sunriseString.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                          ),
                                          textScaleFactor: 1.0,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Image.asset(
                                          'assets/icons/sun-fog.png',
                                          scale: 4,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: 320,
                    height: 1,
                    decoration: BoxDecoration(color: Color(0xFFEFF3F9)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(right: 10.0,left: 10),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       SizedBox(
                  //         width: 20,
                  //       ),
                  //       Row(
                  //         children: [
                  //           Container(
                  //             height: 10,
                  //             width: 10,
                  //             decoration: BoxDecoration(
                  //                 color: Colors.green,
                  //                 shape: BoxShape.circle
                  //             ),
                  //           ),
                  //           Text(' Night'),
                  //         ],
                  //       ),
                  //       SizedBox(
                  //         width: 10,
                  //       ),
                  //       Row(
                  //         children: [
                  //           Container(
                  //             height: 10,
                  //             width: 10,
                  //             decoration: BoxDecoration(
                  //                 color: Colors.red,
                  //                 shape: BoxShape.circle
                  //             ),
                  //           ),
                  //           Text(' Pm'),
                  //         ],
                  //       ),
                  //       SizedBox(
                  //         width: 10,
                  //       ),
                  //       Row(
                  //         children: [
                  //           Container(
                  //             height: 10,
                  //             width: 10,
                  //             decoration: BoxDecoration(
                  //                 color: Colors.blue,
                  //                 shape: BoxShape.circle
                  //             ),
                  //           ),
                  //           Text(' Am'),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  //graph text

                  Padding(
                    padding: const EdgeInsets.only(right: 15.0, left: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0, left: 15),
                          child: Container(
                            width: 100,
                            height: 40,
                            child: DropdownButtonHideUnderline(
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: DropdownButton2(
                                  isExpanded: true,
                                  items: <String>['AM', 'PM', 'Night']
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: primaryColor
                                                    .withOpacity(0.5),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ))
                                      .toList(),
                                  value: selectedTime,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedTime = newValue!;
                                    });
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    height: 50,
                                    width: 160,
                                    padding: const EdgeInsets.only(
                                        left: 18, right: 18),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: Colors.grey.withOpacity(0.4),
                                      ),
                                    ),
                                  ),
                                  iconStyleData: IconStyleData(
                                    icon: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                    ),
                                    iconSize: 21,
                                    iconEnabledColor:
                                        primaryColor.withOpacity(0.5),
                                    iconDisabledColor:
                                        primaryColor.withOpacity(0.5),
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    maxHeight: 130,
                                    width: 130,
                                    padding: null,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white,
                                    ),
                                  ),
                                  menuItemStyleData: MenuItemStyleData(
                                    height: 40,
                                    padding:
                                        EdgeInsets.only(left: 14, right: 14),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'רמת שלג',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0xFF172B4C),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                          textScaleFactor: 1.0,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      left: 10.0,
                      right: 10
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: BarChartSample(
                              resortName: widget.location,
                              selectedTime: selectedTime),
                        ),
                        RotatedBox(
                          quarterTurns: 3,
                          child: Text('cm'),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 15,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'על האתר',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0xFF172B4C),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                          textScaleFactor: 1.0,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15.0, left: 15),
                      child: Text(
                        '${widget.description}',
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

                  //snow image

                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: InkWell(
                      onTap: () {
                        Get.to(
                          () => ImageZoomScreen('${dataa['bottom_image']}'),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          height: 240,
                          width: 350,
                          imageUrl: '${dataa['bottom_image']}',
                          fit: BoxFit.cover,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(
                                color: primaryColor,
                                value: downloadProgress.progress),
                          ),
                          errorWidget: (context, url, error) => Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                height: 240,
                                width: 350,
                                'assets/images/skis.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // SizedBox(
                  //   height: 15,
                  // ),
                  // Container(
                  //   width: 320,
                  //   height: 1,
                  //   decoration: BoxDecoration(color: Color(0xFFEFF3F9)),
                  // ),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     children: [
                  //       for (int i = 0; i < 3; i++)
                  //         Padding(
                  //           padding: const EdgeInsets.only(left: 10.0, right: 6),
                  //           child: Container(
                  //             height: 120,
                  //             width: 340,
                  //             decoration: BoxDecoration(
                  //               image: DecorationImage(
                  //                 image: AssetImage('assets/images/sno.png'),
                  //                 fit: BoxFit.fill,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //     ],
                  //   ),
                  // ),

                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
