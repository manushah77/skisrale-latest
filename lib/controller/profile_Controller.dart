import 'package:get/get.dart';
import 'package:skisreal/BotttomNavigation/Models/search_class.dart';
import 'package:skisreal/service/service.dart';

class Profile_Controller extends GetxController {
  var isChecked=false.obs;
  notificationButton()async{
    await UserService().getUser().then((value) {
      print(value);
      if (value==null) {
        isChecked.value=false;
      }else{
        isChecked.value=value;
      }
    });
 
  }
     aboutNotification(var buttonValue)async{
      await UserService().setUser(buttonValue).then((value) {
        print(value);
      });
    }
    @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    notificationButton();
  }
}