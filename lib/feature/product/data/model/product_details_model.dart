import 'package:dobzz_seller/feature/home/data/models/product_mdoel.dart';

class ProductDetailsModel {
  bool? status;
  int? code;
  String? message;
  Product? data;

  ProductDetailsModel({this.status, this.code, this.message, this.data});

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) => ProductDetailsModel(
        status: json['status'],
        code: json['code'],
        message: json['message'],
        data: json['data'] != null ? Product.fromJson(json['data']) : null,
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
