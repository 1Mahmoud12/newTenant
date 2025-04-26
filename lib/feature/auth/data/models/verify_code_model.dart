class VerifyCodeModel {
  String? otp;
  String? customerId;

  VerifyCodeModel({this.otp, this.customerId});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['otp'] = otp;
    map['customer_id'] = customerId;
    return map;
  }
}
