class PaymentCreditParams {
  final String paymentType;
  final String description;
  final int amount;
  final int orderId;

  PaymentCreditParams({
    required this.paymentType,
    required this.description,
    required this.amount,
    required this.orderId,
  });

  Map<String, dynamic> toJson() => {
        'payment_type': paymentType,
        'description': description,
        'amount': amount,
        'order_id': orderId,
      };
}
