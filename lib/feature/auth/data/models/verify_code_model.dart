class VerifyCodeModel {
  String? otp;
  String? phone;

  VerifyCodeModel({this.otp, this.phone});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['otp'] = otp;
    map['phone'] = phone;
    return map;
  }
}
