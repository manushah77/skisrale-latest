// To parse this JSON data, do
//
//     final feed = feedFromJson(jsonString);

import 'dart:convert';

Feed feedFromJson(String str) => Feed.fromJson(json.decode(str));

String feedToJson(Feed data) => json.encode(data.toJson());

class Feed {
  String? status;
  int? code;
  List<FeedElement>? feed;
  String? message;

  Feed({
    this.status,
    this.code,
    this.feed,
    this.message,
  });

  factory Feed.fromJson(Map<String, dynamic> json) => Feed(
    status: json["status"],
    code: json["code"],
    feed: json["feed"] == null ? [] : List<FeedElement>.from(json["feed"]!.map((x) => FeedElement.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "feed": feed == null ? [] : List<dynamic>.from(feed!.map((x) => x.toJson())),
    "message": message,
  };
}

class FeedElement {
  int? id;
  String? userId;
  String? title;
  String? opinion;
  String? location;
  dynamic website;
  String? isReported;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? bottomVideo;
  int? commentsCount;
  int? likeCount;
  Users? users;
  // List<Image>? images;
  // List<Image>? tags;
  List<Like>? likes;

  FeedElement({
    this.id,
    this.userId,
    this.title,
    this.opinion,
    this.location,
    this.website,
    this.isReported,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.bottomVideo,
    this.commentsCount,
    this.likeCount,
    this.users,
    // this.images,
    // this.tags,
    this.likes,
  });

  factory FeedElement.fromJson(Map<String, dynamic> json) => FeedElement(
    id: json["id"],
    userId: json["user_id"],
    title: json["title"],
    opinion: json["opinion"],
    location: json["location"],
    website: json["website"],
    isReported: json["is_reported"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    bottomVideo: json["bottom_video"],
    commentsCount: json ["comments_count"],
    likeCount: json["like_count"],
    users: json["users"] == null ? null : Users.fromJson(json["users"]),
    // images: json["images"] == null ? [] : List<Image>.from(json["images"]!.map((x) => Image.fromJson(x))),
    // tags: json["tags"] == null ? [] : List<Image>.from(json["tags"]!.map((x) => Image.fromJson(x))),
    likes: json["likes"] == null ? [] : List<Like>.from(json["likes"]!.map((x) => Like.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "title": title,
    "opinion": opinion,
    "location": location,
    "website": website,
    "is_reported": isReported,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "bottom_video": bottomVideo,
    "comments_count": commentsCount,
    "like_count": likeCount,
    "users": users?.toJson(),
    // "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x.toJson())),
    // "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x.toJson())),
    "likes": likes == null ? [] : List<dynamic>.from(likes!.map((x) => x.toJson())),
  };
}


class Like {
  int? likedBy;
  int? feedId;

  Like({
    this.likedBy,
    this.feedId,
  });

  factory Like.fromJson(Map<String, dynamic> json) => Like(
    likedBy: json["liked_by"],
    feedId: json["feed_id"],
  );

  Map<String, dynamic> toJson() => {
    "liked_by": likedBy,
    "feed_id": feedId,
  };
}

class Users {
  int? id;
  String? name;
  String? email;
  dynamic emailVerifiedAt;
  String? phoneNumber;
  String? sex;
  String? age;
  String? profileImage;
  String? skiStyle;
  String? experienceLevel;
  String? loginType;
  DateTime? createdAt;
  DateTime? updatedAt;

  Users({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.phoneNumber,
    this.sex,
    this.age,
    this.profileImage,
    this.skiStyle,
    this.experienceLevel,
    this.loginType,
    this.createdAt,
    this.updatedAt,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"],
    phoneNumber: json["phone_number"],
    sex: json["sex"],
    age: json["age"],
    profileImage: json["profile_image"],
    skiStyle: json["ski_style"],
    experienceLevel: json["experience_level"],
    loginType: json["login_type"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
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
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
