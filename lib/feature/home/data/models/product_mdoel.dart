// Product model classes for JSON response
class ProductModel {
  String? message;
  bool? status;
  int? code;
  List<Product>? data;

  int? currentPage;
  int? lastPage;
  int? total;

  ProductModel({
    this.message,
    this.status,
    this.code,
    this.data,
    this.currentPage,
    this.lastPage,
    this.total,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    List<Product> products = [];
    int? currentPage;
    int? lastPage;
    int? total;

    if (json['data'] != null) {
      if (json['data'] is List) {
        // Legacy support: direct list
        products = List<Product>.from(json['data'].map((x) => Product.fromJson(x)));
      } else if (json['data'] is Map) {
        // Pagination object
        final paginationData = json['data'];
        currentPage = paginationData['current_page'];
        lastPage = paginationData['last_page'];
        total = paginationData['total'];

        if (paginationData['data'] != null && paginationData['data'] is List) {
          products = List<Product>.from(paginationData['data'].map((x) => Product.fromJson(x)));
        }
      }
    }

    return ProductModel(
      message: json['message'],
      status: json['status'] == 1,
      code: json['code'],
      data: products,
      currentPage: currentPage,
      lastPage: lastPage,
      total: total,
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'status': status,
        'code': code,
        'data': data?.map((x) => x.toJson()).toList(),
      };
}

class Category {
  int? id;
  String? name;
  String? image;
  String? icon;
  num? visible;
  dynamic parentId;
  num? shopId;
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

class Reviews {
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

  Reviews({
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

  Reviews.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    review = json['review'];
    customer = json['customer'];
    customerImage = json['customer_image'];
    createdBy = json['created_by'];
    product = json['product'];
    productId = json['product_id'];
    rating = json['rating'];
    visible = json['visible'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['review'] = review;
    data['customer'] = customer;
    data['customer_image'] = customerImage;
    data['created_by'] = createdBy;
    data['product'] = product;
    data['product_id'] = productId;
    data['rating'] = rating;
    data['visible'] = visible;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Variants {
  int? id;
  String? skuCode;
  num? skucodeId;
  num? skuableId;
  String? skuableType;
  num? productId;
  String? imagePath;
  int? sizeId;
  String? size;
  String? type;
  int? colorId;
  String? color;
  String? colorCode;
  num? quantity;

  Variants({
    this.id,
    this.skuCode,
    this.skucodeId,
    this.skuableId,
    this.skuableType,
    this.productId,
    this.imagePath,
    this.sizeId,
    this.size,
    this.type,
    this.colorId,
    this.color,
    this.colorCode,
    this.quantity,
  });

  Variants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    skuCode = json['sku_code'];
    skucodeId = json['skucode_id'];
    skuableId = json['skuable_id'];
    skuableType = json['skuable_type'];
    productId = json['product_id'];
    imagePath = json['image_path'];
    sizeId = json['size_id'];
    size = json['size'];
    type = json['type'];
    colorId = json['color_id'];
    color = json['color'];
    colorCode = json['color_code'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sku_code'] = skuCode;
    data['skucode_id'] = skucodeId;
    data['skuable_id'] = skuableId;
    data['skuable_type'] = skuableType;
    data['product_id'] = productId;
    data['image_path'] = imagePath;
    data['size_id'] = sizeId;
    data['size'] = size;
    data['type'] = type;
    data['color_id'] = colorId;
    data['color'] = color;
    data['color_code'] = colorCode;
    data['quantity'] = quantity;
    return data;
  }
}

class ReviewModel {
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

  ReviewModel({
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

  ReviewModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    review = json['review'];
    customer = json['customer'];
    customerImage = json['customer_image'];
    createdBy = json['created_by'];
    product = json['product'];
    productId = json['product_id'];
    rating = json['rating'];
    visible = json['visible'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['review'] = review;
    data['customer'] = customer;
    data['customer_image'] = customerImage;
    data['created_by'] = createdBy;
    data['product'] = product;
    data['product_id'] = productId;
    data['rating'] = rating;
    data['visible'] = visible;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Product {
  int? id;
  int? categoryId;
  String? name;
  String? description;
  String? skuCode;
  String? slug;

  bool? available;

  num? price;
  num? priceOld;
  num? length;
  num? cost;
  num? quantity;
  num? width;
  num? height;
  num? weight;
  String? brand;
  num? brandId;
  String? label;
  num? labelId;
  List<Categories>? categories;
  List<Categories>? mainCategories;
  List<Categories>? subCategories;
  List<Variants>? variants;
  List<Images>? images;
  String? tax;
  num? taxId;
  String? imagePath;
  String? thumbnailPath;
  String? coverImageUrl;
  bool? visible;
  List<Reviews>? reviews;
  num? reviewsCount;
  num? averageRating;
  String? createdAt;
  String? updatedAt;
  int? trending;
  bool? inCart;
  bool? inWhishlist;
  String? finalPrice;
  dynamic salePrice;

  Product({
    this.id,
    this.categoryId,
      this.name,
      this.slug,
      this.description,
      this.available,
      this.skuCode,
      this.price,
      this.priceOld,
      this.length,
      this.cost,
      this.quantity,
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
      this.variants,
      this.images,
      this.tax,
      this.taxId,
      this.imagePath,
      this.thumbnailPath,
      this.coverImageUrl,
      this.visible,
      this.reviews,
      this.reviewsCount,
      this.averageRating,
      this.createdAt,
      this.updatedAt,
      this.trending,
      this.inCart,
      this.inWhishlist,
      this.finalPrice,
      this.salePrice});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    categoryId = json['category_id'];
    slug = json['slug'];

    price = json['price'];
    skuCode = json['sku_code'];
    priceOld = json['price_old'];
    length = json['length'];
    cost = json['cost'];
    quantity = json['quantity'];
    width = json['width'];
    height = json['height'];
    weight = json['weight'];
    brand = json['brand'];
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
      mainCategories = <Categories>[];
      json['main_categories'].forEach((v) {
        mainCategories!.add(Categories.fromJson(v));
      });
    }
    if (json['sub_categories'] != null) {
      subCategories = <Categories>[];
      json['sub_categories'].forEach((v) {
        subCategories!.add(Categories.fromJson(v));
      });
    }
    if (json['variants'] != null) {
      variants = <Variants>[];
      json['variants'].forEach((v) {
        variants!.add(Variants.fromJson(v));
      });
    }
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    tax = json['tax'];
    taxId = json['tax_id'];
    imagePath = json['image_path'];
    thumbnailPath = json['thumbnail_path'];
    coverImageUrl = json['cover_image_url'];
    visible = json['visible'];
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(Reviews.fromJson(v));
      });
    }
    reviewsCount = json['reviews_count'];
    averageRating = json['average_rating'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    trending = json['trending'];
    inCart = json['in_cart'];
    inWhishlist = json['in_whishlist'];
    finalPrice = json['final_price']?.toString();
    salePrice = json['sale_price'];
    available = json['status'] == 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['category_id'] = categoryId;

    data['status'] = available;
    data['description'] = description;

    data['price'] = price;
    data['sku_code'] = skuCode;
    data['price_old'] = priceOld;
    data['length'] = length;
    data['cost'] = cost;
    data['quantity'] = quantity;
    data['width'] = width;
    data['height'] = height;
    data['weight'] = weight;
    data['brand'] = brand;
    data['brand_id'] = brandId;
    data['label'] = label;
    data['label_id'] = labelId;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (mainCategories != null) {
      data['main_categories'] = mainCategories!.map((v) => v.toJson()).toList();
    }
    if (subCategories != null) {
      data['sub_categories'] = subCategories!.map((v) => v.toJson()).toList();
    }
    if (variants != null) {
      data['variants'] = variants!.map((v) => v.toJson()).toList();
    }
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    data['tax'] = tax;
    data['tax_id'] = taxId;
    data['image_path'] = imagePath;
    data['thumbnail_path'] = thumbnailPath;
    data['cover_image_url'] = coverImageUrl;
    data['visible'] = visible;
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    data['reviews_count'] = reviewsCount;
    data['average_rating'] = averageRating;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['trending'] = trending;
    data['in_cart'] = inCart;
    data['in_whishlist'] = inWhishlist;
    data['final_price'] = finalPrice;
    data['sale_price'] = salePrice;
    return data;
  }
}

class Categories {
  num? id;
  String? name;
  String? image;
  String? icon;
  num? visible;
  num? parentId;
  num? shopId;
  String? createdAt;
  String? updatedAt;
  num? featured;
  Pivot? pivot;

  Categories({
    this.id,
    this.name,
    this.image,
    this.icon,
    this.visible,
    this.parentId,
    this.shopId,
    this.createdAt,
    this.updatedAt,
    this.featured,
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
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    featured = json['featured'];
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
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['featured'] = featured;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    return data;
  }
}

class Images {
  int? id;
  String? image;
  String? imagePathFullUrl;

  Images({this.id, this.image, this.imagePathFullUrl});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    imagePathFullUrl = json['image_path_full_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['image_path_full_url'] = imagePathFullUrl;
    return data;
  }
}
