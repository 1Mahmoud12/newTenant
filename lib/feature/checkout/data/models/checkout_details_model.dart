class CheckoutDetailsModel {
  bool? status;
  int? code;
  String? message;
  int? subTotalPrice;
  List<CheckoutData>? data;

  CheckoutDetailsModel({
    this.status,
    this.code,
    this.message,
    this.subTotalPrice,
    this.data,
  });

  CheckoutDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    subTotalPrice = json['subTotalPrice'];
    if (json['data'] != null) {
      data = <CheckoutData>[];
      json['data'].forEach((v) {
        data!.add(CheckoutData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['message'] = message;
    data['subTotalPrice'] = subTotalPrice;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CheckoutData {
  int? id;
  String? product;
  String? size;
  String? color;
  String? colorCode;
  int? priceForProduct;
  String? productImagePath;
  String? productThumbnailPath;
  int? quantity;
  int? price;
  String? createdAt;
  String? updatedAt;

  CheckoutData({
    this.id,
    this.product,
    this.size,
    this.color,
    this.colorCode,
    this.priceForProduct,
    this.productImagePath,
    this.productThumbnailPath,
    this.quantity,
    this.price,
    this.createdAt,
    this.updatedAt,
  });

  CheckoutData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = json['product'];
    size = json['size'];
    color = json['color'];
    colorCode = json['color_code'];
    priceForProduct = json['priceForProduct'];
    productImagePath = json['product_image_path'];
    productThumbnailPath = json['product_thumbnail_path'];
    quantity = json['quantity'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product'] = product;
    data['size'] = size;
    data['color'] = color;
    data['color_code'] = colorCode;
    data['priceForProduct'] = priceForProduct;
    data['product_image_path'] = productImagePath;
    data['product_thumbnail_path'] = productThumbnailPath;
    data['quantity'] = quantity;
    data['price'] = price;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
