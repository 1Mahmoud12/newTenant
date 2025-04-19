class RegisterModel {
  bool? status;
  int? code;
  String? message;
  Data? data;

  RegisterModel({this.status, this.code, this.message, this.data});

  RegisterModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? name;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? avatarPath;
  bool? twoFactorAuth;
  bool? pushNotifications;
  bool? desktopNotifications;
  bool? emailNotifications;
  String? language;
  String? appearance;
  String? createdAt;
  String? type;
  String? token;

  Data({
    this.id,
    this.name,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.avatarPath,
    this.twoFactorAuth,
    this.pushNotifications,
    this.desktopNotifications,
    this.emailNotifications,
    this.language,
    this.appearance,
    this.createdAt,
    this.type,
    this.token,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    avatarPath = json['avatar_path'];
    twoFactorAuth = json['two_factor_auth'];
    pushNotifications = json['push_notifications'];
    desktopNotifications = json['desktop_notifications'];
    emailNotifications = json['email_notifications'];
    language = json['language'];
    appearance = json['appearance'];
    createdAt = json['created_at'];
    type = json['type'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['avatar_path'] = avatarPath;
    data['two_factor_auth'] = twoFactorAuth;
    data['push_notifications'] = pushNotifications;
    data['desktop_notifications'] = desktopNotifications;
    data['email_notifications'] = emailNotifications;
    data['language'] = language;
    data['appearance'] = appearance;
    data['created_at'] = createdAt;
    data['type'] = type;
    data['token'] = token;
    return data;
  }
}
