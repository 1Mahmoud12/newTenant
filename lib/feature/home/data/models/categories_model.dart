class CategoriesModel {
  int? maxPrice;
  int? status;
  String? message;
  List<CategoryData>? data;

  CategoriesModel({this.maxPrice, this.status, this.message, this.data});

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    maxPrice = json['max_price'];
    // Handle status flexibly if needed, currently observing int 1 in new API
    if (json['status'] is bool) {
      status = json['status'] ? 1 : 0;
    } else {
      status = json['status'];
    }

    // code = json['code']; // field seems removed in new response
    message = json['message'];
    if (json['data'] != null) {
      data = <CategoryData>[];
      json['data'].forEach((v) {
        data!.add(CategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['max_price'] = maxPrice;
    data['status'] = status;
    // data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryData {
  int? id;
  String? name;
  String? slug;
  String? imagePath;
  String? iconPath;
  int? parentId;
  int? trending;
  int? status;
  int? storeId;
  String? createdAt;
  String? updatedAt;
  int? productCount;
  String? demoField;
  int? totalProduct;
  String? imagePathFullUrl;
  String? iconPathFullUrl;

  CategoryData({
    this.id,
    this.name,
    this.slug,
    this.imagePath,
    this.iconPath,
    this.parentId,
    this.trending,
    this.status,
    this.storeId,
    this.createdAt,
    this.updatedAt,
    this.productCount,
    this.demoField,
    this.totalProduct,
    this.imagePathFullUrl,
    this.iconPathFullUrl,
  });

  CategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    imagePath = json['image_path'];
    iconPath = json['icon_path'];
    parentId = json['parent_id'];
    trending = json['trending'];
    status = json['status'];
    storeId = json['store_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    productCount = json['product_count'];
    demoField = json['demo_field'];
    totalProduct = json['total_product'];
    imagePathFullUrl = json['image_path_full_url'];
    iconPathFullUrl = json['icon_path_full_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['image_path'] = imagePath;
    data['icon_path'] = iconPath;
    data['parent_id'] = parentId;
    data['trending'] = trending;
    data['status'] = status;
    data['store_id'] = storeId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['product_count'] = productCount;
    data['demo_field'] = demoField;
    data['total_product'] = totalProduct;
    data['image_path_full_url'] = imagePathFullUrl;
    data['icon_path_full_url'] = iconPathFullUrl;
    return data;
  }
}
