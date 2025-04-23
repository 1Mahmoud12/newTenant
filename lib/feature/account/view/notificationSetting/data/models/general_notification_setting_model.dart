class GeneralNotificationModel {
  bool? status;
  int? code;
  String? message;
  Data? data;

  GeneralNotificationModel({this.status, this.code, this.message, this.data});

  GeneralNotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  bool? twoFactorAuth;
  bool? pushNotifications;
  bool? desktopNotifications;
  bool? emailNotifications;
  String? language;
  String? appearance;

  Data({
    this.twoFactorAuth,
    this.pushNotifications,
    this.desktopNotifications,
    this.emailNotifications,
    this.language,
    this.appearance,
  });

  Data.fromJson(Map<String, dynamic> json) {
    twoFactorAuth = json['two_factor_auth'];
    pushNotifications = json['push_notifications'];
    desktopNotifications = json['desktop_notifications'];
    emailNotifications = json['email_notifications'];
    language = json['language'];
    appearance = json['appearance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['two_factor_auth'] = twoFactorAuth;
    data['push_notifications'] = pushNotifications;
    data['desktop_notifications'] = desktopNotifications;
    data['email_notifications'] = emailNotifications;
    data['language'] = language;
    data['appearance'] = appearance;
    return data;
  }
}
