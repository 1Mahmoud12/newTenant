class CartItemModel {
  bool? status;
  int? code;
  String? message;
  List<CartItemData>? data;

  CartItemModel({this.status, this.code, this.message, this.data});

  CartItemModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CartItemData>[];
      json['data'].forEach((v) {
        data!.add(CartItemData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartItemData {
  int? id;
  String? product;
  String? size;
  String? color;
  String? colorCode;
  int? priceForProduct;
  int? availableQuantity;
  String? productImagePath;
  String? productThumbnailPath;
  int? quantity;
  int? price;
  String? createdAt;
  String? updatedAt;

  CartItemData({
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
    this.availableQuantity,
    this.updatedAt,
  });

  CartItemData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = json['product'];
    size = json['size'];
    color = json['color'];
    colorCode = json['color_code'];
    availableQuantity = json['available_quantity'];
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
    data['available_quantity'] = availableQuantity;
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
