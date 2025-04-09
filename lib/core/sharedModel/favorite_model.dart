class FavoriteModel {
  int? id;
  int? projectId;
  int? clientId;
  String? createdAt;
  String? updatedAt;

  FavoriteModel({
    this.id,
    this.projectId,
    this.clientId,
    this.createdAt,
    this.updatedAt,
  });

  FavoriteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projectId = json['project_id'];
    clientId = json['client_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['project_id'] = projectId;
    data['client_id'] = clientId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
