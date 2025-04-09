class BranchesModel {
  BranchesModel({
    this.statusCode,
    this.message,
    this.messageAr,
    this.data,
  });

  BranchesModel.fromJson(dynamic json) {
    statusCode = json['StatusCode'];
    message = json['Message'];
    messageAr = json['MessageAr'];
    if (json['Data'] != null) {
      data = [];
      json['Data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }

  int? statusCode;
  String? message;
  String? messageAr;
  List<Data>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['StatusCode'] = statusCode;
    map['Message'] = message;
    map['MessageAr'] = messageAr;
    if (data != null) {
      map['Data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Data {
  Data({
    this.id,
    this.nameEn,
    this.nameAr,
    this.addressAr,
    this.addressEn,
    this.email,
    this.phoneNumber,
    this.longitude,
    this.latitude,
    this.coverageArea,
    this.deliveryFee,
    this.maxOrder,
    this.branchIcon,
    this.cityId,
    this.createdOn,
    this.createdBy,
    this.modefiedOn,
    this.modefiedBy,
    this.deletedOn,
    this.deletedBy,
    this.isActive,
    this.isDeleted,
    this.districtId,
    this.activationReason,
  });

  Data.fromJson(dynamic json) {
    id = json['Id'];
    nameEn = json['NameEn'];
    nameAr = json['NameAr'];
    addressAr = json['AddressAr'];
    addressEn = json['AddressEn'];
    email = json['Email'];
    phoneNumber = json['PhoneNumber'];
    longitude = json['Longitude'];
    latitude = json['Latitude'];
    coverageArea = json['CoverageArea'];
    deliveryFee = json['DeliveryFee'];
    maxOrder = json['MaxOrder'];
    branchIcon = json['BranchIcon'];
    cityId = json['CityId'];
    createdOn = json['CreatedOn'];
    createdBy = json['CreatedBy'];
    modefiedOn = json['ModefiedOn'];
    modefiedBy = json['ModefiedBy'];
    deletedOn = json['DeletedOn'];
    deletedBy = json['DeletedBy'];
    isActive = json['IsActive'];
    isDeleted = json['IsDeleted'];
    districtId = json['DistrictId'];
    activationReason = json['ActivationReason'];
  }

  int? id;
  String? nameEn;
  String? nameAr;
  String? addressAr;
  String? addressEn;
  String? email;
  String? phoneNumber;
  num? longitude;
  num? latitude;
  String? coverageArea;
  num? deliveryFee;
  num? maxOrder;
  num? districtId;
  dynamic branchIcon;
  int? cityId;
  String? createdOn;
  int? createdBy;
  dynamic modefiedOn;
  dynamic modefiedBy;
  dynamic deletedOn;
  dynamic deletedBy;
  bool? isActive;
  bool? isDeleted;
  dynamic activationReason;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = id;
    map['NameEn'] = nameEn;
    map['NameAr'] = nameAr;
    map['AddressAr'] = addressAr;
    map['AddressEn'] = addressEn;
    map['Email'] = email;
    map['PhoneNumber'] = phoneNumber;
    map['Longitude'] = longitude;
    map['Latitude'] = latitude;
    map['CoverageArea'] = coverageArea;
    map['DeliveryFee'] = deliveryFee;
    map['MaxOrder'] = maxOrder;
    map['BranchIcon'] = branchIcon;
    map['CityId'] = cityId;
    map['CreatedOn'] = createdOn;
    map['CreatedBy'] = createdBy;
    map['ModefiedOn'] = modefiedOn;
    map['ModefiedBy'] = modefiedBy;
    map['DeletedOn'] = deletedOn;
    map['DeletedBy'] = deletedBy;
    map['DistrictId'] = districtId;
    map['IsActive'] = isActive;
    map['IsDeleted'] = isDeleted;
    map['ActivationReason'] = activationReason;
    return map;
  }
}
