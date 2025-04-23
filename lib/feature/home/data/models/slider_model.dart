class SliderModel {
  bool? status;
  int? code;
  String? message;
  SliderData? data;

  SliderModel({this.status, this.code, this.message, this.data});

  SliderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? SliderData.fromJson(json['data']) : null;
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

class SliderData {
  String? loginImagePath;
  String? registerImagePath;
  String? productPageImagePath;
  String? productCardImagePath;
  String? color;
  List<Sliders>? sliders;

  SliderData({
    this.loginImagePath,
    this.registerImagePath,
    this.productPageImagePath,
    this.productCardImagePath,
    this.color,
    this.sliders,
  });

  SliderData.fromJson(Map<String, dynamic> json) {
    loginImagePath = json['login_image_path'];
    registerImagePath = json['register_image_path'];
    productPageImagePath = json['product_page_image_path'];
    productCardImagePath = json['product_card_image_path'];
    color = json['color'];
    if (json['sliders'] != null) {
      sliders = <Sliders>[];
      json['sliders'].forEach((v) {
        sliders!.add(Sliders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['login_image_path'] = loginImagePath;
    data['register_image_path'] = registerImagePath;
    data['product_page_image_path'] = productPageImagePath;
    data['product_card_image_path'] = productCardImagePath;
    data['color'] = color;
    if (sliders != null) {
      data['sliders'] = sliders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sliders {
  int? id;
  String? heading;
  String? paragraphUp;
  String? paragraphDown;
  String? imagePath;

  Sliders({
    this.id,
    this.heading,
    this.paragraphUp,
    this.paragraphDown,
    this.imagePath,
  });

  Sliders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    heading = json['heading'];
    paragraphUp = json['paragraph_up'];
    paragraphDown = json['paragraph_down'];
    imagePath = json['image_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['heading'] = heading;
    data['paragraph_up'] = paragraphUp;
    data['paragraph_down'] = paragraphDown;
    data['image_path'] = imagePath;
    return data;
  }
}
