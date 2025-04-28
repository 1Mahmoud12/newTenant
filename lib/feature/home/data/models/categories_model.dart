class CategoriesModel {
  bool? status;
  int? code;
  String? message;
  List<CategoryData>? data;

  CategoriesModel({this.status, this.code, this.message, this.data});

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CategoryData>[];
      json['data'].forEach((v) {
        data!.add(CategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryData {
  int? id;
  String? name;
  String? parent;
  int? parentId;
  String? imagePath;
  String? iconPath;
  bool? visible;
  // List<void>? subcategories;
  String? createdAt;
  String? updatedAt;

  CategoryData({
    this.id,
    this.name,
    this.parent,
    this.parentId,
    this.imagePath,
    this.iconPath,
    this.visible,
    //  this.subcategories,
    this.createdAt,
    this.updatedAt,
  });

  CategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parent = json['parent'];
    parentId = json['parent_id'];
    imagePath = json['image_path'];
    iconPath = json['icon_path'];
    visible = json['visible'];
    // if (json['subcategories'] != null) {
    //   subcategories = <Null>[];
    //   json['subcategories'].forEach((v) {
    //     subcategories!.add(void.fromJson(v));
    //   });
    // }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['parent'] = parent;
    data['parent_id'] = parentId;
    data['image_path'] = imagePath;
    data['icon_path'] = iconPath;
    data['visible'] = visible;
    // if (subcategories != null) {
    //   data['subcategories'] =
    //       subcategories!.map((v) => v.toJson()).toList();
    // }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
