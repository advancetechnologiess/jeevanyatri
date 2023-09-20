// To parse this JSON data, do
//
//     final shortlistModel = shortlistModelFromJson(jsonString);


import 'dart:convert';

ShortlistModel shortlistModelFromJson(String str) => ShortlistModel.fromJson(json.decode(str));

String shortlistModelToJson(ShortlistModel data) => json.encode(data.toJson());

class ShortlistModel {
  ShortlistModel({
    required this.error,
    required this.message,
    required this.shortlist,
  });

  bool error;
  String message;
  List<ShortlistUsers> shortlist;

  factory ShortlistModel.fromJson(Map<String, dynamic> json) => ShortlistModel(
    error: json["error"],
    message: json["message"],
    shortlist:  json["Shortlist"] != null ? List<ShortlistUsers>.from(json["Shortlist"].map((x) => ShortlistUsers.fromJson(x)))
        : <ShortlistUsers>[],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "Shortlist": List<dynamic>.from(shortlist.map((x) => x.toJson())),
  };
}

class ShortlistUsers {
  ShortlistUsers({
    required this.id,
    required this.userId,
    required this.name,
    required this.imageUrl,
    required this.religion,
    required this.cast,
    required this.age,
    required this.userHeight,
    required this.city,
    required this.state,
    required this.occupation,
    required this.education,
  });

  String id;
  dynamic userId;
  String name;
  dynamic imageUrl;
  String religion;
  String cast;
  String age;
  String userHeight;
  String city;
  String state;
  String occupation;
  String education;

  factory ShortlistUsers.fromJson(Map<String, dynamic> json) => ShortlistUsers(
    id: json["id"],
    userId: json["user_id"],
    name: json["name"] != null ? json["name"] : "",
    imageUrl: json["image_url"] != null ? json["image_url"] : "",
    religion: json["religion"] != null ? json["religion"] : "",
    cast: json["cast"] != null ? json["cast"] : "",
    age: json["age"] != null ? json["age"] : "",
    userHeight: json["user_height"] != null ? json["user_height"] : "",
    city: json["city"] != null ? json["city"] : "",
    state: json["state"] != null ? json["state"] : "",
    occupation: json["occupation"] != null ? json["occupation"] : "",
    education: json["education"] != null ? json["education"] : "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "name": name,
    "image_url": imageUrl,
    "religion": religion,
    "cast": cast,
    "age": age,
    "user_height": userHeight,
    "city": city,
    "state": state,
    "occupation": occupation,
    "education": education,
  };
}
