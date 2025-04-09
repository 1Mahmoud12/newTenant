class LoginParams {
  final String phoneNumber;
  final String password;
  final String fcmToken;
  final String deviceTypeId;
  final int countryCodeId;

  LoginParams({
    required this.phoneNumber,
    required this.password,
    required this.countryCodeId,
    required this.fcmToken,
    required this.deviceTypeId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'PhoneNumber': phoneNumber,
      'Password': password,
      'CountryCodeId': countryCodeId,
      'FCMToken': fcmToken,
      'DeviceTypeId': deviceTypeId,
    };
  }
}
