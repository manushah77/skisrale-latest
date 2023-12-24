import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skisreal/BotttomNavigation/Models/feed_model.dart';
import 'package:skisreal/service/service.dart';

class AdminTag_Controller extends GetxController {
  RxString token = "".obs;
  var data = [].obs;
  var isLoading = false.obs;

  Future<void> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // setState(() {
    if (prefs.getString("token") == null ) {
      token.value = "";
    } else {
      token.value = prefs.getString('token')!;
    }

  }

  getAdminTags() async {
    try {
      isLoading(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await UserService()
          .getApi("api/getTagsList", token.value)
          .then((value) {
        print(value);
        if (value["status"] == "success") {
          data.value = value["feed"];
          print(data);
        } else {
          data.value.length = 0;
        }
      });
    } finally {
      isLoading(false);
    }
  }

}
