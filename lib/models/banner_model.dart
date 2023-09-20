import 'dart:convert';

BannerModel? bannerModelFromJson(String str) => BannerModel.fromJson(json.decode(str));

String bannerModelToJson(BannerModel? data) => json.encode(data!.toJson());

class BannerModel {
  BannerModel({
    required this.error,
    required this.message,
    required this.banners,
  });

  bool? error;
  String? message;
  List<Banners?>? banners;

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
    error: json["error"],
    message: json["message"],
    banners: json["Banners"] == null ? [] : List<Banners?>.from(json["Banners"]!.map((x) => Banners.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "Banners": banners == null ? [] : List<dynamic>.from(banners!.map((x) => x!.toJson())),
  };
}

class Banners {
  Banners({
    required this.id,
    required this.bannerUrl,
    required this.redirectUrl,
  });

  String? id;
  String? bannerUrl;
  String? redirectUrl;

  factory Banners.fromJson(Map<String, dynamic> json) => Banners(
    id: json["id"],
    bannerUrl: json["banner_url"],
    redirectUrl: json["redirect_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "banner_url": bannerUrl,
    "redirect_url": redirectUrl,
  };
}
