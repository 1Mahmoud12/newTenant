class ResetPasswordParams {
  final int userId;
  final int code;
  final String password;
  final String confirmPassword;

  ResetPasswordParams({
    required this.userId,
    required this.code,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'UserId': userId,
      'OTP': code,
      'NewPassword': password,
      'ConfirmPassword': confirmPassword,
    };
  }
}
/*
{
  "UserId": 0,
  "NewPassword": "stringst",
  "ConfirmPassword": "string",
  "OTP": 0
}
 */
