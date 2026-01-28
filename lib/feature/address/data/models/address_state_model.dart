class AddressStateModel {
  String? name;
  int? id;
  int? countryId;

  AddressStateModel({this.name, this.id, this.countryId});

  AddressStateModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    countryId = json['country_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['country_id'] = countryId;
    return data;
  }
}
