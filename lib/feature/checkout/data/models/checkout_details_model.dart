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
  Product? product;
  int? productId;
  dynamic color;
  dynamic size;
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

  CheckoutData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = json['product'] != null ? Product.fromJson(json['product']) : null;
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
    if (product != null) {
      data['product'] = product!.toJson();
    }
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

class Product {
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
// num? brand;
  num? brandId;
  String? label;
  num? labelId;
  List<Categories>? categories;
  List<MainCategories>? mainCategories;
  // List<SubCategories>? subCategories;
  List<Sizes>? sizes;
  // List<Colors>? colors;
  num? totalSold;
  //  tax;
  // void taxId;
  num? stock;
  num? isStock;
  String? imagePath;
  String? thumbnailPath;
  bool? visible;
  List<void>? reviews;
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
    //  this.brand,
    this.brandId,
    this.label,
    this.labelId,
    this.categories,
    this.mainCategories,
    // this.subCategories,
    this.sizes,
    //  this.colors,
    this.totalSold,
    // this.tax,
    // this.taxId,
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

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sku = json['sku'];
    description = json['description'];
    price = json['price'];
    priceOld = json['price_old'];
    length = json['length'];
    width = json['width'];
    height = json['height'];
    weight = json['weight'];
    //   brand = json['brand'];
    brandId = json['brand_id'];
    label = json['label'];
    labelId = json['label_id'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
    if (json['main_categories'] != null) {
      mainCategories = <MainCategories>[];
      json['main_categories'].forEach((v) {
        mainCategories!.add(MainCategories.fromJson(v));
      });
    }
    // if (json['sub_categories'] != null) {
    //   subCategories = <SubCategories>[];
    //   json['sub_categories'].forEach((v) {
    //     subCategories!.add(SubCategories.fromJson(v));
    //   });
    // }
    if (json['sizes'] != null) {
      sizes = <Sizes>[];
      json['sizes'].forEach((v) {
        sizes!.add(Sizes.fromJson(v));
      });
    }
    // if (json['colors'] != null) {
    //   colors = <Colors>[];
    //   json['colors'].forEach((v) {
    //     colors!.add(Colors.fromJson(v));
    //   });
    // }
    totalSold = json['total_sold'];
    // tax = json['tax'];
    // taxId = json['tax_id'];
    stock = json['stock'];
    isStock = json['is_stock'];
    imagePath = json['image_path'];
    thumbnailPath = json['thumbnail_path'];
    visible = json['visible'];
    // if (json['reviews'] != null) {
    //   reviews = <Null>[];
    //   json['reviews'].forEach((v) {
    //     reviews!.add(void.fromJson(v));
    //   });
    // }
    reviewsCount = json['reviews_count'];
    averageRating = json['average_rating'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['sku'] = sku;
    data['description'] = description;
    data['price'] = price;
    data['price_old'] = priceOld;
    data['length'] = length;
    data['width'] = width;
    data['height'] = height;
    data['weight'] = weight;
    // data['brand'] = brand;
    data['brand_id'] = brandId;
    data['label'] = label;
    data['label_id'] = labelId;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (mainCategories != null) {
      data['main_categories'] = mainCategories!.map((v) => v.toJson()).toList();
    }
    // if (subCategories != null) {
    //   data['sub_categories'] =
    //       subCategories!.map((v) => v.toJson()).toList();
    // }
    if (sizes != null) {
      data['sizes'] = sizes!.map((v) => v.toJson()).toList();
    }
    // if (colors != null) {
    //   data['colors'] = colors!.map((v) => v.toJson()).toList();
    // }
    data['total_sold'] = totalSold;
    // data['tax'] = tax;
    // data['tax_id'] = taxId;
    data['stock'] = stock;
    data['is_stock'] = isStock;
    data['image_path'] = imagePath;
    data['thumbnail_path'] = thumbnailPath;
    data['visible'] = visible;
    // if (reviews != null) {
    //   data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    // }
    data['reviews_count'] = reviewsCount;
    data['average_rating'] = averageRating;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Categories {
  int? id;
  String? name;
  String? image;
  String? icon;
  num? visible;
  num? parentId;
  num? shopId;
  void deletedAt;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  Categories({
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

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    icon = json['icon'];
    visible = json['visible'];
    parentId = json['parent_id'];
    shopId = json['shop_id'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['icon'] = icon;
    data['visible'] = visible;
    data['parent_id'] = parentId;
    data['shop_id'] = shopId;
    // data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  int? productId;
  int? categoryId;

  Pivot({this.productId, this.categoryId});

  Pivot.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['category_id'] = categoryId;
    return data;
  }
}

class MainCategories {
  int? id;
  String? name;
  String? image;
  String? icon;
  int? visible;
  void parentId;
  int? shopId;
  void deletedAt;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  MainCategories({
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

  MainCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    icon = json['icon'];
    visible = json['visible'];
    parentId = json['parent_id'];
    shopId = json['shop_id'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['icon'] = icon;
    data['visible'] = visible;
    // data['parent_id'] = parentId;
    data['shop_id'] = shopId;
    // data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    return data;
  }
}

class Sizes {
  int? id;
  String? name;
  String? code;
  String? createdAt;
  String? updatedAt;

  Sizes({this.id, this.name, this.code, this.createdAt, this.updatedAt});

  Sizes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
