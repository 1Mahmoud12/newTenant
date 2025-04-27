class SalesBannerModel {
  bool? status;
  int? code;
  String? message;
  SaleBannerData? data;

  SalesBannerModel({this.status, this.code, this.message, this.data});

  SalesBannerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? SaleBannerData.fromJson(json['data']) : null;
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

class SaleBannerData {
  String? pannerImagePath;
  String? pannerHeading;
  String? pannerTitle;
  String? pannerDiscount;
  String? endTime;
  bool? isValid;
  int? productId;
  num? categoryId;
//  List<void>? productIds;
  String? selectionType;

  SaleBannerData({
    this.pannerImagePath,
    this.pannerHeading,
    this.pannerTitle,
    this.pannerDiscount,
    this.endTime,
    this.isValid,
    this.productId,
    this.categoryId,
    //   this.productIds,
    this.selectionType,
  });

  SaleBannerData.fromJson(Map<String, dynamic> json) {
    pannerImagePath = json['panner_image_path'];
    pannerHeading = json['panner_heading'];
    pannerTitle = json['panner_title'];
    pannerDiscount = json['panner_discount'];
    endTime = json['end_time'];
    isValid = json['is_valid'];
    productId = json['product_id'];
    categoryId = json['category_id'];
    // if (json['product_ids'] != null) {
    //   productIds = <Null>[];
    //   json['product_ids'].forEach((v) {
    //     productIds!.add(void.fromJson(v));
    //   });
    // }
    selectionType = json['selection_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['panner_image_path'] = pannerImagePath;
    data['panner_heading'] = pannerHeading;
    data['panner_title'] = pannerTitle;
    data['panner_discount'] = pannerDiscount;
    data['end_time'] = endTime;
    data['is_valid'] = isValid;
    data['product_id'] = productId;
    data['category_id'] = categoryId;
    // if (productIds != null) {
    //   data['product_ids'] = productIds!.map((v) => v.toJson()).toList();
    // }
    data['selection_type'] = selectionType;
    return data;
  }
}
