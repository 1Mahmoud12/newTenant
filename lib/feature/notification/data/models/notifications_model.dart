class NotificationsModel {
  NotificationsModel({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  final bool? status;
  final num? code;
  final String? message;
  final List<ItemsNotificationModel> data;

  factory NotificationsModel.fromJson(Map<String, dynamic> json) {
    return NotificationsModel(
      status: json['status'],
      code: json['code'],
      message: json['message'],
      data: json['data'] == null ? [] : List<ItemsNotificationModel>.from(json['data']!.map((x) => ItemsNotificationModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'code': code,
        'message': message,
        'data': data.map((x) => x.toJson()).toList(),
      };
}

class ItemsNotificationModel {
  ItemsNotificationModel({
    required this.id,
    required this.title,
    required this.body,
  });

  final String? id;
  final String? title;
  final String? body;

  factory ItemsNotificationModel.fromJson(Map<String, dynamic> json) {
    return ItemsNotificationModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
      };
}
