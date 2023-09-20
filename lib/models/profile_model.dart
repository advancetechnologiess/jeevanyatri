// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:math';

import 'package:intl/intl.dart';

import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  ProfileModel({
    required this.error,
    required this.message,
    required this.userProfile,
  });

  bool error;
  String message;
  List<UserProfile> userProfile;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        error: json["error"],
        message: json["message"],
        userProfile: json["UserProfile"] != null
            ? List<UserProfile>.from(
                json["UserProfile"].map((x) => UserProfile.fromJson(x)))
            : <UserProfile>[],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "UserProfile": List<dynamic>.from(userProfile.map((x) => x.toJson())),
      };
}

class UserProfile {
  UserProfile({
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
    required this.isManglik,
    required this.isNRI,
    required this.cast,
    required this.subcast,
    required this.imageUrl,
    required this.bio,
    required this.city,
    required this.state,
    required this.country,
    required this.subscriptionId,
    required this.qualifications,
    required this.education,
    required this.occupation,
    required this.employeedIn,
    required this.annualIncome,
    required this.drinking,
    required this.eating,
    required this.smoking,
    required this.subscription,
    required this.hobbies,
    required this.languages,
    required this.mother_tounge,
    required this.pincode,
    required this.family,
  });

  String id;
  String name;
  String mobile;
  String email;
  String age;
  String gender;
  String userHeight;
  String userWeight;
  String dob;
  String status;
  bool isManglik;
  bool isNRI;
  String religion;
  dynamic cast;
  dynamic subcast;
  dynamic imageUrl;
  String bio;
  dynamic city;
  dynamic state;
  dynamic country;
  dynamic subscriptionId;
  dynamic qualifications;
  dynamic education;
  dynamic occupation;
  dynamic employeedIn;
  dynamic annualIncome;
  dynamic drinking;
  dynamic eating;
  dynamic smoking;
  dynamic subscription;
  List<Hobby> hobbies;
  List<Language> languages;
  String mother_tounge;
  String pincode;
  List<Family> family;

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json["id"],
        name: json["name"] != null ? json["name"] : "",
        mobile: json["mobile"] != null ? json["mobile"] : "",
        email: json["email"] != null ? json["email"] : "",
        age: json["age"] != null ? json["age"] : "",
        gender: json["gender"] != null ? json["gender"] : "",
        userHeight: json["user_height"] != null ? json["user_height"] : "",
        userWeight: json["user_weight"] != null ? json["user_weight"] : "",
        dob: json["DOB"] != null ? json["DOB"] : "",
        status: json["status"] != null ? json["status"] : "",
        isManglik: json["isManglik"] != null ? json["isManglik"] : false,
        isNRI: json["isNRI"] != null ? json["isNRI"] : false,
        religion: json["religion"] != null ? json["religion"] : "Not Specified",
        cast: json["cast"] != null ? json["cast"] : "Not Specified",
        subcast: json["subcast"] != null ? json["subcast"] : "Not Specified",
        imageUrl: json["image_url"] != null ? json["image_url"] : "",
        bio: json["bio"] != null ? json["bio"] : "",
        city: json["city"] != null ? json["city"] : "",
        state: json["state"] != null ? json["state"] : "",
        country: json["country"] != null ? json["country"] : "",
        subscriptionId:
            json["subscription_id"] != null ? json["subscription_id"] : "",
        qualifications:
            json["qualifications"] != null ? json["qualifications"] : "",
        education: json["education"] != null ? json["education"] : "",
        occupation: json["occupation"] != null ? json["occupation"] : "",
        employeedIn: json["employeed_in"] != null ? json["employeed_in"] : "",
        annualIncome:
            json["annual_income"] != null ? json["annual_income"] : "",
        drinking: json["drinking"] != null ? json["drinking"] : "",
        eating: json["eating"] != null ? json["eating"] : "",
        smoking: json["smoking"] != null ? json["smoking"] : "",
        subscription: json["subscription"] != null
            ? Subscription.fromJson(json["subscription"])
            : null,
        hobbies: json["hobbies"] != null
            ? List<Hobby>.from(json["hobbies"].map((x) => Hobby.fromJson(x)))
            : <Hobby>[],
        languages: json["languages"] != null
            ? List<Language>.from(
                json["languages"].map((x) => Language.fromJson(x)))
            : <Language>[],
        mother_tounge:
            json["mother_tounge"] != null ? json["mother_tounge"] : "",
        pincode: json["pincode"] != null ? json["pincode"] : "",
        family: json["family"] != null
            ? List<Family>.from(json["family"].map((x) => Family.fromJson(x)))
            : <Family>[],
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
        "isManglik": isManglik,
        "isNRI": isNRI,
        "religion": religion,
        "cast": cast,
        "subcast": subcast,
        "image_url": imageUrl,
        "bio": bio,
        "city": city,
        "state": state,
        "country": country,
        "subscription_id": subscriptionId,
        "qualifications": qualifications,
        "education": education,
        "occupation": occupation,
        "employeed_in": employeedIn,
        "annual_income": annualIncome,
        "drinking": drinking,
        "eating": eating,
        "smoking": smoking,
        "subscription": subscription.toJson(),
        "hobbies": List<dynamic>.from(hobbies.map((x) => x.toJson())),
        "languages": List<dynamic>.from(languages.map((x) => x.toJson())),
        "mother_tounge": mother_tounge,
        "pincode": mother_tounge,
        "family": List<dynamic>.from(family.map((x) => x.toJson())),
      };
}

