import 'package:mamlaka/core/utils/constants.dart';

class RegisterModel {
  RegisterModel({
    this.statusCode,
    this.message,
    this.messageAr,
    this.data,
  });

  RegisterModel.fromJson(dynamic json) {
    statusCode = json['StatusCode'];
    message = json['Message'];
    messageAr = json['MessageAr'];
    data = json['Data'] != null ? Data.fromJson(json['Data']) : null;
  }

  int? statusCode;
  String? message;
  String? messageAr;
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['StatusCode'] = statusCode;
    map['Message'] = message;
    map['MessageAr'] = messageAr;
    if (data != null) {
      map['Data'] = data?.toJson();
    }
    return map;
  }
}

class Data {
  Data({
    this.id,
    this.userName,
    this.fullName,
    this.phone,
    this.email,
    this.token,
    this.birthDate,
    this.imageUrl,
    this.chatStatusId,
  });

  Data.fromJson(dynamic json) {
    id = json['Id'];
    userName = json['UserName'];
    fullName = json['FullName'];
    phone = json['Phone'];
    email = json['Email'];
    token = json['token'] ?? Constants.token;
    birthDate = json['BirthDate'];
    imageUrl = json['ImageUrl'];
    chatStatusId = json['ChatStatusId'];
  }

  int? id;
  String? userName;
  String? fullName;
  String? phone;
  String? email;
  String? token;
  String? birthDate;
  String? imageUrl;
  int? chatStatusId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = id;
    map['UserName'] = userName;
    map['FullName'] = fullName;
    map['Phone'] = phone;
    map['Email'] = email;
    map['token'] = token;
    map['BirthDate'] = birthDate;
    map['ImageUrl'] = imageUrl;
    map['ChatStatusId'] = chatStatusId;
    return map;
  }
}
