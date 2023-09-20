import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:meet_me/models/banner_model.dart';
import 'package:meet_me/models/discover_match_model.dart';
import 'package:meet_me/models/educations_model.dart';
import 'package:meet_me/models/family_details_model.dart';
import 'package:meet_me/models/interest_status_model.dart';
import 'package:meet_me/models/preference_model.dart';
import 'package:meet_me/models/profile_model.dart';
import 'package:meet_me/models/received_req_model.dart';
import 'package:meet_me/models/shortlist_model.dart';
import 'package:meet_me/models/subscription_model.dart';
import 'package:meet_me/models/users_match_model.dart';

import '../models/login_model.dart';
import '../models/result_model.dart';

class API_Manager {
  // static String base_url = "https://sid-clinic.herokuapp.com/";
  static String base_url =
      "https://api.jeevanyatri.com/JeevanYatri/api/Api.php?apicall=";

  static Future<LoginModel> contactExist(String mobile) async {
    final response = await http
        .post(Uri.parse("${base_url}contactExist"), body: {"contact": mobile});

    debugPrint("contactExist : ${response.body}");
    return loginModelFromJson(response.body);
  }

  static Future<LoginModel> LoginUser(String mobile) async {
    final response = await http
        .post(Uri.parse("${base_url}Login"), body: {"Mobile": mobile});

    debugPrint("LOGIN : ${response.body}");
    return loginModelFromJson(response.body);
  }

  static Future<LoginModel> insertUser(
    String name,
    String mobile,
    String email,
    String age,
    String gender,
    String height,
    String weight,
    String dob,
    String status,
    String isManglik,
    String isNRI,
    String religion,
    String cast,
    String subcast,
    String bio,
    String city,
    String state,
    String country,
    String expireDate,
    String qualification,
    String education,
    String occupation,
    String job,
    String income,
    String mothertounge,
    String pincode,
  ) async {
    final response = await http.post(Uri.parse("${base_url}insertUser"), body: {
      "Name": name,
      "Mobile": mobile,
      "Email": email,
      "Age": age,
      "gender": gender,
      "uHeight": height,
      "uWeight": weight,
      "dob": dob,
      "status": status,
      "isManglik": isManglik,
      "isNRI": isNRI,
      "religion": religion,
      "cast": cast,
      "subcast": subcast,
      "Bio": bio,
      "city": city,
      "state": state,
      "country": country,
      "expireDate": expireDate,
      "qualification": qualification,
      "education": education,
      "occupation": occupation,
      "employeed_in": job,
      "income": income,
      "mother_tounge": mothertounge,
      "pincode": pincode,
    });

    debugPrint("insertUser : ${response.body}");
    return loginModelFromJson(response.body);
  }

  static Future<LoginModel> insertUserWithImage(
    String name,
    String mobile,
    String email,
    String age,
    String gender,
    String height,
    String weight,
    String dob,
    String status,
    String isManglik,
    String isNRI,
    String religion,
    String cast,
    String subcast,
    String image,
    String imgname,
    String bio,
    String city,
    String state,
    String country,
    String expireDate,
    String qualification,
    String education,
    String occupation,
    String job,
    String income,
    String mothertounge,
    String pincode,
  ) async {
    final response = await http.post(Uri.parse("${base_url}insertUser"), body: {
      "Name": name,
      "Mobile": mobile,
      "Email": email,
      "Age": age,
      "gender": gender,
      "uHeight": height,
      "uWeight": weight,
      "dob": dob,
      "status": status,
      "isManglik": isManglik,
      "isNRI": isNRI,
      "religion": religion,
      "cast": cast,
      "subcast": subcast,
      "image": image,
      "image_name": imgname,
      "Bio": bio,
      "city": city,
      "state": state,
      "country": country,
      "expireDate": expireDate,
      "qualification": qualification,
      "education": education,
      "occupation": occupation,
      "employeed_in": job,
      "income": income,
      "mother_tounge": mothertounge,
      "pincode": pincode,
    });

    debugPrint("insertUser : ${response.body}");
    return loginModelFromJson(response.body);
  }

