class PaymentCreditParams {
  final String amount;
  final String orderId;

  PaymentCreditParams({
    required this.amount,
    required this.orderId,
  });

  Map<String, dynamic> toJson() => {
        'payment_type': 'invoice',
        'description': 'Payment for order #$orderId',
        'amount': amount,
        'order_id': orderId,
      };
}
