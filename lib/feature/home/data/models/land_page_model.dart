class LandPageModel {
  int? status;
  String? message;
  LandPageData? data;

  LandPageModel({this.status, this.message, this.data});

  LandPageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? LandPageData.fromJson(json['data']) : null;
  }
}

class LandPageData {
  ThemeJson? themJson;

  LandPageData({this.themJson});

  LandPageData.fromJson(Map<String, dynamic> json) {
    themJson = json['them_json'] != null ? ThemeJson.fromJson(json['them_json']) : null;
  }
}

class ThemeJson {
  HomepageBanner? homepageBanner;

  ThemeJson({this.homepageBanner});

  ThemeJson.fromJson(Map<String, dynamic> json) {
    homepageBanner = json['homepage-banner'] != null ? HomepageBanner.fromJson(json['homepage-banner']) : null;
  }
}

class HomepageBanner {
  String? bgImg;
  String? banner;
  String? titleText;
  String? subText;
  String? btnText;

  HomepageBanner({
    this.bgImg,
    this.banner,
    this.titleText,
    this.subText,
    this.btnText,
  });

  HomepageBanner.fromJson(Map<String, dynamic> json) {
    bgImg = json['homepage-banner-bg-img'];
    banner = json['homepage-banner'];
    titleText = json['homepage-banner-title-text'];
    subText = json['homepage-banner-sub-text'];
    btnText = json['homepage-banner-btn-text'];
  }
}
