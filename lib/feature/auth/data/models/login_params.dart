import 'package:rova_star/core/utils/constants.dart';

class LoginParams {
  final String phone;
  final String password;

  LoginParams({
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'phone': phone,
      'password': password,
      'device_name': Constants.deviceId,
      'device_id': Constants.deviceId,
      'fcm_token': Constants.fcmToken,
    };
  }
}
