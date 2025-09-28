class VerifyCodeModel {
  String? otp;
  String? phone;
  String? customerId;

  VerifyCodeModel({this.otp, this.phone, this.customerId});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['otp'] = otp;
    if (phone != null) map['phone'] = phone;
    map['customer_id'] = customerId;
    return map;
  }
}
