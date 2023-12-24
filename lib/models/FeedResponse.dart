class FeedResponse {
  final String status;
  final int code;
  final FeedDetail feedDetail;
  final String message;

  FeedResponse({
    required this.status,
    required this.code,
    required this.feedDetail,
    required this.message,
  });

  factory FeedResponse.fromJson(Map<String, dynamic> json) {
    return FeedResponse(
      status: json['status'],
      code: json['code'],
      feedDetail: FeedDetail.fromJson(json['feed_detail']),
      message: json['message'],
    );
  }
}

class FeedDetail {
  final int id;
  final String userId;
  final String title;
  final String opinion;
  final String location;
  final String website;
  final String isReported;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String? bottomVideo;
  final UserData users;
  final List<ImageData?> images;
  final List<TagData> tags;

  FeedDetail({
    required this.id,
    required this.userId,
    required this.title,
    required this.opinion,
    required this.location,
    required this.website,
    required this.isReported,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.bottomVideo,
    required this.users,
    required this.images,
    required this.tags,
  });

  factory FeedDetail.fromJson(Map<String, dynamic> json) {
    return FeedDetail(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      opinion: json['opinion'],
      location: json['location'],
      website: json['website'],
      isReported: json['is_reported'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      bottomVideo: json['bottom_video'],
      users: UserData.fromJson(json['users']),
      images: (json['images'] as List)
          .map((data) => ImageData.fromJson(data))
          .toList(),
      tags:
          (json['tags'] as List).map((data) => TagData.fromJson(data)).toList(),
    );
  }
}

class UserData {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final String sex;
  final String age;
  final String profileImage;
  final String skiStyle;
  final String experienceLevel;
  final String loginType;
  final String createdAt;
  final String updatedAt;
  final int status;

  UserData({
    required this.id,
    required this.name,
    required this.email,
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

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      sex: json['sex'],
      age: json['age'],
      profileImage: json['profile_image'],
      skiStyle: json['ski_style'],
      experienceLevel: json['experience_level'],
      loginType: json['login_type'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      status: json['status'],
    );
  }
}

class ImageData {
  final int id;
  final int feedId;
  final String image;
  final String createdAt;
  final String updatedAt;

  ImageData({
    required this.id,
    required this.feedId,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      id: json['id'],
      feedId: json['feed_id'],
      image: json['image'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class TagData {
  final int id;
  final int feedId;
  final String tag;
  final String createdAt;
  final String updatedAt;

  TagData({
    required this.id,
    required this.feedId,
    required this.tag,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TagData.fromJson(Map<String, dynamic> json) {
    return TagData(
      id: json['id'],
      feedId: json['feed_id'],
      tag: json['tag'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
