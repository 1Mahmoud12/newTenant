enum WalletStatus {
  Refund,
  Recharge,
  Payment,
}

enum OrderStatus {
  Pending,
  Declined,
  Completed,
  ScheduledPickedUp,
  ScheduledDelivered,
  Delivered,
  ReadyForDelivery,
  Cancelled,
}

List<int> orderStatusID = [
  6,
  15,
  1,
  4,
  10,
  11,
  13,
  3,
];

enum OrderInvoice { other, vat, DeliveryFees, FastCharge, Commission }
