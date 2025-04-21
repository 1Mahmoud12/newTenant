class EditProfileModel {
  bool? status;
  int? code;
  String? message;
  UserData? data;

  EditProfileModel({this.status, this.code, this.message, this.data});

  factory EditProfileModel.fromJson(Map<String, dynamic> json) {
    return EditProfileModel(
      status: json['status'],
      code: json['code'],
      message: json['message'],
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'code': code,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class UserData {
  int? id;
  String? name;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? avatarPath;
  EditProfileAddressModel? addressDefault;
  List<EditProfileAddressModel>? addresses;
  bool? twoFactorAuth;
  bool? pushNotifications;
  bool? desktopNotifications;
  bool? emailNotifications;
  String? language;
  String? appearance;
  String? createdAt;

  UserData({
    this.id,
    this.name,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.avatarPath,
    this.addressDefault,
    this.addresses,
    this.twoFactorAuth,
    this.pushNotifications,
    this.desktopNotifications,
    this.emailNotifications,
    this.language,
    this.appearance,
    this.createdAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      name: json['name'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phone: json['phone'],
      avatarPath: json['avatar_path'],
      addressDefault: json['address_default'] != null ? EditProfileAddressModel.fromJson(json['address_default']) : null,
      addresses: (json['addresses'] as List?)?.map((e) => EditProfileAddressModel.fromJson(e)).toList(),
      twoFactorAuth: json['two_factor_auth'],
      pushNotifications: json['push_notifications'],
      desktopNotifications: json['desktop_notifications'],
      emailNotifications: json['email_notifications'],
      language: json['language'],
      appearance: json['appearance'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'avatar_path': avatarPath,
      'address_default': addressDefault?.toJson(),
      'addresses': addresses?.map((e) => e.toJson()).toList(),
      'two_factor_auth': twoFactorAuth,
      'push_notifications': pushNotifications,
      'desktop_notifications': desktopNotifications,
      'email_notifications': emailNotifications,
      'language': language,
      'appearance': appearance,
      'created_at': createdAt,
    };
  }
}

class EditProfileAddressModel {
  int? id;
  String? name;
  String? phone;
  int? countryId;
  String? country;
  int? stateId;
  String? state;
  int? cityId;
  String? city;
  String? address;
  String? pinCode;
  bool? isDefault;
  String? createdAt;
  String? updateAt;

  EditProfileAddressModel({
    this.id,
    this.name,
    this.phone,
    this.countryId,
    this.country,
    this.stateId,
    this.state,
    this.cityId,
    this.city,
    this.address,
    this.pinCode,
    this.isDefault,
    this.createdAt,
    this.updateAt,
  });

  factory EditProfileAddressModel.fromJson(Map<String, dynamic> json) {
    return EditProfileAddressModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      countryId: json['country_id'],
      country: json['country'],
      stateId: json['state_id'],
      state: json['state'],
      cityId: json['city_id'],
      city: json['city'],
      address: json['address'],
      pinCode: json['pin_code'],
      isDefault: json['is_default'],
      createdAt: json['created_at'],
      updateAt: json['update_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'country_id': countryId,
      'country': country,
      'state_id': stateId,
      'state': state,
      'city_id': cityId,
      'city': city,
      'address': address,
      'pin_code': pinCode,
      'is_default': isDefault,
      'created_at': createdAt,
      'update_at': updateAt,
    };
  }
}
