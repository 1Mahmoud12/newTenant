class PlaceOrderBodyModel {
  String? themeId;
  String? paymentType;
  BillingInfoModel? billingInfo;
  Map<String, dynamic>? couponInfo;
  String? deliveryComment;
  String? userId;
  String? customerId;
  String? paymentComment;
  String? methodId;
  String? shippingId;
  String? price;

  PlaceOrderBodyModel({
    this.themeId,
    this.paymentType,
    this.billingInfo,
    this.couponInfo,
    this.deliveryComment,
    this.userId,
    this.customerId,
    this.paymentComment,
    this.methodId,
    this.shippingId,
    this.price,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['theme_id'] = themeId;
    data['payment_type'] = paymentType;
    if (billingInfo != null) {
      data['billing_info'] = billingInfo!.toJson();
    }
    data['coupon_info'] = couponInfo;
    data['delivery_comment'] = deliveryComment;
    data['user_id'] = userId;
    data['customer_id'] = customerId;
    data['payment_comment'] = paymentComment;
    data['method_id'] = methodId;
    data['shipping_id'] = shippingId;
    data['price'] = price;
    return data;
  }
}

class BillingInfoModel {
  String? billingPostecode;
  String? email;
  String? billingCity;
  String? lastname;
  String? billingCompanyName;
  String? deliveryCity;
  String? deliveryState;
  String? billingAddress;
  String? deliveryPostcode;
  String? billingUserTelephone;
  String? firstname;
  String? deliveryCountry;
  String? billingCountry;
  String? deliveryAddress;
  String? billingState;

  BillingInfoModel({
    this.billingPostecode,
    this.email,
    this.billingCity,
    this.lastname,
    this.billingCompanyName,
    this.deliveryCity,
    this.deliveryState,
    this.billingAddress,
    this.deliveryPostcode,
    this.billingUserTelephone,
    this.firstname,
    this.deliveryCountry,
    this.billingCountry,
    this.deliveryAddress,
    this.billingState,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['billing_postecode'] = billingPostecode;
    data['email'] = email;
    data['billing_city'] = billingCity;
    data['lastname'] = lastname;
    data['billing_company_name'] = billingCompanyName;
    data['delivery_city'] = deliveryCity;
    data['delivery_state'] = deliveryState;
    data['billing_address'] = billingAddress;
    data['delivery_postcode'] = deliveryPostcode;
    data['billing_user_telephone'] = billingUserTelephone;
    data['firstname'] = firstname;
    data['delivery_country'] = deliveryCountry;
    data['billing_country'] = billingCountry;
    data['delivery_address'] = deliveryAddress;
    data['billing_state'] = billingState;
    return data;
  }
}

class PlaceOrderResponseModel {
  int? status;
  String? message;
  PlaceOrderData? data;

  PlaceOrderResponseModel({this.status, this.message, this.data});

  PlaceOrderResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? PlaceOrderData.fromJson(json['data']) : null;
  }
}

class PlaceOrderData {
  int? orderId;
  String? slug;
  String? message;

  PlaceOrderData({this.orderId, this.slug, this.message});

  PlaceOrderData.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    slug = json['slug'];
    message = json['message'];
  }
}
