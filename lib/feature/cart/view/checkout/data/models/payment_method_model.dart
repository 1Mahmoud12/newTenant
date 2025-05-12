class PaymentMethodModel {
  PaymentMethodModel({
    this.message,
    this.status,
    this.code,
    this.data,
  });

  PaymentMethodModel.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    code = json['code'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }

  String? message;
  bool? status;
  num? code;
  List<Data>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['status'] = status;
    map['code'] = code;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Data {
  Data({
    this.id,
    this.shopId,
    this.gateway,
    this.apiKey,
    this.merchantId,
    this.secretKey,
    this.allowedPaymentMethods,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(dynamic json) {
    id = json['id'];
    shopId = json['shop_id'];
    gateway = json['gateway'];
    apiKey = json['api_key'];
    merchantId = json['merchant_id'];
    secretKey = json['secret_key'];
    allowedPaymentMethods = json['allowed_payment_methods'] != null ? json['allowed_payment_methods'].cast<String>() : [];
    if (json['allowed_payment_methods'] != null) {
      allowedPaymentMethods = [];
      json['allowed_payment_methods'].forEach((v) {
        allowedPaymentMethods?.add(v);
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  num? id;
  num? shopId;
  String? gateway;
  String? apiKey;
  String? merchantId;
  String? secretKey;
  List<String>? allowedPaymentMethods;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['shop_id'] = shopId;
    map['gateway'] = gateway;
    map['api_key'] = apiKey;
    map['merchant_id'] = merchantId;
    map['secret_key'] = secretKey;
    map['allowed_payment_methods'] = allowedPaymentMethods;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}
