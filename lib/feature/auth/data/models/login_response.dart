class LoginResponse {
  final int maxPrice;
  final int status;
  final String? message;
  final UserData? data;

  LoginResponse({
    required this.maxPrice,
    required this.status,
    this.message,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    dynamic statusData = json['status'];
    int statusIdx = 0;
    if (statusData is bool) {
      statusIdx = statusData ? 1 : 0;
    } else if (statusData is int) {
      statusIdx = statusData;
    }

    return LoginResponse(
      maxPrice: json['max_price'] ?? 0,
      status: statusIdx,
      message: json['message'],
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
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

class UserData {
  final int id;
  final String firstName;
  final String? lastName;
  final String image;
  final String name;
  final String email;
  final String mobile;
  final String companyName;
  final String countryId;
  final String stateId;
  final String city;
  final String address;
  final String postcode;
  final String token;
  final String tokenType;

  UserData({
    required this.id,
    required this.firstName,
    this.lastName,
    required this.image,
    required this.name,
    required this.email,
    required this.mobile,
    required this.companyName,
    required this.countryId,
    required this.stateId,
    required this.city,
    required this.address,
    required this.postcode,
    required this.token,
    required this.tokenType,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'],
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      companyName: json['company_name'] ?? '',
      countryId: json['country_id'] ?? '',
      stateId: json['state_id'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      postcode: json['postcode'] ?? '',
      token: json['token'] ?? '',
      tokenType: json['token_type'] ?? 'Bearer',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'image': image,
      'name': name,
      'email': email,
      'mobile': mobile,
      'company_name': companyName,
      'country_id': countryId,
      'state_id': stateId,
      'city': city,
      'address': address,
      'postcode': postcode,
      'token': token,
      'token_type': tokenType,
    };
  }

  String get fullName => '$firstName ${lastName ?? ''}'.trim();

  String get authHeader => '$tokenType $token';
}
