// To parse this JSON data, do
//
//     final interestStatusModel = interestStatusModelFromJson(jsonString);


import 'dart:convert';

InterestStatusModel interestStatusModelFromJson(String str) => InterestStatusModel.fromJson(json.decode(str));

String interestStatusModelToJson(InterestStatusModel data) => json.encode(data.toJson());

class InterestStatusModel {
  InterestStatusModel({
    required this.error,
    required this.message,
    required this.interestStatus,
  });

  bool error;
  String message;
  List<InterestStatus> interestStatus;

  factory InterestStatusModel.fromJson(Map<String, dynamic> json) => InterestStatusModel(
    error: json["error"],
    message: json["message"],
    interestStatus: json["InterestStatus"] != null ? List<InterestStatus>.from(json["InterestStatus"].map((x) =>
        InterestStatus.fromJson(x))) : <InterestStatus>[],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "InterestStatus": List<dynamic>.from(interestStatus.map((x) => x.toJson())),
  };
}

class InterestStatus {
  InterestStatus({
    required this.id,
    required this.userId,
    required this.requestedId,
    required this.status,
  });

  String id;
  String userId;
  String requestedId;
  String status;

  factory InterestStatus.fromJson(Map<String, dynamic> json) => InterestStatus(
    id: json["id"],
    userId: json["user_id"],
    requestedId: json["requested_id"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "requested_id": requestedId,
    "status": status,
  };
}
