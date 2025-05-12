class StcSecondModel {
  StcSecondModel({
    this.message,
    this.payment,
  });

  StcSecondModel.fromJson(dynamic json) {
    message = json['message'];
    payment = json['payment'] != null ? Payment.fromJson(json['payment']) : null;
  }

  String? message;
  Payment? payment;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (payment != null) {
      map['payment'] = payment?.toJson();
    }
    return map;
  }
}

class Payment {
  Payment({
    this.id,
    this.status,
    this.amount,
    this.fee,
    this.currency,
    this.refunded,
    this.refundedAt,
    this.captured,
    this.capturedAt,
    this.voidedAt,
    this.description,
    this.amountFormat,
    this.feeFormat,
    this.refundedFormat,
    this.capturedFormat,
    this.invoiceId,
    this.ip,
    this.callbackUrl,
    this.createdAt,
    this.updatedAt,
    this.metadata,
    this.source,
  });

  Payment.fromJson(dynamic json) {
    id = json['id'];
    status = json['status'];
    amount = json['amount'];
    fee = json['fee'];
    currency = json['currency'];
    refunded = json['refunded'];
    refundedAt = json['refunded_at'];
    captured = json['captured'];
    capturedAt = json['captured_at'];
    voidedAt = json['voided_at'];
    description = json['description'];
    amountFormat = json['amount_format'];
    feeFormat = json['fee_format'];
    refundedFormat = json['refunded_format'];
    capturedFormat = json['captured_format'];
    invoiceId = json['invoice_id'];
    ip = json['ip'];
    callbackUrl = json['callback_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    metadata = json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
    source = json['source'] != null ? Source.fromJson(json['source']) : null;
  }

  String? id;
  String? status;
  num? amount;
  num? fee;
  String? currency;
  num? refunded;
  dynamic refundedAt;
  num? captured;
  dynamic capturedAt;
  dynamic voidedAt;
  String? description;
  String? amountFormat;
  String? feeFormat;
  String? refundedFormat;
  String? capturedFormat;
  dynamic invoiceId;
  dynamic ip;
  dynamic callbackUrl;
  String? createdAt;
  String? updatedAt;
  Metadata? metadata;
  Source? source;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['status'] = status;
    map['amount'] = amount;
    map['fee'] = fee;
    map['currency'] = currency;
    map['refunded'] = refunded;
    map['refunded_at'] = refundedAt;
    map['captured'] = captured;
    map['captured_at'] = capturedAt;
    map['voided_at'] = voidedAt;
    map['description'] = description;
    map['amount_format'] = amountFormat;
    map['fee_format'] = feeFormat;
    map['refunded_format'] = refundedFormat;
    map['captured_format'] = capturedFormat;
    map['invoice_id'] = invoiceId;
    map['ip'] = ip;
    map['callback_url'] = callbackUrl;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (metadata != null) {
      map['metadata'] = metadata?.toJson();
    }
    if (source != null) {
      map['source'] = source?.toJson();
    }
    return map;
  }
}

class Source {
  Source({
    this.type,
    this.mobile,
    this.referenceNumber,
    this.branch,
    this.cashier,
    this.transactionUrl,
    this.message,
  });

  Source.fromJson(dynamic json) {
    type = json['type'];
    mobile = json['mobile'];
    referenceNumber = json['reference_number'];
    branch = json['branch'];
    cashier = json['cashier'];
    transactionUrl = json['transaction_url'];
    message = json['message'];
  }

  String? type;
  String? mobile;
  String? referenceNumber;
  String? branch;
  String? cashier;
  String? transactionUrl;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    map['mobile'] = mobile;
    map['reference_number'] = referenceNumber;
    map['branch'] = branch;
    map['cashier'] = cashier;
    map['transaction_url'] = transactionUrl;
    map['message'] = message;
    return map;
  }
}

class Metadata {
  Metadata({
    this.orderId,
  });

  Metadata.fromJson(dynamic json) {
    orderId = json['order_id'];
  }

  num? orderId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['order_id'] = orderId;
    return map;
  }
}
