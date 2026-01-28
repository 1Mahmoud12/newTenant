class CouponInfo {
  int? couponId;
  String? couponName;
  String? couponCode;
  String? couponDiscountType;
  String? couponDiscountNumber;
  String? couponDiscountAmount;
  String? couponFinalAmount;

  CouponInfo.fromJson(Map<String, dynamic> json) {
    couponId = json['coupon_id'];
    couponName = json['coupon_name'];
    couponCode = json['coupon_code'];
    couponDiscountType = json['coupon_discount_type'];
    couponDiscountNumber = json['coupon_discount_number'];
    couponDiscountAmount = json['coupon_discount_amount'];
    couponFinalAmount = json['coupon_final_amount'];
  }

  Map<String, dynamic> toJson() {
    return {
      'coupon_id': couponId,
      'coupon_name': couponName,
      'coupon_code': couponCode,
      'coupon_discount_type': couponDiscountType,
      'coupon_discount_number': couponDiscountNumber,
      'coupon_discount_amount': couponDiscountAmount,
      'coupon_final_amount': couponFinalAmount,
    };
  }
}
class CartProduct {
  int? cartId;
  String? cartCreated;
  int? productId;
  String? image;
  String? name;
  String? originalPrice;
  String? totalOriginalPrice;
  String? discountPrice;
  String? finalPrice;
  int? qty;
  String? variantName;
  int? variantId;

  CartProduct.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    cartCreated = json['cart_created'];
    productId = json['product_id'];
    image = json['image'];
    name = json['name'];
    originalPrice = json['orignal_price'];
    totalOriginalPrice = json['total_orignal_price'];
    discountPrice = json['discount_price'];
    finalPrice = json['final_price'];
    qty = json['qty'];
    variantName = json['variant_name'];
    variantId = json['variant_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'cart_id': cartId,
      'cart_created': cartCreated,
      'product_id': productId,
      'image': image,
      'name': name,
      'orignal_price': originalPrice,
      'total_orignal_price': totalOriginalPrice,
      'discount_price': discountPrice,
      'final_price': finalPrice,
      'qty': qty,
      'variant_name': variantName,
      'variant_id': variantId,
    };
  }
}
class CartData {
  List<CartProduct>? productList;
  int? subTotal;
  int? cartTotalProduct;
  int? cartTotalQty;
  String? finalPrice;
  String? totalSubPrice;
  CouponInfo? couponInfo;

  CartData({
    this.productList,
    this.subTotal,
    this.cartTotalProduct,
    this.cartTotalQty,
    this.finalPrice,
    this.totalSubPrice,
    this.couponInfo,
  });

  CartData.fromJson(Map<String, dynamic> json) {
    if (json['product_list'] != null) {
      productList = <CartProduct>[];
      json['product_list'].forEach((v) {
        productList!.add(CartProduct.fromJson(v));
      });
    }
    subTotal = json['sub_total'];
    cartTotalProduct = json['cart_total_product'];
    cartTotalQty = json['cart_total_qty'];
    finalPrice = json['final_price'];
    totalSubPrice = json['total_sub_price'];
    couponInfo = json['coupon_info'] != null
        ? CouponInfo.fromJson(json['coupon_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'product_list': productList?.map((v) => v.toJson()).toList(),
      'sub_total': subTotal,
      'cart_total_product': cartTotalProduct,
      'cart_total_qty': cartTotalQty,
      'final_price': finalPrice,
      'total_sub_price': totalSubPrice,
      'coupon_info': couponInfo?.toJson(),
    };
  }
}
class CartModel {
  int? status;
  String? message;
  CartData? data;

  CartModel({this.status, this.message, this.data});

  CartModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? CartData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}
