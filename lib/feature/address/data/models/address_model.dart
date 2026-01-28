import 'package:dobzz_seller/core/utils/constants.dart';

class AddressModel {
  int? maxPrice;
  int? status;
  String? message;
  AddressData? data;

  AddressModel({this.maxPrice, this.status, this.message, this.data});

  AddressModel.fromJson(Map<String, dynamic> json) {
    maxPrice = json['max_price'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? AddressData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['max_price'] = maxPrice;
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class AddressData {
  int? currentPage;
  List<AddressDataModel>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<PaginationLink>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  AddressData({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  AddressData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <AddressDataModel>[];
      json['data'].forEach((v) {
        data!.add(AddressDataModel.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <PaginationLink>[];
      json['links'].forEach((v) {
        links!.add(PaginationLink.fromJson(v));
      });
    }
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
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class AddressDataModel {
  int? id;
  int? customerId;
  String? fullName;
  String? phone;
  String? title;
  String? address;
  int? countryId;
  int? stateId;
  int? cityId;
  int? postcode;
  String? deliveryInstructions;
  int? defaultAddress;
  int? type;
  int? storeId;
  String? createdAt;
  String? updatedAt;
  String? countryName;
  String? stateName;
  String? cityName;

  AddressDataModel({
    this.id,
    this.customerId,
    this.fullName,
    this.phone,
    this.title,
    this.address,
    this.countryId,
    this.stateId,
    this.cityId,
    this.postcode,
    this.deliveryInstructions,
    this.defaultAddress,
    this.type,
    this.storeId,
    this.createdAt,
    this.updatedAt,
    this.countryName,
    this.stateName,
    this.cityName,
  });

  AddressDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? -1;
    customerId = json['customer_id'];
    fullName = json['full_name'];
    phone = json['phone'];
    title = json['title'];
    address = json['address'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    postcode = json['postcode'];
    deliveryInstructions = json['delivery_instructions'];
    defaultAddress = json['default_address'] ?? 0;

    if (defaultAddress != null && defaultAddress == 1) {
      Constants.defaultAddress.name = title ?? 'unknown address';
      if (id != null) {
        Constants.defaultAddress.addressId = id ?? -1;
      }
    }

    type = json['type'];
    storeId = json['store_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    countryName = json['country_name'];
    stateName = json['state_name'];
    cityName = json['city_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer_id'] = customerId;
    data['full_name'] = fullName;
    data['phone'] = phone;
    data['title'] = title;
    data['address'] = address;
    data['country_id'] = countryId;
    data['state_id'] = stateId;
    data['city_id'] = cityId;
    data['postcode'] = postcode;
    data['delivery_instructions'] = deliveryInstructions;
    data['default_address'] = defaultAddress;
    data['type'] = type;
    data['store_id'] = storeId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['country_name'] = countryName;
    data['state_name'] = stateName;
    data['city_name'] = cityName;
    return data;
  }
}

class PaginationLink {
  String? url;
  String? label;
  bool? active;

  PaginationLink({this.url, this.label, this.active});

  PaginationLink.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['label'] = label;
    data['active'] = active;
    return data;
  }
}
