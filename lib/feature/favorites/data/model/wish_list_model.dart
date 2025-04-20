class WishListModel {
  bool? status;
  String? message;
  List<Data>? data;
  Meta? meta;

  WishListModel({this.status, this.message, this.data, this.meta});

  WishListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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

class Data {
  num? id;
  String? product;
  num? productId;
  num? priceForProduct;
  String? descriptionProduct;
  num? priceForProductOld;
  String? productImagePath;
  String? productThumbnailPath;
  String? createdAt;
  String? updatedAt;

  Data({
    this.id,
    this.product,
    this.productId,
    this.priceForProduct,
    this.descriptionProduct,
    this.priceForProductOld,
    this.productImagePath,
    this.productThumbnailPath,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = json['product'];
    productId = json['product_id'];
    priceForProduct = json['priceForProduct'];
    descriptionProduct = json['description_product'];
    priceForProductOld = json['priceForProductOld'];
    productImagePath = json['product_image_path'];
    productThumbnailPath = json['product_thumbnail_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product'] = product;
    data['product_id'] = productId;
    data['priceForProduct'] = priceForProduct;
    data['description_product'] = descriptionProduct;
    data['priceForProductOld'] = priceForProductOld;
    data['product_image_path'] = productImagePath;
    data['product_thumbnail_path'] = productThumbnailPath;
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