class Hobby {
  Hobby({
    required this.hobbyId,
    required this.hobby,
  });

  String hobbyId;
  String hobby;

  factory Hobby.fromJson(Map<String, dynamic> json) => Hobby(
        hobbyId: json["hobby_id"],
        hobby: json["hobby"],
      );

  Map<String, dynamic> toJson() => {
        "hobby_id": hobbyId,
        "hobby": hobby,
      };
}

class Language {
  Language({
    required this.languageId,
    required this.language,
  });

  String languageId;
  String language;

  factory Language.fromJson(Map<String, dynamic> json) => Language(
        languageId: json["language_id"],
        language: json["language"],
      );

  Map<String, dynamic> toJson() => {
        "language_id": languageId,
        "language": language,
      };
}

class Family {
  Family({
    required this.familyId,
    required this.relation,
    required this.name,
  });

  String familyId;
  String relation;
  String name;

  factory Family.fromJson(Map<String, dynamic> json) => Family(
        familyId: json["family_id"],
        relation: json["relation"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "family_id": familyId,
        "relation": relation,
        "name": name,
      };
}

class Subscription {
  Subscription(
      {required this.subscriptionId,
      required this.subscriptionName,
      required this.amount,
      required this.validity,
      required this.profileVisits,
      required this.expirationDate});

  String subscriptionId;
  String subscriptionName;
  String amount;
  String validity;
  String profileVisits;
  String expirationDate;
  bool _isSubscriptionActive = false;

  bool get isSubscriptionActive {
    if (expirationDate != null && expirationDate.isNotEmpty) {
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      String curreentDate = formatter.format(DateTime.now());
      if (formatter
          .parse(expirationDate)
          .isAfter(formatter.parse(curreentDate))) {
        return true;
      }
    }
    return _isSubscriptionActive;
  }

  set isSubscriptionActive(bool isSubscriptionActive) {
    _isSubscriptionActive = isSubscriptionActive;
  }

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        subscriptionId: json["subscription_id"],
        subscriptionName: json["subscription_name"],
        amount: json["amount"],
        validity: json["validity"],
        profileVisits: json["profile_visits"],
        expirationDate: json["expiration_date"],
      );

  Map<String, dynamic> toJson() => {
        "subscription_id": subscriptionId,
        "subscription_name": subscriptionName,
        "amount": amount,
        "validity": validity,
        "profile_visits": profileVisits,
        "expiration_date": expirationDate,
      };
}
