class RegisterModel {
  final int maxPrice;
  final int status;
  final String message;
  final RegisterData? data;

  RegisterModel({
    required this.maxPrice,
    required this.status,
    required this.message,
    this.data,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      maxPrice: json['max_price'] ?? 0,
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? RegisterData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'max_price': maxPrice,
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }

  bool get isSuccess => status == 1;
}

class RegisterData {
  final int id;
  final String firstName;
  final String? lastName;
  final String email;
  final String type;
  final String mobile;
  final String? firebaseToken;
  final String? deviceType;
  final String registerType;
  final String themeId;
  final int createdBy;
  final int storeId;
  final String updatedAt;
  final String createdAt;
  final String token;
  final String tokenType;
  final String demoField;
  final String name;
  final String address;
  final String postcode;
  final String image;

  RegisterData({
    required this.id,
    required this.firstName,
    this.lastName,
    required this.email,
    required this.type,
    required this.mobile,
    this.firebaseToken,
    this.deviceType,
    required this.registerType,
    required this.themeId,
    required this.createdBy,
    required this.storeId,
    required this.updatedAt,
    required this.createdAt,
    required this.token,
    required this.tokenType,
    required this.demoField,
    required this.name,
    required this.address,
    required this.postcode,
    required this.image,
  });

  factory RegisterData.fromJson(Map<String, dynamic> json) {
    return RegisterData(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'],
      email: json['email'] ?? '',
      type: json['type'] ?? 'customer',
      mobile: json['mobile'] ?? '',
      firebaseToken: json['firebase_token'],
      deviceType: json['device_type'],
      registerType: json['register_type'] ?? 'email',
      themeId: json['theme_id'] ?? '',
      createdBy: json['created_by'] ?? 0,
      storeId: json['store_id'] ?? 0,
      updatedAt: json['updated_at'] ?? '',
      createdAt: json['created_at'] ?? '',
      token: json['token'] ?? '',
      tokenType: json['token_type'] ?? 'Bearer',
      demoField: json['demo_field'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      postcode: json['postcode'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'type': type,
      'mobile': mobile,
      'firebase_token': firebaseToken,
      'device_type': deviceType,
      'register_type': registerType,
      'theme_id': themeId,
      'created_by': createdBy,
      'store_id': storeId,
      'updated_at': updatedAt,
      'created_at': createdAt,
      'token': token,
      'token_type': tokenType,
      'demo_field': demoField,
      'name': name,
      'address': address,
      'postcode': postcode,
      'image': image,
    };
  }

  String get fullName => '$firstName ${lastName ?? ''}'.trim();

  String get authHeader => '$tokenType $token';

  bool get isCustomer => type == 'customer';

  DateTime? get createdAtDateTime {
    try {
      return DateTime.parse(createdAt);
    } catch (e) {
      return null;
    }
  }

  DateTime? get updatedAtDateTime {
    try {
      return DateTime.parse(updatedAt);
    } catch (e) {
      return null;
    }
  }
}