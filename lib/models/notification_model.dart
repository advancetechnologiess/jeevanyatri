import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());


class NotificationModel {
  NotificationModel({
    required this.image,
    required this.title,
    required this.message,
    required this.type,
  });

  dynamic image;
  String title;
  String message;
  String type;

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    image: json["image"],
    title: json["title"],
    message: json["message"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "title": title,
    "message": message,
    "type": type,
  };
}
