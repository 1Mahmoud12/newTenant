// Product model classes for JSON response
class ProductModel {
  String? message;
  bool? status;
  int? code;
  List<Product>? data;

  ProductModel({
    this.message,
    this.status,
    this.code,
    this.data,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      message: json['message'],
      status: json['status'],
      code: json['code'],
      data: json['data'] != null ? List<Product>.from(json['data'].map((x) => Product.fromJson(x))) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'status': status,
        'code': code,
        'data': data?.map((x) => x.toJson()).toList(),
      };
}

class Product {
  int? id;
  String? name;
  String? sku;
  String? description;
  double? price;
  double? priceOld;
  dynamic length;
  dynamic width;
  dynamic height;
  dynamic weight;
  dynamic brand;
  dynamic brandId;
  String? label;
  num? labelId;
  List<Category>? categories;
  List<Category>? mainCategories;
  List<Category>? subCategories;
  List<Size>? sizes;
  List<Color>? colors;
  num? totalSold;
  String? tax;
  num? taxId;
  num? stock;
  num? isStock;
  String? imagePath;
  String? thumbnailPath;
  bool? visible;
  List<dynamic>? reviews;
  num? reviewsCount;
  num? averageRating;
  String? createdAt;
  String? updatedAt;

  Product({
    this.id,
    this.name,
    this.sku,
    this.description,
    this.price,
    this.priceOld,
    this.length,
    this.width,
    this.height,
    this.weight,
    this.brand,
    this.brandId,
    this.label,
    this.labelId,
    this.categories,
    this.mainCategories,
    this.subCategories,
    this.sizes,
    this.colors,
    this.totalSold,
    this.tax,
    this.taxId,
    this.stock,
    this.isStock,
    this.imagePath,
    this.thumbnailPath,
    this.visible,
    this.reviews,
    this.reviewsCount,
    this.averageRating,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      sku: json['sku'],
      description: json['description'],
      price: json['price']?.toDouble(),
      priceOld: json['price_old']?.toDouble(),
      length: json['length'],
      width: json['width'],
      height: json['height'],
      weight: json['weight'],
      brand: json['brand'],
      brandId: json['brand_id'],
      label: json['label'],
      labelId: json['label_id'],
      categories: json['categories'] != null
          ? List<Category>.from(
              json['categories'].map((x) => Category.fromJson(x)),
            )
          : null,
      mainCategories: json['main_categories'] != null
          ? List<Category>.from(
              json['main_categories'].map((x) => Category.fromJson(x)),
            )
          : null,
      subCategories: json['sub_categories'] != null
          ? List<Category>.from(
              json['sub_categories'].map((x) => Category.fromJson(x)),
            )
          : null,
      sizes: json['sizes'] != null ? List<Size>.from(json['sizes'].map((x) => Size.fromJson(x))) : null,
      colors: json['colors'] != null ? List<Color>.from(json['colors'].map((x) => Color.fromJson(x))) : null,
      totalSold: json['total_sold'],
      tax: json['tax'],
      taxId: json['tax_id'],
      stock: json['stock'],
      isStock: json['is_stock'],
      imagePath: json['image_path'],
      thumbnailPath: json['thumbnail_path'],
      visible: json['visible'],
      reviews: json['reviews'],
      reviewsCount: json['reviews_count'],
      averageRating: json['average_rating'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'sku': sku,
        'description': description,
        'price': price,
        'price_old': priceOld,
        'length': length,
        'width': width,
        'height': height,
        'weight': weight,
        'brand': brand,
        'brand_id': brandId,
        'label': label,
        'label_id': labelId,
        'categories': categories?.map((x) => x.toJson()).toList(),
        'main_categories': mainCategories?.map((x) => x.toJson()).toList(),
        'sub_categories': subCategories?.map((x) => x.toJson()).toList(),
        'sizes': sizes?.map((x) => x.toJson()).toList(),
        'colors': colors?.map((x) => x.toJson()).toList(),
        'total_sold': totalSold,
        'tax': tax,
        'tax_id': taxId,
        'stock': stock,
        'is_stock': isStock,
        'image_path': imagePath,
        'thumbnail_path': thumbnailPath,
        'visible': visible,
        'reviews': reviews,
        'reviews_count': reviewsCount,
        'average_rating': averageRating,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

class Category {
  int? id;
  String? name;
  String? image;
  String? icon;
  int? visible;
  dynamic parentId;
  int? shopId;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  Category({
    this.id,
    this.name,
    this.image,
    this.icon,
    this.visible,
    this.parentId,
    this.shopId,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      icon: json['icon'],
      visible: json['visible'],
      parentId: json['parent_id'],
      shopId: json['shop_id'],
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      pivot: json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'icon': icon,
        'visible': visible,
        'parent_id': parentId,
        'shop_id': shopId,
        'deleted_at': deletedAt,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'pivot': pivot?.toJson(),
      };
}

class Pivot {
  int? productId;
  int? categoryId;

  Pivot({
    this.productId,
    this.categoryId,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      productId: json['product_id'],
      categoryId: json['category_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'category_id': categoryId,
      };
}

class Size {
  int? id;
  String? name;
  String? code;
  String? createdAt;
  String? updatedAt;

  Size({
    this.id,
    this.name,
    this.code,
    this.createdAt,
    this.updatedAt,
  });

  factory Size.fromJson(Map<String, dynamic> json) {
    return Size(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

class Color {
  int? id;
  String? name;
  String? code;
  String? createdAt;
  String? updatedAt;

  Color({
    this.id,
    this.name,
    this.code,
    this.createdAt,
    this.updatedAt,
  });

  factory Color.fromJson(Map<String, dynamic> json) {
    return Color(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
