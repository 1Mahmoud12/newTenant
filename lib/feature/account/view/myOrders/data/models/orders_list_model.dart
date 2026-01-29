class OrdersListModel {
  int? maxPrice;
  int? status;
  String? message;
  OrdersData? data;

  OrdersListModel({
    this.maxPrice,
    this.status,
    this.message,
    this.data,
  });

  factory OrdersListModel.fromJson(Map<String, dynamic> json) {
    return OrdersListModel(
      maxPrice: json['max_price'],
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? OrdersData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'max_price': maxPrice,
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}

class OrdersData {
  int? currentPage;
  List<OrderItem>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<PaginationLink>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  OrdersData({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory OrdersData.fromJson(Map<String, dynamic> json) {
    return OrdersData(
      currentPage: json['current_page'],
      data: json['data'] != null ? List<OrderItem>.from(json['data'].map((x) => OrderItem.fromJson(x))) : null,
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'],
      lastPageUrl: json['last_page_url'],
      links: json['links'] != null ? List<PaginationLink>.from(json['links'].map((x) => PaginationLink.fromJson(x))) : null,
      nextPageUrl: json['next_page_url'],
      path: json['path'],
      perPage: json['per_page'],
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() => {
        'current_page': currentPage,
        'data': data?.map((x) => x.toJson()).toList(),
        'first_page_url': firstPageUrl,
        'from': from,
        'last_page': lastPage,
        'last_page_url': lastPageUrl,
        'links': links?.map((x) => x.toJson()).toList(),
        'next_page_url': nextPageUrl,
        'path': path,
        'per_page': perPage,
        'prev_page_url': prevPageUrl,
        'to': to,
        'total': total,
      };
}

class OrderItem {
  int? id;
  String? orderDate;
  String? deliveryDate;
  String? productOrderId;
  String? date;
  num? amount;
  int? deliveryId;
  int? deliveredStatus;
  int? returnStatus;
  int? rewardPoints;
  String? themeId;
  String? demoField;
  String? deliveredStatusString;
  String? deliveredImage;
  String? orderIdString;
  String? returnDate;
  String? userName;

  OrderItem({
    this.id,
    this.orderDate,
    this.deliveryDate,
    this.productOrderId,
    this.date,
    this.amount,
    this.deliveryId,
    this.deliveredStatus,
    this.returnStatus,
    this.rewardPoints,
    this.themeId,
    this.demoField,
    this.deliveredStatusString,
    this.deliveredImage,
    this.orderIdString,
    this.returnDate,
    this.userName,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderDate: json['order_date'],
      deliveryDate: json['delivery_date'],
      productOrderId: json['product_order_id'],
      date: json['date'],
      amount: json['amount'],
      deliveryId: json['delivery_id'],
      deliveredStatus: json['delivered_status'],
      returnStatus: json['return_status'],
      rewardPoints: json['reward_points'],
      themeId: json['theme_id'],
      demoField: json['demo_field'],
      deliveredStatusString: json['delivered_status_string'],
      deliveredImage: json['delivered_image'],
      orderIdString: json['order_id_string'],
      returnDate: json['return_date'],
      userName: json['user_name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_date': orderDate,
        'delivery_date': deliveryDate,
        'product_order_id': productOrderId,
        'date': date,
        'amount': amount,
        'delivery_id': deliveryId,
        'delivered_status': deliveredStatus,
        'return_status': returnStatus,
        'reward_points': rewardPoints,
        'theme_id': themeId,
        'demo_field': demoField,
        'delivered_status_string': deliveredStatusString,
        'delivered_image': deliveredImage,
        'order_id_string': orderIdString,
        'return_date': returnDate,
        'user_name': userName,
      };
}

class PaginationLink {
  String? url;
  String? label;
  bool? active;

  PaginationLink({
    this.url,
    this.label,
    this.active,
  });

  factory PaginationLink.fromJson(Map<String, dynamic> json) {
    return PaginationLink(
      url: json['url'],
      label: json['label'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() => {
        'url': url,
        'label': label,
        'active': active,
      };
}
