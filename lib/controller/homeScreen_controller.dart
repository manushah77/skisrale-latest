import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skisreal/BotttomNavigation/Models/feed_model.dart';
import 'package:skisreal/service/service.dart';

class HomeScreen_Controller extends GetxController {
  RxString token = "".obs;
  RxString id = "".obs;
  var data = [].obs;
  var likedPosts = [].obs;
  var isLoading = false.obs;
  var userLoader = false.obs;
  var tagList = [].obs;
  var tagLoader = false.obs;
  var loginUser = {}.obs;
  Future<void> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // setState(() {
    if (prefs.getString("token") == null && prefs.getString("status") == null) {
      token.value = "";
      id.value = "";
    } else {
      token.value = prefs.getString('token')!;
      id.value = prefs.getString('id')!;
    }
    // print('My fetch sdsadsafd is $token');
    // print('My fetch id is $id');
    // fetchFeeds(token.value);

    // });
    // print('asdadasda $token');
  }

  Future fetchFeeds() async {
    try {
      isLoading(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // setState(() {
      if (prefs.getString("token") == null &&
          prefs.getString("status") == null) {
        token.value = "";
        id.value = "";
      } else {
        token.value = prefs.getString('token')!;
        id.value = prefs.getString('id')!;
      }
      await UserService().getApi("api/get_all_feed", token.value).then((value) {
        // print("fecth data funcation $value");
        if (value["status"] == "success") {
          List<FeedElement> feed = (value['feed'] as List<dynamic>)
              .map((e) => FeedElement.fromJson(e))
              .toList();
          for (var e in feed) {
            for (var like in e.likes!) {
              if (id == like.likedBy.toString()) {
                // setState(() {
                likedPosts.value.add(e.id.toString());
                // });
              }
            }
          }
          data.value = value["feed"];
        } else {
          throw Exception('Failed to fetch feeds,');
        }
      });
    } finally {
      isLoading(false);
    }
  }

  fetchCurrentUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // setState(() {
      if (prefs.getString("token") == null) {
        token.value = "";
      } else {
        token.value = prefs.getString('token')!;
      }
      userLoader(true);
      UserService().getApi("api/user_profile", token.value).then((value) {
        // print(value);
        if (value['status'] == 'success') {
          loginUser.value = value["user"];
        } else {
          throw Exception('Failed to connect to the API. Error code: ${value}');
        }
      });
    } finally {
      userLoader(false);
    }
    //   final response = await http
    //       .get(Uri.parse(Consts.BASE_URL + '/api/user_profile'), headers: {
    //     'Content-Type': 'application/json',
    //     'Accept': 'application/json',
    //     'Authorization': 'Bearer $token',
    //   });

    //   if (response.statusCode == 200) {
    //     final jsonBody = json.decode(response.body);
    //     // print(jsonBody.toString());
    //     if (jsonBody['status'] == 'success') {
    //       final userJson = jsonBody['user'];
    //       // setState(() {
    //       //   base64Image = userJson['profile_image'];
    //       // });
    //       return User.fromJson(userJson);
    //     } else {
    //       throw Exception(jsonBody['message']);
    //     }
    //   } else {
    //     throw Exception(
    //         'Failed to connect to the API. Error code: ${response.statusCode}');
    //   }
  }

  Future tagsApi(List tages) async {
    try {
      tagLoader(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // setState(() {
      if (prefs.getString("token") == null) {
        token.value = "";
      } else {
        token.value = prefs.getString('token')!;
      }
      Map data = {"tages": tages};
      await UserService()
          .postApiwithToken("api/tag_search", data, token.value)
          .then((value) {
        // print(value);
        if (value["status"] == "success") {
          tagList.value = value["feed"];
        } else {}
        return tagList.value;
      });
    } finally {
      tagLoader(false);
    }
  }
}
