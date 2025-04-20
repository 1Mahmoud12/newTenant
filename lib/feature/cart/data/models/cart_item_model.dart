class CartItemModel {
  bool? status;
  String? message;
  List<CartItemData>? data;
  Meta? meta;

  CartItemModel({this.status, this.message, this.data, this.meta});

  CartItemModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CartItemData>[];
      json['data'].forEach((v) {
        data!.add(CartItemData.fromJson(v));
      });
    }
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    return data;
  }
}

class CartItemData {
  int? id;
  String? product;
  int? productId;
  dynamic color;
  num? size;
  int? priceForProduct;
  String? productImagePath;
  String? productThumbnailPath;
  int? quantity;
  int? price;
  String? createdAt;
  String? updatedAt;

  CartItemData({
    this.id,
    this.product,
    this.productId,
    this.color,
    this.size,
    this.priceForProduct,
    this.productImagePath,
    this.productThumbnailPath,
    this.quantity,
    this.price,
    this.createdAt,
    this.updatedAt,
  });

  CartItemData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = json['product'];
    productId = json['product_id'];
    color = json['color'];
    size = json['size'];
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
    data['product_id'] = productId;
    data['color'] = color;
    data['size'] = size;
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

class Meta {
  int? total;
  int? from;
  int? to;
  int? count;
  int? perPage;
  int? currentPage;
  int? lastPage;

  Meta({
    this.total,
    this.from,
    this.to,
    this.count,
    this.perPage,
    this.currentPage,
    this.lastPage,
  });

  Meta.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    from = json['from'];
    to = json['to'];
    count = json['count'];
    perPage = json['per_page'];
    currentPage = json['current_page'];
    lastPage = json['last_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['from'] = from;
    data['to'] = to;
    data['count'] = count;
    data['per_page'] = perPage;
    data['current_page'] = currentPage;
    data['last_page'] = lastPage;
    return data;
  }
}
