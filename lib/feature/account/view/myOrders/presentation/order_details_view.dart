import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/account/view/myOrders/data/models/order_model.dart';
import 'package:dobzz_seller/feature/account/view/myOrders/presentation/expandable_section_container.dart';
import 'package:dobzz_seller/feature/product/views/presentation/product_details_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderData order;

  const OrderDetailsScreen({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Order #${order.id}',
          style: const TextStyle(fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Timeline
              StatusTimeline(order: order),

              const SizedBox(height: 12),

              // Delivery Information
              SectionContainer(
                title: 'Delivery Information',
                child: AddressInfo(address: order.address),
              ),

              const SizedBox(height: 12),

              // Order Summary
              SectionContainer(
                title: 'Payment Information',
                child: PaymentInfo(order: order),
              ),

              const SizedBox(height: 12),

              SectionContainer(
                title: 'Order Items',
                isExpandable: true,
                child: Column(
                  children: order.items?.map((item) => OrderItem(item: item)).toList() ?? [],
                ),
              ),

              const SizedBox(height: 12),

              // Total Summary
              SectionContainer(
                title: 'Order Total',
                child: TotalSummary(order: order),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionContainer extends StatelessWidget {
  final String title;
  final Widget child;
  final bool isExpandable;
  final int initialVisibleItems;

  const SectionContainer({
    Key? key,
    required this.title,
    required this.child,
    this.isExpandable = false,
    this.initialVisibleItems = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isExpandable) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF303030),
                ),
              ),
            ),
            const Divider(height: 1),
            child,
          ],
        ),
      );
    }

    return ExpandableSectionContainer(
      title: title,
      initialVisibleItems: initialVisibleItems,
      child: child,
    );
  }
}

class StatusTimeline extends StatelessWidget {
  final OrderData order;

  const StatusTimeline({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;

    switch (order.status?.toLowerCase()) {
      case 'pending':
        statusColor = const Color(0xFFFF9800);
        statusText = 'Your order is being processed';
        break;
      case 'processing':
        statusColor = const Color(0xFF2196F3);
        statusText = 'Your order is being prepared';
        break;
      case 'shipped':
        statusColor = const Color(0xFF3F51B5);
        statusText = 'Your order is on its way';
        break;
      case 'delivered':
        statusColor = const Color(0xFF4CAF50);
        statusText = 'Your order has been delivered';
        break;
      case 'canceled':
        statusColor = const Color(0xFFF44336);
        statusText = 'Your order has been canceled';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Order status unknown';
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [statusColor.withOpacity(0.8), statusColor.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.status?.toUpperCase() ?? 'UNKNOWN',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                order.createdAt != null ? DateFormat('MMM dd, yyyy').format(DateTime.parse(order.createdAt!)) : 'Unknown date',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            statusText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Thank you for your order',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class AddressInfo extends StatelessWidget {
  final Address? address;

  const AddressInfo({Key? key, this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (address == null) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('No address information available'),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.person_outline, size: 18, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address!.name ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      address!.phone ?? 'No phone number',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.location_on_outlined, size: 18, color: Colors.green),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Delivery Address',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      [
                        address!.address,
                        address!.city,
                        address!.state,
                        address!.country,
                        address!.pinCode,
                      ].where((e) => e != null && e.isNotEmpty).join(', '),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const InfoRow({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PaymentInfo extends StatelessWidget {
  final OrderData order;

  const PaymentInfo({Key? key, required this.order}) : super(key: key);

  String _formatPaymentMethod(String method) {
    switch (method.toLowerCase()) {
      case 'card':
        return 'Credit/Debit Card';
      case 'cash':
        return 'Cash on Delivery';
      default:
        return method;
    }
  }

  String _formatPaymentStatus(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return 'Paid';
      case 'unpaid':
        return 'Unpaid';
      case 'refunded':
        return 'Refunded';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          InfoRow(
            icon: Icons.payment_outlined,
            iconColor: Colors.purple,
            label: 'Payment Method',
            value: _formatPaymentMethod(order.paymentMethod ?? 'Unknown'),
          ),
          const SizedBox(height: 16),
          InfoRow(
            icon: Icons.account_balance_wallet_outlined,
            iconColor: Colors.orange,
            label: 'Payment Status',
            value: _formatPaymentStatus(order.paymentStatus ?? 'Unknown'),
          ),
          if (order.isPreorder == true) ...[
            const SizedBox(height: 16),
            const InfoRow(
              icon: Icons.calendar_today_outlined,
              iconColor: Colors.blue,
              label: 'Order Type',
              value: 'Pre-order',
            ),
          ],
        ],
      ),
    );
  }
}

class OrderItem extends StatelessWidget {
  final Items item;

  const OrderItem({Key? key, required this.item}) : super(key: key);

  String _formatPrice(String? price) {
    if (price == null) return '0.00';

    try {
      final double value = double.parse(price);
      return value.toStringAsFixed(2);
    } catch (e) {
      return price;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.navigateToPage(
          ProductDetailsView(
            productId: item.productId ?? -1,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: item.productThumbnailPath ?? '',
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported_outlined, size: 20),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product ?? 'Unknown Product',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'x${item.quantity ?? 1}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${_formatPrice(item.price)} EGP',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TotalSummary extends StatelessWidget {
  final OrderData order;

  const TotalSummary({Key? key, required this.order}) : super(key: key);

  String _formatPrice(String? price) {
    if (price == null) return '0.00';

    try {
      final double value = double.parse(price);
      return value.toStringAsFixed(2);
    } catch (e) {
      return price;
    }
  }

  String _calculateSubtotal() {
    if (order.items == null || order.items!.isEmpty) {
      return _formatPrice(order.totalPrice);
    }

    double total = 0;
    for (final item in order.items!) {
      if (item.price != null) {
        total += double.tryParse(item.price!) ?? 0;
      }
    }

    return '${total.toStringAsFixed(2)} EGP';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                _calculateSubtotal(),
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          if (order.items != null && order.items!.length > 1) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Items',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '${order.items?.length ?? 0}',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${_formatPrice(order.totalPrice)} EGP',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
