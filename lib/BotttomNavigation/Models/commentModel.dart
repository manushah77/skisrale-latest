
import 'dart:convert';

class CommentModel {
  String status;
  int code;
  List<Comment> comment;
  String message;

  CommentModel({
    required this.status,
    required this.code,
    required this.comment,
    required this.message,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
    status: json["status"],
    code: json["code"],
    comment: List<Comment>.from(json["Comment"].map((x) => Comment.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "Comment": List<dynamic>.from(comment.map((x) => x.toJson())),
    "message": message,
  };
}

class Comment {
  int id;
  int feedId;
  int commentBy;
  String text;
  DateTime createdAt;
  DateTime updatedAt;
  int replyCount;
  int commentLikesCount;
  User user;
  List<dynamic> reply;
  List<LikeComment>? commentLikes;

  Comment({
    required this.id,
    required this.feedId,
    required this.commentBy,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
    required this.replyCount,
    required this.commentLikesCount,
    required this.user,
    required this.reply,
    required this.commentLikes,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json["id"],
    feedId: json["feed_id"],
    commentBy: json["comment_by"],
    text: json["text"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    replyCount: json["reply_count"],
    commentLikesCount: json["commentLikes_count"],
    user: User.fromJson(json["user"]),
    reply: List<dynamic>.from(json["reply"].map((x) => x)),
    commentLikes: json["comment_likes"] == null ? [] : List<LikeComment>.from(json["comment_likes"]!.map((x) => LikeComment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "feed_id": feedId,
    "comment_by": commentBy,
    "text": text,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "reply_count": replyCount,
    "commentLikes_count": commentLikesCount,
    "user": user.toJson(),
    "reply": List<dynamic>.from(reply.map((x) => x)),
    "comment_likes": commentLikes == null ? [] : List<dynamic>.from(commentLikes!.map((x) => x.toJson())),
  };
}


class LikeComment {
  int? id;
  int? likedBy;
  int? commentId;
  String? status;

  LikeComment({
    this.id,
    this.likedBy,
    this.commentId,
    this.status,
  });

  factory LikeComment.fromJson(Map<String, dynamic> json) => LikeComment(

    id: json["id"],
    likedBy: json["liked_by"],
    commentId: json["comment_id"],
    status :  json['status'],
  );

  Map<String, dynamic> toJson() => {

    "id": id,
    "liked_by": likedBy,
    "comment_id": commentId,
    "status": status,
  };
}


class User {
  int id;
  String name;
  String email;
  dynamic emailVerifiedAt;
  String phoneNumber;
  String sex;
  String age;
  String profileImage;
  String skiStyle;
  String experienceLevel;
  String loginType;
  DateTime createdAt;
  DateTime updatedAt;
  String status;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.phoneNumber,
    required this.sex,
    required this.age,
    required this.profileImage,
    required this.skiStyle,
    required this.experienceLevel,
    required this.loginType,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"]?? "",
    email: json["email"]?? "",
    emailVerifiedAt: json["email_verified_at"]?? "",
    phoneNumber: json["phone_number"] ?? "",
    sex: json["sex"]?? "",
    age: json["age"]?? "",
    profileImage: json["profile_image"]?? "",
    skiStyle: json["ski_style"]?? "",
    experienceLevel: json["experience_level"]?? "",
    loginType: json["login_type"]?? "",
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    status: json["status"]?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "phone_number": phoneNumber,
    "sex": sex,
    "age": age,
    "profile_image": profileImage,
    "ski_style": skiStyle,
    "experience_level": experienceLevel,
    "login_type": loginType,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "status": status,
  };
}
