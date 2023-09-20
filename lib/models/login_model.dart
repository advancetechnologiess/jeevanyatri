// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);


import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    required this.error,
    required this.message,
    required this.login,
  });

  bool error;
  String message;
  List<Login> login;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    error: json["error"],
    message: json["message"],
    login: json["Login"]!=null ? List<Login>.from(json["Login"].map((x) => Login.fromJson(x))) : <Login>[],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "Login": List<dynamic>.from(login.map((x) => x.toJson())),
  };
}

class Login {
  Login({
    required this.id
  });

  dynamic id;

  factory Login.fromJson(Map<String, dynamic> json) => Login(
    id: json["id"]
  );

  Map<String, dynamic> toJson() => {
    "id": id
  };
}
