import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const apiUrl = "https://skisrael.co.il/";
  static const mainURl = "https://ecomm.usstateservice.com/";
  Dio dio = Dio();
  Future postApiwithToken(String path, Map data, String authToken) async {
    log("$data");
    // Response response = await dio.post(apiUrl + path,
    //     data: data,
    //     options: Options(headers: {
    //       'Content-Type': 'application/json',
    //       "Accept": "application/json"
    //     }));

    try {
      final response = await dio.post(apiUrl + path,
          data: data,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ' + authToken.toString(),
          }));
      // Process the response here
      // print(response.data);
      return response.data;
    } on DioError catch (e) {
      if (e.response != null) {
        // The server returned an error status code (not 200)
        // print('Server error status: ${e.response!.statusCode}');
        // print('Server error data: ${e.response!.data}');
        return e.response!.data;
      } else {
        // Something went wrong during the network request
        // print('Network error: $e');
        return e;
      }
    } catch (e) {
      // Handle other errors
      // print('Error: $e');
      return e;
    }

    // log("${response.statusCode}");
    // return response.data;
  }

  Future postApi(String path, Map data) async {
    log("$data");
    // Response response = await dio.post(apiUrl + path,
    //     data: data,
    //     options: Options(headers: {
    //       'Content-Type': 'application/json',
    //       "Accept": "application/json"
    //     }));

    try {
      final response = await dio.post(apiUrl + path, data: data);
      // Process the response here
      // print(response.data);
      return response.data;
    } on DioError catch (e) {
      if (e.response != null) {
        // The server returned an error status code (not 200)
        // print('Server error status: ${e.response!.statusCode}');
        // print('Server error data: ${e.response!.data}');
        return e.response!.data;
      } else {
        // Something went wrong during the network request
        // print('Network error: $e');
        return e;
      }
    } catch (e) {
      // Handle other errors
      // print('Error: $e');
      return e;
    }

    // log("${response.statusCode}");
    // return response.data;
  }

  Future updateApi(String path, Map data) async {
    log("$data");
    Response response = await dio.put(apiUrl + path,
        data: data,
        options: Options(headers: {
          'Content-Type': 'application/json',
          "Accept": "application/json"
        }));
    // print(response);
    return response.data;
  }

  Future deletePost(String path, Map data) async {
    log("$data");
    Response response = await dio.delete(apiUrl + path,
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}));
    // print(response);
    return response.data;
  }

  Future getApi(String path, String authToken) async {
    log("$authToken");
    try {
      final response = await dio.get(apiUrl + path,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ' + authToken.toString(),
          }));
      // Process the response here
      // print(response.data);
      return response.data;
    } on DioError catch (e) {
      if (e.response != null) {
        // The server returned an error status code (not 200)
        // print('Server error status: ${e.response!.statusCode}');
        // print('Server error data: ${e.response!.data}');
        return e.response!.data;
      } else {
        // Something went wrong during the network request
        // print('Network error: $e');
        return e;
      }
    } catch (e) {
      // Handle other errors
      // print('Error: $e');
      return e;
    }
  }

  Future getApiWithToken(String path, Map data) async {
    var token = "";
    await getUser().then((value) {
      print(value);
      token = value["token"];
      print(token);
    });
    Response response = await dio.post(apiUrl + path,
        data: data,
        options: Options(headers: {
          "Authorization": "Bearer${token.toString()}",
          'Content-Type': 'application/json',
          "Accept": "application/json",
        }));
    // log("${response.data}");
    // final result = json.decode(response.data.toString());
    return response.data;
  }

  Future getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var d = prefs.getString('notification');
    if (d != null) {
      return jsonDecode(d);
    } else {
      return null;
    }
  }

  Future<bool> setUser(user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('notification', jsonEncode(user));
    await prefs.setBool('loggedIn', true);
    return true;
  }
}
