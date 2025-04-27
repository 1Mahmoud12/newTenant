class ResetPasswordParams {
  final String password;
  final String confirmPassword;

  ResetPasswordParams({
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'password': password,
      'password_confirmation': confirmPassword,
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
