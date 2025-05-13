class PaymentCreditModel {
  PaymentCreditModel({
    this.id,
    this.status,
    this.amount,
    this.currency,
    this.description,
    this.logoUrl,
    this.amountFormat,
    this.url,
    this.callbackUrl,
    this.expiredAt,
    this.createdAt,
    this.updatedAt,
    this.backUrl,
    this.successUrl,
    this.metadata,
    this.payments,
  });

  PaymentCreditModel.fromJson(dynamic json) {
    id = json['id'];
    status = json['status'];
    amount = json['amount'];
    currency = json['currency'];
    description = json['description'];
    logoUrl = json['logo_url'];
    amountFormat = json['amount_format'];
    url = json['url'];
    callbackUrl = json['callback_url'];
    expiredAt = json['expired_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    backUrl = json['back_url'];
    successUrl = json['success_url'];
    metadata = json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
    // if (json['payments'] != null) {
    //   payments = [];
    //   json['payments'].forEach((v) {
    //     payments?.add(Dynamic.fromJson(v));
    //   });
    // }
  }

  String? id;
  String? status;
  num? amount;
  String? currency;
  String? description;
  String? logoUrl;
  String? amountFormat;
  String? url;
  String? callbackUrl;
  dynamic expiredAt;
  String? createdAt;
  String? updatedAt;
  dynamic backUrl;
  dynamic successUrl;
  Metadata? metadata;
  List<dynamic>? payments;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['status'] = status;
    map['amount'] = amount;
    map['currency'] = currency;
    map['description'] = description;
    map['logo_url'] = logoUrl;
    map['amount_format'] = amountFormat;
    map['url'] = url;
    map['callback_url'] = callbackUrl;
    map['expired_at'] = expiredAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['back_url'] = backUrl;
    map['success_url'] = successUrl;
    if (metadata != null) {
      map['metadata'] = metadata?.toJson();
    }
    if (payments != null) {
      map['payments'] = payments?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Metadata {
  Metadata({
    this.orderId,
  });

  Metadata.fromJson(dynamic json) {
    orderId = json['order_id'];
  }

  String? orderId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['order_id'] = orderId;
    return map;
  }
}
