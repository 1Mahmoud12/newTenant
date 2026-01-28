import 'package:dobzz_seller/feature/home/data/models/product_mdoel.dart';

class WishListModel {
  int? count;
  num? maxPrice;
  int? status;
  String? message;
  WishListData? data;

  WishListModel({
    this.count,
    this.maxPrice,
    this.status,
    this.message,
    this.data,
  });

  WishListModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    maxPrice = json['max_price'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? WishListData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['max_price'] = maxPrice;
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class WishListData {
  int? currentPage;
  List<ItemWishModel>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  WishListData({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  WishListData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <ItemWishModel>[];
      json['data'].forEach((v) {
        data!.add(ItemWishModel.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class ItemWishModel {
  int? id;
  int? customerId;
  int? productId;
  int? variantId;
  int? status;
  int? storeId;
  String? createdAt;
  String? updatedAt;
  String? demoField;
  String? productName;
  String? productImage;
  String? variantName;
  String? originalPrice;
  String? finalPrice;
  Product? productData;

  ItemWishModel({
    this.id,
    this.customerId,
    this.productId,
    this.variantId,
    this.status,
    this.storeId,
    this.createdAt,
    this.updatedAt,
    this.demoField,
    this.productName,
    this.productImage,
    this.variantName,
    this.originalPrice,
    this.finalPrice,
    this.productData,
  });

  ItemWishModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    productId = json['product_id'];
    variantId = json['variant_id'];
    status = json['status'];
    storeId = json['store_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    demoField = json['demo_field'];
    productName = json['product_name'];
    productImage = json['product_image'];
    variantName = json['variant_name'];
    originalPrice = json['original_price'];
    finalPrice = json['final_price'];
    productData = json['product_data'] != null ? Product.fromJson(json['product_data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer_id'] = customerId;
    data['product_id'] = productId;
    data['variant_id'] = variantId;
    data['status'] = status;
    data['store_id'] = storeId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['demo_field'] = demoField;
    data['product_name'] = productName;
    data['product_image'] = productImage;
    data['variant_name'] = variantName;
    data['original_price'] = originalPrice;
    data['final_price'] = finalPrice;
    if (productData != null) {
      data['product_data'] = productData!.toJson();
    }
    return data;
  }

  // Backward compatibility helpers
  String? get product => productName;

  String? get descriptionProduct => productData?.description;

  String? get productImagePath => productImage;

  num? get priceForProduct => productData?.price;

  num? get priceForProductOld => productData?.salePrice;
}
