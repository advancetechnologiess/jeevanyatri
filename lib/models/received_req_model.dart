// To parse this JSON data, do
//
//     final recievedRequestModel = recievedRequestModelFromJson(jsonString);


import 'dart:convert';

RecievedRequestModel recievedRequestModelFromJson(String str) => RecievedRequestModel.fromJson(json.decode(str));

String recievedRequestModelToJson(RecievedRequestModel data) => json.encode(data.toJson());

class RecievedRequestModel {
  RecievedRequestModel({
    required this.error,
    required this.message,
    required this.receivedRequest,
  });

  bool error;
  String message;
  List<ReceivedRequest> receivedRequest;

  factory RecievedRequestModel.fromJson(Map<String, dynamic> json) => RecievedRequestModel(
    error: json["error"],
    message: json["message"],
    receivedRequest: json["ReceivedRequest"] != null ? List<ReceivedRequest>.from(json["ReceivedRequest"].map((x) => ReceivedRequest.fromJson(x)))
    : <ReceivedRequest>[],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "ReceivedRequest": List<dynamic>.from(receivedRequest.map((x) => x.toJson())),
  };
}

class ReceivedRequest {
  ReceivedRequest({
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
  String userId;
  dynamic name;
  dynamic imageUrl;
  dynamic religion;
  dynamic cast;
  dynamic age;
  dynamic userHeight;
  dynamic city;
  dynamic state;
  dynamic occupation;
  dynamic education;

  factory ReceivedRequest.fromJson(Map<String, dynamic> json) => ReceivedRequest(
    id: json["id"],
    userId: json["user_id"],
    name: json["name"]!= null ? json["name"] : "",
    imageUrl: json["image_url"] != null ? json["image_url"] : "",
    religion: json["religion"],
    cast: json["cast"],
    age: json["age"],
    userHeight: json["user_height"],
    city: json["city"],
    state: json["state"],
    occupation: json["occupation"],
    education: json["education"],
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
