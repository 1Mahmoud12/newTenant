class VerifyCodeModel {
  String? otp;
  String? phone;
  int? countryCodeId;

  VerifyCodeModel({this.otp, this.phone, this.countryCodeId});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['OTP'] = otp;
    map['Phone'] = phone;
    map['CountryCodeId'] = countryCodeId;
    return map;
  }
}
