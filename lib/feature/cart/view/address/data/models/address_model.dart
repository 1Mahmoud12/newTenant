class AddressModel {
  bool? status;
  String? message;
  List<Data>? data;
  Meta? meta;

  AddressModel({this.status, this.message, this.data, this.meta});

  AddressModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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

class Data {
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

  Data({
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

  Data.fromJson(Map<String, dynamic> json) {
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
