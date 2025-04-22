class PromoCodeModel {
  bool? status;
  int? code;
  String? message;
  Data? data;

  PromoCodeModel({this.status, this.code, this.message, this.data});

  PromoCodeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  num? percentage;
  num? discount;
  num? totalPriceBefore;
  num? totalPrice;

  Data({
    this.percentage,
    this.discount,
    this.totalPriceBefore,
    this.totalPrice,
  });

  Data.fromJson(Map<String, dynamic> json) {
    percentage = json['percentage'];
    discount = json['discount'];
    totalPriceBefore = json['total_Price_before'];
    totalPrice = json['total_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['percentage'] = percentage;
    data['discount'] = discount;
    data['total_Price_before'] = totalPriceBefore;
    data['total_price'] = totalPrice;
    return data;
  }
}
