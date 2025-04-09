class CountryCodeModel {
  CountryCodeModel({
    this.statusCode,
    this.message,
    this.messageAr,
    this.data,
  });

  CountryCodeModel.fromJson(dynamic json) {
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
    this.country,
    this.code,
    this.flagUrl,
  });

  Data.fromJson(dynamic json) {
    id = json['Id'];
    country = json['Country'];
    code = json['Code'];
    flagUrl = json['FlagUrl'];
  }

  int? id;
  String? country;
  String? code;
  String? flagUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = id;
    map['Country'] = country;
    map['Code'] = code;
    map['FlagUrl'] = flagUrl;
    return map;
  }
}