  static Future<ProfileModel> FetchUserProfile(String id) async {
    final response =
        await http.post(Uri.parse("${base_url}FetchUserProfile"), body: {
      "u_id": id,
    });
    debugPrint("FetchUserProfile : ${response.body}");
    return profileModelFromJson(response.body);
  }

  static Future<ResultModel> updatePartnerPrefrence(
      String u_id,
      String age_from,
      String age_to,
      String height_from,
      String height_to,
      String qualifin,
      String edu,
      String occu,
      String isManglik,
      String isNRI,
      String religion,
      String cast,
      String subcast,
      String city,
      String state,
      String country,
      String income) async {
    final response =
        await http.post(Uri.parse("${base_url}UpdatePartnerPrefrence"), body: {
      "u_id": u_id,
      "age_from": age_from,
      "age_to": age_to,
      "height_from": height_from,
      "height_to": height_to,
      "qualifin": qualifin,
      "edu": edu,
      "occu": occu,
      "isManglik": isManglik,
      "isNRI": isNRI,
      "religion": religion,
      "cast": cast,
      "subcast": subcast,
      "city": city,
      "state": state,
      "country": country,
      "income": income,
    });

    return resultModelFromJson(response.body);
  }

  static Future<ResultModel> InsertFamilyDetails(
    String u_id,
    String family_status,
    String family_vlaues,
    String family_type,
    String family_income,
    String father_occupation,
    String mother_occupation,
    String brothers,
    String ofWhich_married,
    String sisters,
    String country,
    String state,
    String city,
  ) async {
    final response =
        await http.post(Uri.parse("${base_url}insertUserFamilyDetails"), body: {
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
      "country": country,
      "state": state,
      "city": city
    });

    return resultModelFromJson(response.body);
  }

  static Future<ResultModel> UpdateFamilyDetails(
    String u_id,
    String family_status,
    String family_vlaues,
    String family_type,
    String family_income,
    String father_occupation,
    String mother_occupation,
    String brothers,
    String ofWhich_married,
    String sisters,
    String country,
    String state,
    String city,
  ) async {
    final response =
        await http.post(Uri.parse("${base_url}updateUserFamilyDetails"), body: {
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
      "country": country,
      "state": state,
      "city": city
    });

    return resultModelFromJson(response.body);
  }

  static Future<FamilyDetailsModel> FetchUserFamilyDetails(String id) async {
    final response =
        await http.post(Uri.parse("${base_url}fetchUserFamilyDetails"), body: {
      "u_id": id,
    });

    return familydetailsModelFromJson(response.body);
  }

  static Future<PrefrenceModel> FetchUserPrefrence(String id) async {
    final response =
        await http.post(Uri.parse("${base_url}FetchUserPrefrence"), body: {
      "u_id": id,
    });

    return prefrenceModelFromJson(response.body);
  }

  static Future<ResultModel> updateProfilePicture(
      String image, String image_name, String id) async {
    final response = await http.post(
        Uri.parse("${base_url}updateProfilePicture"),
        body: {"image": image, "image_name": image_name, "UserId": id});

    return resultModelFromJson(response.body);
  }

  static Future<ResultModel> UpdateUserHabits(
      String u_id, String drinking, String eating, String smoking) async {
    final response = await http.post(Uri.parse("${base_url}UpdateUserHabits"),
        body: {
          "u_id": u_id,
          "drinking": drinking,
          "eating": eating,
          "smoking": smoking
        });

    return resultModelFromJson(response.body);
  }

  static Future<ResultModel> insertUserHobbies(
      String u_id, String hobby) async {
    final response = await http.post(Uri.parse("${base_url}insertUserHobbies"),
        body: {"u_id": u_id, "hobby": hobby});

    return resultModelFromJson(response.body);
  }

