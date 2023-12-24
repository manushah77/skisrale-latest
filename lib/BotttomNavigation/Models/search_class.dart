class AutoGenerate {
  AutoGenerate({
    required this.status,
    required this.code,
    required this.feedDetail,
    required this.message,
  });
  late final String status;
  late final int code;
  late final List<FeedDetail> feedDetail;
  late final String message;

  AutoGenerate.fromJson(Map<String, dynamic> json){
    status = json['status'];
    code = json['code'];
    feedDetail = List.from(json['feed_detail']).map((e)=>FeedDetail.fromJson(e)).toList();
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['code'] = code;
    _data['feed_detail'] = feedDetail.map((e)=>e.toJson()).toList();
    _data['message'] = message;
    return _data;
  }
}

class FeedDetail {
  FeedDetail({
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
     this.likesCount,
     this.tags,
     this.images,
     this.users,
  });
    int? id;
    String? userId;
    String? title;
    String? opinion;
    String? location;
    Null website;
    String? isReported;
    String? status;
    String? createdAt;
    String? updatedAt;
    String? bottomVideo;
    int? commentsCount;
    int? likesCount;
    List<Tags>? tags;
    List<Images>? images;
    Users? users;

  FeedDetail.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    opinion = json['opinion'];
    location = json['location'];
    website = null;
    isReported = json['is_reported'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    bottomVideo = json['bottom_video'];
    commentsCount = json['comments_count'];
    likesCount = json['likes_count'];
    tags = List.from(json['tags']).map((e)=>Tags.fromJson(e)).toList();
    images = List.from(json['images']).map((e)=>Images.fromJson(e)).toList();
    users = Users.fromJson(json['users']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['user_id'] = userId;
    _data['title'] = title;
    _data['opinion'] = opinion;
    _data['location'] = location;
    _data['website'] = website;
    _data['is_reported'] = isReported;
    _data['status'] = status;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['bottom_video'] = bottomVideo;
    _data['comments_count'] = commentsCount;
    _data['likes_count'] = likesCount;
    _data['tags'] = tags!.map((e)=>e.toJson()).toList();
    _data['images'] = images!.map((e)=>e.toJson()).toList();
    _data['users'] = users!.toJson();
    return _data;
  }
}

class Tags {
  Tags({
    required this.id,
    required this.feedId,
    this.feedTitle,
    required this.tag,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final int feedId;
  late final Null feedTitle;
  late final String tag;
  late final String createdAt;
  late final String updatedAt;

  Tags.fromJson(Map<String, dynamic> json){
    id = json['id'];
    feedId = json['feed_id'];
    feedTitle = null;
    tag = json['tag'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['feed_id'] = feedId;
    _data['feed_title'] = feedTitle;
    _data['tag'] = tag;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}

class Images {
  Images({
    required this.id,
    required this.feedId,
    this.feedTitle,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final int feedId;
  late final Null feedTitle;
  late final String image;
  late final String createdAt;
  late final String updatedAt;

  Images.fromJson(Map<String, dynamic> json){
    id = json['id'];
    feedId = json['feed_id'];
    feedTitle = null;
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['feed_id'] = feedId;
    _data['feed_title'] = feedTitle;
    _data['image'] = image;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}

class Users {
  Users({
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
  });
  late final int id;
  late final String name;
  late final String email;
  late final Null emailVerifiedAt;
  late final String phoneNumber;
  late final String sex;
  late final String age;
  late final String profileImage;
  late final String skiStyle;
  late final String experienceLevel;
  late final String loginType;
  late final String createdAt;
  late final String updatedAt;

  Users.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = null;
    phoneNumber = json['phone_number'];
    sex = json['sex'];
    age = json['age'];
    profileImage = json['profile_image'];
    skiStyle = json['ski_style'];
    experienceLevel = json['experience_level'];
    loginType = json['login_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['email'] = email;
    _data['email_verified_at'] = emailVerifiedAt;
    _data['phone_number'] = phoneNumber;
    _data['sex'] = sex;
    _data['age'] = age;
    _data['profile_image'] = profileImage;
    _data['ski_style'] = skiStyle;
    _data['experience_level'] = experienceLevel;
    _data['login_type'] = loginType;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}