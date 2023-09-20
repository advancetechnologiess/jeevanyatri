import 'dart:convert';

FamilyDetailsModel familydetailsModelFromJson(String str) =>
    FamilyDetailsModel.fromJson(json.decode(str));

String familydetailsModelToJson(FamilyDetailsModel data) =>
    json.encode(data.toJson());

class FamilyDetailsModel {
  FamilyDetailsModel({
    required this.error,
    required this.message,
    required this.familyDetails,
  });

  bool error;
  String message;
  List<FamilyDetails> familyDetails;

  factory FamilyDetailsModel.fromJson(Map<String, dynamic> json) =>
      FamilyDetailsModel(
        error: json["error"],
        message: json["message"],
        familyDetails: json["FamilyDetails"] != null
            ? List<FamilyDetails>.from(
                json["FamilyDetails"].map((x) => FamilyDetails.fromJson(x)))
            : <FamilyDetails>[],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "FamilyDetails":
            List<dynamic>.from(familyDetails.map((x) => x.toJson())),
      };
}

class FamilyDetails {
  FamilyDetails({
    required this.u_id,
    required this.family_status,
    required this.family_vlaues,
    required this.family_type,
    required this.family_income,
    required this.father_occupation,
    required this.mother_occupation,
    required this.brothers,
    required this.ofWhich_married,
    required this.sisters,
    required this.city,
    required this.state,
    required this.country,
  });

  String u_id;
  String family_status;
  String family_vlaues;
  String family_type;
  String family_income;
  String father_occupation;
  String brothers;
  String sisters;
  String city;
  String state;
  String country;
  String mother_occupation;
  String ofWhich_married;

  factory FamilyDetails.fromJson(Map<String, dynamic> json) => FamilyDetails(
        u_id: json["u_id"],
        family_status: json["family_status"],
        family_vlaues: json["family_vlaues"],
        family_type: json["family_type"],
        family_income: json["family_income"],
        father_occupation: json["father_occupation"],
        mother_occupation: json["mother_occupation"],
        brothers: json["brothers"],
        ofWhich_married: json["ofWhich_married"],
        sisters: json["sisters"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
      );

  Map<String, dynamic> toJson() => {
        "u_id": u_id,
        "family_status": family_status,
        "family_vlaues": family_vlaues,
        "family_type": family_type,
        "family_income": family_income,
        "father_occupation": father_occupation,
        "mother_occupation": mother_occupation,
        "brothers": brothers,
        "ofWhich_married": ofWhich_married,
        "sisters": sisters,
        "city": city,
        "state": state,
        "country": country,
      };
}
