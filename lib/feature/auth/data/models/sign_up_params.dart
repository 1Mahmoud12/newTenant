import 'package:rova_star/core/utils/constants.dart';

class SignUpParams {
  final String name;
  final String phone;

//  final String password;
  final int termAndCondition;

  SignUpParams({
    required this.name,
    required this.phone,
    //  required this.password,
    required this.termAndCondition,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'phone': phone,
      // 'password': password,
      'agree_terms': termAndCondition,
      'device_name': Constants.deviceId,
      'device_id': Constants.deviceId,
      'fcm_token': Constants.fcmToken,
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
