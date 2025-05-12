class PaymentStcFirstParams {
  String? amount;
  String? orderId;
  String? mobile;

  PaymentStcFirstParams({
    this.amount,
    this.orderId,
    this.mobile,
  });

  Map<String, dynamic> toJson() => {
        'payment_type': 'stc',
        'description': 'Payment for order #$orderId',
        'amount': amount,
        'order_id': orderId,
        'source': {
          'mobile': mobile,
        },
      };
}
