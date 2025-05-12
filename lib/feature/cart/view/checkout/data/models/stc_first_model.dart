class StcFirstModel {
  StcFirstModel({
    this.status,
    this.message,
    this.paymentId,
    this.transactionUrl,
    this.referenceNumber,
  });

  StcFirstModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    paymentId = json['payment_id'];
    transactionUrl = json['transaction_url'];
    referenceNumber = json['reference_number'];
  }

  bool? status;
  String? message;
  String? paymentId;
  String? transactionUrl;
  String? referenceNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['payment_id'] = paymentId;
    map['transaction_url'] = transactionUrl;
    map['reference_number'] = referenceNumber;
    return map;
  }
}
