// To parse this JSON data, do
//
//     final userMatchModel = userMatchModelFromJson(jsonString);
import 'dart:convert';

UserMatchModel userMatchModelFromJson(String str) => UserMatchModel.fromJson(json.decode(str));

String userMatchModelToJson(UserMatchModel data) => json.encode(data.toJson());

class UserMatchModel {
  UserMatchModel({
    required this.error,
    required this.message,
    required this.usersMatch,
  });

  bool error;
  String message;
  List<UsersMatch> usersMatch;

  factory UserMatchModel.fromJson(Map<String, dynamic> json) => UserMatchModel(
    error: json["error"],
    message: json["message"],
    usersMatch: json["UsersMatch"] !=null ?  List<UsersMatch>.from(json["UsersMatch"].map((x) => UsersMatch.fromJson(x))) : <UsersMatch>[],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "UsersMatch": List<dynamic>.from(usersMatch.map((x) => x.toJson())),
  };
}

class UsersMatch {
  UsersMatch({
    required this.id,
    required this.name,
    required this.mobile,
    required this.email,
    required this.age,
    required this.gender,
    required this.userHeight,
    required this.userWeight,
    required this.dob,
    required this.status,
    required this.religion,
    required this.cast,
    required this.subcast,
    required this.imageUrl,
    required this.bio,
    required this.city,
    required this.state,
    required this.subscriptionId,
    required this.isInterestAdded,
    required this.interestApproved,
    required this.isStared
  });

  String id;
  dynamic name;
  String mobile;
  dynamic email;
  dynamic age;
  dynamic gender;
  dynamic userHeight;
  dynamic userWeight;
  dynamic dob;
  dynamic status;
  dynamic religion;
  dynamic cast;
  dynamic subcast;
  dynamic imageUrl;
  dynamic bio;
  dynamic city;
  dynamic state;
  dynamic subscriptionId;
  bool isInterestAdded;
  bool interestApproved;
  bool isStared;

  factory UsersMatch.fromJson(Map<String, dynamic> json) => UsersMatch(
    id: json["id"],
    name: json["name"] != null ? json["name"] : "Unknown",
    mobile: json["mobile"] != null ? json["mobile"] : "",
    email: json["email"] != null ? json["email"] : "",
    age: json["age"] != null ? json["age"] : "",
    gender: json["gender"] != null ? json["gender"] : "",
    userHeight: json["user_height"] != null ? json["user_height"] : "",
    userWeight: json["user_weight"] != null ? json["user_weight"] : "",
    dob: json["DOB"] != null ? json["DOB"] : "",
    status: json["status"] != null ? json["status"] : "",
    religion: json["religion"] != null ? json["religion"] : "",
    cast: json["cast"] != null ? json["cast"] : "",
    subcast: json["subcast"] != null ? json["subcast"] : "",
    imageUrl: json["image_url"] != null ? json["image_url"] : "",
    bio: json["bio"] != null ? json["bio"] : "",
    city: json["city"] != null ? json["city"] : "",
    state: json["state"] != null ? json["state"] : "",
    subscriptionId: json["subscription_id"] != null ? json["subscription_id"] : "",
    isInterestAdded: json["isInterestAdded"] != null ? json["isInterestAdded"] : false,
    interestApproved: json["interestApproved"] != null ? json["interestApproved"] : false,
    isStared: json["isStarred"] != null ? json["isStarred"] : false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "mobile": mobile,
    "email": email,
    "age": age,
    "gender": gender,
    "user_height": userHeight,
    "user_weight": userWeight,
    "DOB": dob,
    "status": status,
    "religion": religion,
    "cast": cast,
    "subcast": subcast,
    "image_url": imageUrl,
    "bio": bio,
    "city": city,
    "state": state,
    "subscription_id": subscriptionId,
    "isInterestAdded": isInterestAdded,
    "interestApproved": interestApproved,
    "isStarred": isStared
  };
}
