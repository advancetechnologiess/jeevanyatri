import 'dart:convert';

DiscoverMatchModel discoverMatchModelFromJson(String str) => DiscoverMatchModel.fromJson(json.decode(str));

String discoverMatchModelToJson(DiscoverMatchModel data) => json.encode(data.toJson());

class DiscoverMatchModel {
  DiscoverMatchModel({
    required this.error,
    required this.message,
    required this.discoverMatch,
  });

  bool error;
  String message;
  List<DiscoverMatch> discoverMatch;

  factory DiscoverMatchModel.fromJson(Map<String, dynamic> json) => DiscoverMatchModel(
    error: json["error"],
    message: json["message"],
    discoverMatch: List<DiscoverMatch>.from(json["DiscoverMatch"].map((x) => DiscoverMatch.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "DiscoverMatch": List<dynamic>.from(discoverMatch.map((x) => x.toJson())),
  };
}

class DiscoverMatch {
  DiscoverMatch({
    required this.locationMatch,
    required this.proffessionMatch,
  });

  String locationMatch;
  String proffessionMatch;

  factory DiscoverMatch.fromJson(Map<String, dynamic> json) => DiscoverMatch(
    locationMatch: json["location_match"],
    proffessionMatch: json["proffession_match"],
  );

  Map<String, dynamic> toJson() => {
    "location_match": locationMatch,
    "proffession_match": proffessionMatch,
  };
}