  static Future<ResultModel> insertUserLanguage(
      String u_id, String language) async {
    final response = await http.post(Uri.parse("${base_url}insertUserLanguage"),
        body: {"u_id": u_id, "language": language});

    return resultModelFromJson(response.body);
  }

  static Future<ResultModel> insertUserFamily(
      String u_id, String relation, String name) async {
    final response = await http.post(Uri.parse("${base_url}insertUserFamily"),
        body: {"u_id": u_id, "relation": relation, "name": name});

    return resultModelFromJson(response.body);
  }

  static Future<ResultModel> removeFamily(String id) async {
    final response =
        await http.post(Uri.parse("${base_url}RemoveFamily"), body: {"Id": id});

    return resultModelFromJson(response.body);
  }

  static Future<ResultModel> removeLanguage(String id) async {
    final response = await http
        .post(Uri.parse("${base_url}RemoveLanguage"), body: {"Id": id});
    return resultModelFromJson(response.body);
  }

  static Future<ResultModel> removeHobby(String id) async {
    final response =
        await http.post(Uri.parse("${base_url}RemoveHobby"), body: {"Id": id});
    return resultModelFromJson(response.body);
  }

  static Future<UserMatchModel> fetchUsersMatch(
      String gender, String userId) async {
    final response = await http.post(Uri.parse("${base_url}FetchUsersMatch"),
        body: {"gender": gender, "userId": userId});

    return userMatchModelFromJson(response.body);
  }

  static Future<UserMatchModel> filterUsers(
      String gender,
      String ageFrom,
      String ageTo,
      String status,
      String religion,
      String cast,
      String city,
      String income) async {
    final response =
        await http.post(Uri.parse("${base_url}FilterUsers"), body: {
      "gender": gender,
      "ageFrom": ageFrom,
      "ageTo": ageTo,
      "status": status,
      "religion": religion,
      "Cast": cast,
      "City": city,
      "income": income
    });

    return userMatchModelFromJson(response.body);
  }

  static Future<SubscriptionPlansModel> fetchSubscriptionPlans() async {
    final response =
        await http.get(Uri.parse("${base_url}fetchSubscriptionPlans"));

    return subscriptionPlansModelFromJson(response.body);
  }

  static Future<ResultModel> updateUserSubscription(
      String planId, String expireDate, String userId) async {
    final response = await http.post(
        Uri.parse("${base_url}updateUserSubscription"),
        body: {"planId": planId, "expireDate": expireDate, "userId": userId});

    return resultModelFromJson(response.body);
  }

  static Future<ResultModel> insertUserRequest(
      String u_id, String requestedId) async {
    final response = await http.post(Uri.parse("${base_url}insertUserRequest"),
        body: {"u_id": u_id, "requestedId": requestedId});

    return resultModelFromJson(response.body);
  }

  static Future<RecievedRequestModel> fetchUserReceivedRequest(
      String userId) async {
    final response = await http.post(
        Uri.parse("${base_url}fetchUserReceivedRequest"),
        body: {"u_id": userId});

    return recievedRequestModelFromJson(response.body);
  }

  static Future<RecievedRequestModel> fetchUserAcceptedRequest(
      String userId) async {
    final response = await http.post(
        Uri.parse("${base_url}fetchUserAcceptedRequest"),
        body: {"u_id": userId});

    return recievedRequestModelFromJson(response.body);
  }

  static Future<SubscriptionPlansModel> fetchSubscriptionPlansDetails(
      String planId) async {
    final response = await http.post(
        Uri.parse("${base_url}fetchSubscriptionPlansDetails"),
        body: {"planId": planId});

    return subscriptionPlansModelFromJson(response.body);
  }

  static Future<ResultModel> acceptUserRequest(String requestId) async {
    final response = await http.post(Uri.parse("${base_url}acceptUserRequest"),
        body: {"requestId": requestId});

    return resultModelFromJson(response.body);
  }

  static Future<ResultModel> insertUsersWishlist(
      String u_id, String wishId) async {
    final response = await http.post(
        Uri.parse("${base_url}insertUsersWishlist"),
        body: {"u_id": u_id, "wishId": wishId});

    return resultModelFromJson(response.body);
  }

