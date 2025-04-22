class OrderModel {
  bool? status;
  String? message;
  List<OrderData>? data;
  Meta? meta;

  OrderModel({this.status, this.message, this.data, this.meta});

  OrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <OrderData>[];
      json['data'].forEach((v) {
        data!.add(OrderData.fromJson(v));
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

class OrderData {
  int? id;
  int? customerId;
  String? customer;
  Address? address;
  String? totalPrice;
  String? status;
  List<Items>? items;
  String? paymentMethod;
  String? paymentStatus;
  bool? isPreorder;
  String? createdAt;
  String? updatedAt;

  OrderData({
    this.id,
    this.customerId,
    this.customer,
    this.address,
    this.totalPrice,
    this.status,
    this.items,
    this.paymentMethod,
    this.paymentStatus,
    this.isPreorder,
    this.createdAt,
    this.updatedAt,
  });

  OrderData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    customer = json['customer'];
    address = json['address'] != null ? Address.fromJson(json['address']) : null;
    totalPrice = json['total_price'];
    status = json['status'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    paymentMethod = json['payment_method'];
    paymentStatus = json['payment_status'];
    isPreorder = json['is_preorder'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer_id'] = customerId;
    data['customer'] = customer;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['total_price'] = totalPrice;
    data['status'] = status;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['payment_method'] = paymentMethod;
    data['payment_status'] = paymentStatus;
    data['is_preorder'] = isPreorder;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Address {
  int? id;
  String? name;
  String? phone;
  int? countryId;
  String? country;
  int? stateId;
  String? state;
  int? cityId;
  String? city;
  String? address;
  String? pinCode;
  bool? isDefault;
  String? createdAt;
  String? updateAt;

  Address({
    this.id,
    this.name,
    this.phone,
    this.countryId,
    this.country,
    this.stateId,
    this.state,
    this.cityId,
    this.city,
    this.address,
    this.pinCode,
    this.isDefault,
    this.createdAt,
    this.updateAt,
  });

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    countryId = json['country_id'];
    country = json['country'];
    stateId = json['state_id'];
    state = json['state'];
    cityId = json['city_id'];
    city = json['city'];
    address = json['address'];
    pinCode = json['pin_code'];
    isDefault = json['is_default'];
    createdAt = json['created_at'];
    updateAt = json['update_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['country_id'] = countryId;
    data['country'] = country;
    data['state_id'] = stateId;
    data['state'] = state;
    data['city_id'] = cityId;
    data['city'] = city;
    data['address'] = address;
    data['pin_code'] = pinCode;
    data['is_default'] = isDefault;
    data['created_at'] = createdAt;
    data['update_at'] = updateAt;
    return data;
  }
}

class Items {
  int? id;
  int? orderId;
  String? product;
  int? productId;
  String? productImagePath;
  String? productThumbnailPath;
  int? quantity;
  String? price;
  String? createdAt;
  String? updatedAt;

  Items({
    this.id,
    this.orderId,
    this.product,
    this.productId,
    this.productImagePath,
    this.productThumbnailPath,
    this.quantity,
    this.price,
    this.createdAt,
    this.updatedAt,
  });

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    product = json['product'];
    productId = json['product_id'];
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
    data['order_id'] = orderId;
    data['product'] = product;
    data['product_id'] = productId;
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
