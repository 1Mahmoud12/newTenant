class SignUpParams {
  final String name;
  final String email;
  final String password;
  final String mobile;
  final String? deviceType;
  final String? googleId;
  final String? facebookId;
  final String? appleId;
  final String? token;
  final String? themeId;

  SignUpParams({
    required this.email,
    required this.password,
    required this.mobile,
    required this.name,
    this.deviceType,
    this.googleId,
    this.facebookId,
    this.appleId,
    this.token,
    this.themeId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'password': password,
      'mobile': mobile,
      'first_name': name,
      'register_type': 'email',
      if (deviceType != null) 'device_type': deviceType,
      if (googleId != null) 'google_id': googleId,
      if (facebookId != null) 'facebook_id': facebookId,
      if (appleId != null) 'apple_id': appleId,
      if (token != null) 'token': token,
      if (themeId != null) 'theme_id': themeId,
    };
  }

  // Factory constructor for email/password registration
  // factory SignUpParams.email({
  //   required String email,
  //   required String name,
  //   required String password,
  //   String? deviceType,
  //   String? token,
  //   String? themeId,
  // }) {
  //   return SignUpParams(
  //     name: name,
  //     email: email,
  //     password: password,
  //     deviceType: deviceType,
  //     token: token,
  //     themeId: themeId ?? '',
  //   );
  // }
  //
  // // Factory constructor for Google sign up
  // factory SignUpParams.google({
  //   required String email,
  //   required String googleId,
  //   required String name,
  //   String? deviceType,
  //   String? token,
  //   String? themeId,
  // }) {
  //   return SignUpParams(
  //     email: email,
  //     password: '', // Empty for social login
  //     googleId: googleId,
  //     deviceType: deviceType,
  //     token: token,
  //     themeId: themeId ?? '',
  //     name: name,
  //   );
  // }
  //
  // // Factory constructor for Facebook sign up
  // factory SignUpParams.facebook({
  //   required String email,
  //   required String facebookId,
  //   String? deviceType,
  //   String? token,
  //   String? themeId,
  //   required String name,
  // }) {
  //   return SignUpParams(
  //     name: name,
  //     email: email,
  //     password: '', // Empty for social login
  //     facebookId: facebookId,
  //     deviceType: deviceType,
  //     token: token,
  //     themeId: themeId ?? '',
  //   );
  // }
  //
  // // Factory constructor for Apple sign up
  // factory SignUpParams.apple({
  //   required String email,
  //   required String appleId,
  //   String? deviceType,
  //   String? token,
  //   String? themeId,
  //   required String name,
  // }) {
  //   return SignUpParams(
  //     name: name,
  //     email: email,
  //     password: '', // Empty for social login
  //     appleId: appleId,
  //     deviceType: deviceType,
  //     token: token,
  //     themeId: themeId ?? '',
  //   );
  // }
}