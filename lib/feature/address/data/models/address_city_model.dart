class AddressCityModel {
  String? name;
  int? id;
  int? stateId;
  int? countryId;

  AddressCityModel({this.name, this.id, this.stateId, this.countryId});

  AddressCityModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    stateId = json['state_id'];
    countryId = json['country_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['state_id'] = stateId;
    data['country_id'] = countryId;
    return data;
  }
}
