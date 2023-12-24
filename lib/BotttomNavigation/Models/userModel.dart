import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  int id;
  String fullName;
  String phone;
  String email;
  String gender;
  String skisExp;
  String skisStyle;
  String age;
  String img;

  User({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.gender,
    required this.skisExp,
    required this.skisStyle,
    required this.age,
    required this.img,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['name'] ?? '',
      phone: json['phone_number'] ?? '',
      email: json['email'] ?? '',
      gender: json['sex'] ?? '',
      skisExp: json['experience_level'] ?? '',
      skisStyle: json['ski_style'] ?? '',
      age: json['age'] ?? '',
      img: json['profile_image'] ?? '',
    );
  }
}