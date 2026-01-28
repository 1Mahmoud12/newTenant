import 'package:dobzz_seller/feature/home/data/models/product_mdoel.dart';

class ProductDetailsModel {
  bool? status;
  int? code;
  String? message;
  Product? data;
  List<Product>? relatedProducts;
  List<Images>? productImages;

  ProductDetailsModel({
    this.status,
    this.code,
    this.message,
    this.data,
    this.relatedProducts,
    this.productImages,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    // Check if we have the new nested structure inside 'data'
    Map<String, dynamic>? innerData;
    if (json['data'] != null && json['data'] is Map) {
      innerData = json['data'];
    }

    // Attempt to parse Product from 'product_info' (new API) or 'data' (legacy/fallback)
    Product? product;
    if (innerData != null && innerData['product_info'] != null) {
      product = Product.fromJson(innerData['product_info']);
    } else if (json['data'] != null && json['data'] is Map && json['data']['product_info'] == null) {
      // Maybe legacy structure where data IS the product? Or unexpected.
      // Safe fallback if 'product_info' is missing but 'data' looks like a product
      try {
        product = Product.fromJson(json['product_info']);
      } catch (e) {
        // ignore
      }
    }

    // Parse Related Products
    List<Product>? related;
    if (innerData != null && innerData['releted_products'] != null) {
      related = <Product>[];
      innerData['releted_products'].forEach((v) {
        related!.add(Product.fromJson(v));
      });
    }

    // Parse Product Images
    List<Images>? images;
    if (innerData != null && innerData['product_image'] != null) {
      images = <Images>[];
      innerData['product_image'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    } else if (product?.images != null) {
      // Fallback to images inside product object if not separated
      images = product!.images;
    }

    // Assign images to product if they were separate, so UI can just use product.images
    if (product != null && images != null) {
      product.images = images;
    }

    // Parse Status properly as before
    bool? statusVal;
    if (json['status'] is bool) {
      statusVal = json['status'];
    } else if (json['status'] is int) {
      statusVal = json['status'] == 1;
    }

    return ProductDetailsModel(
      status: statusVal,
      code: json['code'],
      message: json['message'],
      data: product,
      relatedProducts: related,
      productImages: images,
    );
  }
}
// Removed unused classes Category, Pivot, AvailableProductSize, ColorModel, Review since we use Product model classes.
