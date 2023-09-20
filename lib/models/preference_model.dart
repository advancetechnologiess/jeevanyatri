// To parse this JSON data, do
//
//     final prefrenceModel = prefrenceModelFromJson(jsonString);

import 'dart:convert';

PrefrenceModel prefrenceModelFromJson(String str) =>
    PrefrenceModel.fromJson(json.decode(str));

String prefrenceModelToJson(PrefrenceModel data) => json.encode(data.toJson());

class PrefrenceModel {
  PrefrenceModel({
    required this.error,
    required this.message,
    required this.userPrefrence,
  });

  bool error;
  String message;
  List<UserPrefrence> userPrefrence;

  factory PrefrenceModel.fromJson(Map<String, dynamic> json) => PrefrenceModel(
        error: json["error"],
        message: json["message"],
        userPrefrence: json["UserPrefrence"] != null
            ? List<UserPrefrence>.from(
                json["UserPrefrence"].map((x) => UserPrefrence.fromJson(x)))
            : <UserPrefrence>[],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "UserPrefrence":
            List<dynamic>.from(userPrefrence.map((x) => x.toJson())),
      };
}

class UserPrefrence {
  UserPrefrence(
      {required this.id,
      required this.userId,
      required this.ageFrom,
      required this.ageTo,
      required this.heightFrom,
      required this.heightTo,
      required this.qualifications,
      required this.education,
      required this.occupation,
      required this.isManglik,
      required this.isNRI,
      required this.religion,
      required this.cast,
      required this.subcast,
      required this.location,
      required this.city,
      required this.state,
      required this.country,
      required this.income});

  String id;
  String userId;
  String ageFrom;
  String ageTo;
  String heightFrom;
  String heightTo;
  String education;
  String religion;
  String cast;
  String subcast;
  String location;
  String city;
  String state;
  String country;
  dynamic qualifications;
  dynamic occupation;
  String income;
  bool isManglik;
  bool isNRI;

  factory UserPrefrence.fromJson(Map<String, dynamic> json) => UserPrefrence(
        id: json["id"],
        userId: json["user_id"],
        ageFrom: json["age_from"],
        ageTo: json["age_to"],
        heightFrom: json["height_from"],
        heightTo: json["height_to"],
        qualifications: json["qualifications"],
        education: json["education"],
        occupation: json["occupation"],
        isManglik: json["isManglik"],
        isNRI: json["isNRI"],
        religion: json["religion"],
        cast: json["cast"],
        subcast: json["subcast"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        location: json["location"],
        income: json["income"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "age_from": ageFrom,
        "age_to": ageTo,
        "height_from": heightFrom,
        "height_to": heightTo,
        "qualifications": qualifications,
        "education": education,
        "occupation": occupation,
        "isManglik": isManglik,
        "isNRI": isNRI,
        "religion": religion,
        "cast": cast,
        "subcast": subcast,
        "city": city,
        "state": state,
        "country": country,
        "location": location,
        "income": income
      };
}