  static Future<ShortlistModel> fetchShortlistedUsers(String userId) async {
    final response = await http.post(
        Uri.parse("${base_url}fetchShortlistedUsers"),
        body: {"u_id": userId});

    return shortlistModelFromJson(response.body);
  }

  static Future<ResultModel> removeWishlistUser(
      String u_id, String wishId) async {
    final response = await http.post(Uri.parse("${base_url}RemoveWishlistUser"),
        body: {"u_id": u_id, "wishId": wishId});

    return resultModelFromJson(response.body);
  }

  static Future<ShortlistModel> fetchShortMembers(String userId) async {
    final response = await http.post(Uri.parse("${base_url}fetchShortMembers"),
        body: {"u_id": userId});

    return shortlistModelFromJson(response.body);
  }

  static Future<ResultModel> addUsertoken(String usrId, String token) async {
    final response = await http.post(Uri.parse("${base_url}addUsertoken"),
        body: {"usrId": usrId, "token": token});

    return resultModelFromJson(response.body);
  }

  static Future<ResultModel> sendUserSinglePush(
      String title, String message, String type, String id) async {
    final response = await http.post(Uri.parse("${base_url}sendUserSinglePush"),
        body: {"title": title, "message": message, "type": type, "id": id});

    return resultModelFromJson(response.body);
  }

  static Future<InterestStatusModel> getInterestStatus(
      String userId, String reqId) async {
    final response = await http.post(Uri.parse("${base_url}getInterestStatus"),
        body: {"uId": userId, "rId": reqId});

    return interestStatusModelFromJson(response.body);
  }

  static Future<DiscoverMatchModel> discoverMatch(
      String city, String profession, String userId) async {
    final response = await http.post(Uri.parse("${base_url}discoverMatch"),
        body: {"city": city, "profession": profession, "uId": userId});

    return discoverMatchModelFromJson(response.body);
  }

  static Future<UserMatchModel> discoverLocationMatch(
      String city, String userId) async {
    final response = await http.post(
        Uri.parse("${base_url}discoverLocationMatch"),
        body: {"city": city, "uId": userId});

    return userMatchModelFromJson(response.body);
  }

  static Future<UserMatchModel> discoverProfessionMatch(
      String profession, String userId) async {
    final response = await http.post(
        Uri.parse("${base_url}discoverProfessionMatch"),
        body: {"profession": profession, "uId": userId});

    return userMatchModelFromJson(response.body);
  }

  static Future<ResultModel> updateProfile(
      String name,
      String email,
      String age,
      String gender,
      String height,
      String weight,
      String dob,
      String status,
      String isManglik,
      String isNRI,
      String religion,
      String cast,
      String subcast,
      String bio,
      String city,
      String state,
      String country,
      String id,
      String qualification,
      String education,
      String occupation,
      String job,
      String income) async {
    final response =
        await http.post(Uri.parse("${base_url}updateProfile"), body: {
      "Name": name,
      "Email": email,
      "Age": age,
      "gender": gender,
      "uHeight": height,
      "uWeight": weight,
      "dob": dob,
      "status": status,
      "isManglik": isManglik,
      "isNRI": isNRI,
      "religion": religion,
      "cast": cast,
      "subcast": subcast,
      "Bio": bio,
      "city": city,
      "state": state,
      "country": country,
      "UserId": id,
      "qualification": qualification,
      "education": education,
      "occupation": occupation,
      "job": job,
      "income": income
    });

    return resultModelFromJson(response.body);
  }

  static Future<EducationModel> fetchEducationsList() async {
    final response =
        await http.get(Uri.parse("${base_url}fetchEducationsList"));

    debugPrint("Educations : ${response.body}");
    return educationModelFromJson(response.body);
  }

  static Future<BannerModel?> fetchBanners() async {
    final response = await http.get(Uri.parse("${base_url}fetchBanners"));

    return bannerModelFromJson(response.body);
  }
}
