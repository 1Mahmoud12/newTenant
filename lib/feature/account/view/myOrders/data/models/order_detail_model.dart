class OrderDetailModel {
  int? maxPrice;
  int? status;
  String? message;
  OrderDetailData? data;

  OrderDetailModel({
    this.maxPrice,
    this.status,
    this.message,
    this.data,
  });

  OrderDetailModel.fromJson(Map<String, dynamic> json) {
    maxPrice = json['max_price'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? OrderDetailData.fromJson(json['data']) : null;
  }
}

class OrderDetailData {
  int? id;
  int? isGuest;
  String? orderId;
  String? deliveryDate;
  int? orderRewardPoint;
  int? returnPrice;
  String? returnStatusMessage;
  String? returnDate;
  String? paymentComment;
  String? additionalNote;
  String? orderStatusText;
  int? orderStatus;
  String? orderStatusMessage;
  String? paymentStatus;
  String? paymentReceipt;
  int? deliveryboyId;
  int? couponPrice;
  List<ProductItem>? product;
  int? isReview;
  BillingInformations? billingInformations;
  DeliveryInformations? deliveryInformations;
  String? paymentType;
  String? payment;
  String? delivery;
  String? deliveredCharge;
  String? couponInfo;
  Tax? tax;
  String? subTotal;
  String? finalPrice;
  String? taxPrice;
  String? taxName;
  int? taxRate;
  String? taxType;
  int? taxId;

  OrderDetailData({
    this.id,
    this.isGuest,
    this.orderId,
    this.deliveryDate,
    this.orderRewardPoint,
    this.returnPrice,
    this.returnStatusMessage,
    this.returnDate,
    this.paymentComment,
    this.additionalNote,
    this.orderStatusText,
    this.orderStatus,
    this.orderStatusMessage,
    this.paymentStatus,
    this.paymentReceipt,
    this.deliveryboyId,
    this.couponPrice,
    this.product,
    this.isReview,
    this.billingInformations,
    this.deliveryInformations,
    this.paymentType,
    this.payment,
    this.delivery,
    this.deliveredCharge,
    this.couponInfo,
    this.tax,
    this.subTotal,
    this.finalPrice,
    this.taxPrice,
    this.taxName,
    this.taxRate,
    this.taxType,
    this.taxId,
  });

  OrderDetailData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isGuest = json['is_guest'];
    orderId = json['order_id'];
    deliveryDate = json['delivery_date'];
    orderRewardPoint = json['order_reward_point'];
    returnPrice = json['return_price'];
    returnStatusMessage = json['return_status_message'];
    returnDate = json['return_date'];
    paymentComment = json['payment_comment'];
    additionalNote = json['additional_note'];
    orderStatusText = json['order_status_text'];
    orderStatus = json['order_status'];
    orderStatusMessage = json['order_status_message'];
    paymentStatus = json['payment_status'];
    paymentReceipt = json['payment_receipt'];
    deliveryboyId = json['deliveryboy_id'];
    couponPrice = json['coupon_price'];
    if (json['product'] != null) {
      product = <ProductItem>[];
      json['product'].forEach((v) {
        product!.add(ProductItem.fromJson(v));
      });
    }
    isReview = json['is_review'];
    billingInformations = json['billing_informations'] != null ? BillingInformations.fromJson(json['billing_informations']) : null;
    deliveryInformations = json['delivery_informations'] != null ? DeliveryInformations.fromJson(json['delivery_informations']) : null;
    paymentType = json['paymnet_type'];
    payment = json['paymnet'];
    delivery = json['delivery'];
    deliveredCharge = json['delivered_charge'];
    couponInfo = json['coupon_info'];
    tax = json['tax'] != null ? Tax.fromJson(json['tax']) : null;
    subTotal = json['sub_total'];
    finalPrice = json['final_price'];
    taxPrice = json['tax_price'];
    taxName = json['tax_name'];
    taxRate = json['tax_rate'];
    taxType = json['tax_type'];
    taxId = json['tax_id'];
  }
}

class ProductItem {
  int? productId;
  String? image;
  String? name;
  String? orignalPrice;
  String? totalOrignalPrice;
  String? finalPrice;
  int? qty;
  int? variantId;
  String? variantName;
  int? returnStatus; // renamed from return to prevent keyword conflict

  ProductItem({
    this.productId,
    this.image,
    this.name,
    this.orignalPrice,
    this.totalOrignalPrice,
    this.finalPrice,
    this.qty,
    this.variantId,
    this.variantName,
    this.returnStatus,
  });

  ProductItem.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    image = json['image'];
    name = json['name'];
    orignalPrice = json['orignal_price'];
    totalOrignalPrice = json['total_orignal_price'];
    finalPrice = json['final_price'];
    qty = json['qty'];
    variantId = json['variant_id'];
    variantName = json['variant_name'];
    returnStatus = json['return'];
  }
}

class BillingInformations {
  String? name;
  String? address;
  String? state;
  String? country;
  String? city;
  String? postCode;
  String? email;
  String? phone;

  BillingInformations({
    this.name,
    this.address,
    this.state,
    this.country,
    this.city,
    this.postCode,
    this.email,
    this.phone,
  });

  BillingInformations.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    state = json['state'];
    country = json['country'];
    city = json['city'];
    postCode = json['post_code'];
    email = json['email'];
    phone = json['phone'];
  }
}

class DeliveryInformations {
  String? name;
  String? address;
  String? state;
  String? country;
  String? city;
  String? postCode;
  String? email;
  String? phone;

  DeliveryInformations({
    this.name,
    this.address,
    this.state,
    this.country,
    this.city,
    this.postCode,
    this.email,
    this.phone,
  });

  DeliveryInformations.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    state = json['state'];
    country = json['country'];
    city = json['city'];
    postCode = json['post_code'];
    email = json['email'];
    phone = json['phone'];
  }
}

class Tax {
  int? amountString; // It was "amountstring": 0 in json

  Tax({this.amountString});

  Tax.fromJson(Map<String, dynamic> json) {
    amountString = json['amountstring'];
  }
}
