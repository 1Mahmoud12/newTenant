class SignUpParams {
  final String name;
  final String email;
  final String phoneNumber;
  final String password;
  final String birthday;
  final String fcmToken;
  final String deviceTypeId;
  final int gender;
  final String userName;
  final int countryCodeId;

  SignUpParams({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.birthday,
    required this.gender,
    required this.userName,
    required this.countryCodeId,
    required this.fcmToken,
    required this.deviceTypeId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'FullName': name,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'password': password,
      'Birthday': birthday,
      'Gender': gender,
      'UserName': userName,
      'CountryCodeId': countryCodeId,
      'FCMToken': fcmToken,
      'DeviceTypeId': deviceTypeId,
    };
  }
}
/*
{
  FullName: string,
  Email: user@example.com,
  Birthday: 2024-10-07T16:24:49.935Z,
  PhoneNumber: string,
  Gender: 1,
  UserName: string,
  Password: stringst,
  CountryCodeId: 0
}
 */
