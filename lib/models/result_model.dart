// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);


import 'dart:convert';

ResultModel resultModelFromJson(String str) => ResultModel.fromJson(json.decode(str));

String resultModelToJson(ResultModel data) => json.encode(data.toJson());

class ResultModel {
  ResultModel({
    required this.error,
    required this.message,
  });

  bool error;
  String message;

  factory ResultModel.fromJson(Map<String, dynamic> json) => ResultModel(
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
  };
}

