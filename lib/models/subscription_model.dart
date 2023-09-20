// To parse this JSON data, do
//
//     final subscriptionPlansModel = subscriptionPlansModelFromJson(jsonString);
import 'dart:convert';

SubscriptionPlansModel subscriptionPlansModelFromJson(String str) => SubscriptionPlansModel.fromJson(json.decode(str));

String subscriptionPlansModelToJson(SubscriptionPlansModel data) => json.encode(data.toJson());

class SubscriptionPlansModel {
  SubscriptionPlansModel({
    required this.error,
    required this.message,
    required this.subscriptionPlans,
  });

  bool error;
  String message;
  List<SubscriptionPlan> subscriptionPlans;

  factory SubscriptionPlansModel.fromJson(Map<String, dynamic> json) => SubscriptionPlansModel(
    error: json["error"],
    message: json["message"],
    subscriptionPlans: json["SubscriptionPlans"] != null ? List<SubscriptionPlan>.from(json["SubscriptionPlans"].map((x) => SubscriptionPlan.fromJson(x)))
    :<SubscriptionPlan>[],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "SubscriptionPlans": List<dynamic>.from(subscriptionPlans.map((x) => x.toJson())),
  };
}

class SubscriptionPlan {
  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.amount,
    required this.validity,
    required this.profileVisits,
  });

  String id;
  String name;
  String amount;
  String validity;
  String profileVisits;

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) => SubscriptionPlan(
    id: json["id"],
    name: json["name"],
    amount: json["amount"],
    validity: json["validity"],
    profileVisits: json["profile_visits"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "amount": amount,
    "validity": validity,
    "profile_visits": profileVisits,
  };
}
