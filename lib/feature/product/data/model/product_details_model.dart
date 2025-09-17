class ProductDetailsModel {
  bool? status;
  int? code;
  String? message;
  ProductData? data;

  ProductDetailsModel({this.status, this.code, this.message, this.data});

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) => ProductDetailsModel(
        status: json['status'],
        code: json['code'],
        message: json['message'],
        data: json['data'] != null ? ProductData.fromJson(json['data']) : null,
      );
}

class ProductData {
  int? id;
  String? name;
  String? sku;
  String? description;
  num? price;
  num? priceOld;
  num? length;
  num? width;
  num? height;
  num? weight;
  String? brand;
  int? brandId;
  String? label;
  int? labelId;
  List<Category>? categories;
  List<Category>? mainCategories;
  List<dynamic>? subCategories;
  List<AvailableProductSize>? sizes;
  List<ColorModel>? colors;
  num? totalSold;
  String? tax;
  int? taxId;
  int? stock;
  int? isStock;
  String? imagePath;
  String? thumbnailPath;
  bool? visible;
  List<Review>? reviews;
  int? reviewsCount;
  num? averageRating;
  String? createdAt;
  String? updatedAt;

  ProductData({
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

  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
        id: json['id'],
        name: json['name'],
        sku: json['sku_code'],
        description: json['description'],
        price: json['price'],
        priceOld: json['price_old'],
        length: json['length'],
        width: json['width'],
        height: json['height'],
        weight: json['weight'],
        brand: json['brand'],
        brandId: json['brand_id'],
        label: json['label'],
        labelId: json['label_id'],
        categories: (json['categories'] as List?)?.map((e) => Category.fromJson(e)).toList(),
        mainCategories: (json['main_categories'] as List?)?.map((e) => Category.fromJson(e)).toList(),
        subCategories: json['sub_categories'],
        sizes: (json['sizes'] as List?)?.map((e) => AvailableProductSize.fromJson(e)).toList(),
        colors: (json['colors'] as List?)?.map((e) => ColorModel.fromJson(e)).toList(),
        totalSold: json['total_sold'],
        tax: json['tax'],
        taxId: json['tax_id'],
        stock: json['stock'],
        isStock: json['is_stock'],
        imagePath: json['image_path'],
        thumbnailPath: json['thumbnail_path'],
        visible: json['visible'],
        reviews: (json['reviews'] as List?)?.map((e) => Review.fromJson(e)).toList(),
        reviewsCount: json['reviews_count'],
        averageRating: json['average_rating'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );
}

class Category {
  int? id;
  String? name;
  String? image;
  String? icon;
  int? visible;
  int? parentId;
  int? shopId;
  String? deletedAt;
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

  factory Category.fromJson(Map<String, dynamic> json) => Category(
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

class Pivot {
  int? productId;
  int? categoryId;

  Pivot({this.productId, this.categoryId});

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        productId: json['product_id'],
        categoryId: json['category_id'],
      );
}

class AvailableProductSize {
  int? id;
  String? name;
  String? code;
  String? createdAt;
  String? updatedAt;

  AvailableProductSize({this.id, this.name, this.code, this.createdAt, this.updatedAt});

  factory AvailableProductSize.fromJson(Map<String, dynamic> json) => AvailableProductSize(
        id: json['id'],
        name: json['name'],
        code: json['code'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );
}

class ColorModel {
  int? id;
  String? name;
  String? code;
  String? createdAt;
  String? updatedAt;

  ColorModel({this.id, this.name, this.code, this.createdAt, this.updatedAt});

  factory ColorModel.fromJson(Map<String, dynamic> json) => ColorModel(
        id: json['id'],
        name: json['name'],
        code: json['code'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );
}

class Review {
  int? id;
  String? review;
  String? customer;
  String? customerImage;
  bool? createdBy;
  String? product;
  int? productId;
  String? rating;
  bool? visible;
  String? createdAt;
  String? updatedAt;

  Review({
    this.id,
    this.review,
    this.customer,
    this.customerImage,
    this.createdBy,
    this.product,
    this.productId,
    this.rating,
    this.visible,
    this.createdAt,
    this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json['id'],
        review: json['review'],
        customer: json['customer'],
        customerImage: json['customer_image'],
        createdBy: json['created_by'],
        product: json['product'],
        productId: json['product_id'],
        rating: json['rating'],
        visible: json['visible'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );
}
