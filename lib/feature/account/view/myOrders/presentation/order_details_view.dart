import 'package:dobzz_seller/core/component/cache_image.dart';
import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:dobzz_seller/core/services/payment/select_payment_method_dialog.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/app_icons.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/core/utils/extensions.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/account/view/myOrders/data/models/order_model.dart';
import 'package:dobzz_seller/feature/account/view/myOrders/presentation/expandable_section_container.dart';
import 'package:dobzz_seller/feature/product/views/presentation/product_details_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum EnumPaymentStatus {
  paid,
  unpaid,
}

class OrderDetailsScreen extends StatelessWidget {
  final OrderData order;

  const OrderDetailsScreen({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[50],
      appBar: customAppBar(context: context, title: 'Order Details'.tr()),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Timeline
              StatusTimeline(order: order),

              const SizedBox(height: 12),
              SectionContainer(
                title: 'Order Items'.tr(),
                isExpandable: true,
                child: Column(
                  children: order.items?.map((item) => OrderItem(item: item)).toList() ?? [],
                ),
              ),
              const SizedBox(height: 12),

              OrderInformation(order: order),
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

    switch (order.status?.toLowerCase()) {
      case 'pending':
        statusColor = const Color(0xFFFF9800); // Orange
        break;
      case 'processing':
        statusColor = const Color(0xFF2196F3); // Blue
        break;
      case 'shipped':
        statusColor = const Color(0xFF3F51B5); // Indigo
        break;
      case 'delivered':
        statusColor = const Color(0xFF4CAF50); // Green
        break;
      case 'canceled':
        statusColor = const Color(0xFFF44336); // Red
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${'Order #'.tr()}${order.id}',
                style: TextStyle(
                  fontSize: Constants.tablet ? 20 : 20.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF333333),
                ),
              ),
              const Spacer(),
              Text(
                order.createdAt != null ? DateFormat('MMM dd, yyyy').format(DateTime.parse(order.createdAt!)) : 'Unknown date'.tr(),
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Your order is being processed'.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacityNew(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.status ?? 'Unknown'.tr(),
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Thank you for your order!'.tr(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.green[600],
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
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('No address information available'.tr()),
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
                  color: Colors.blue.withOpacityNew(0.1),
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
                      address!.name ?? 'Unknown'.tr(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      address!.phone ?? 'No phone number'.tr(),
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
                  color: Colors.green.withOpacityNew(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.location_on_outlined, size: 18, color: Colors.green),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Address'.tr(),
                      style: const TextStyle(
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
            color: iconColor.withOpacityNew(0.1),
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
        return 'Credit/Debit Card'.tr();
      case 'cash':
        return 'Cash on Delivery'.tr();
      default:
        return method;
    }
  }

  String _formatPaymentStatus(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return 'Paid'.tr();
      case 'unpaid':
        return 'Unpaid'.tr();
      case 'refunded':
        return 'Refunded'.tr();
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
            label: 'Payment Method'.tr(),
            value: _formatPaymentMethod(order.paymentMethod ?? 'Unknown'.tr()),
          ),
          const SizedBox(height: 16),
          InfoRow(
            icon: Icons.account_balance_wallet_outlined,
            iconColor: Colors.orange,
            label: 'Payment Status'.tr(),
            value: _formatPaymentStatus(order.paymentStatus ?? 'Unknown'.tr()),
          ),
          if (order.isPreorder == true) ...[
            const SizedBox(height: 16),
            InfoRow(
              icon: Icons.calendar_today_outlined,
              iconColor: Colors.blue,
              label: 'Order Type'.tr(),
              value: 'Pre-order'.tr(),
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
            variants: const [],
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          color: AppColors.white,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          children: [
            // Product Image
            Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CacheImage(
                    urlImage: item.productThumbnailPath ?? '',
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.cTextDate,
                  ),
                  child: Text(
                    '${item.quantity ?? 1}',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700, color: AppColors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.product ?? 'Unknown Product'.tr(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Container(
                      //   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      //   decoration: BoxDecoration(
                      //     color: Colors.grey[100],
                      //     borderRadius: BorderRadius.circular(4),
                      //   ),
                      //   child: Text(
                      //     'x${item.quantity ?? 1}',
                      //     style: TextStyle(
                      //       fontSize: 13,
                      //       color: Colors.grey[700],
                      //     ),
                      //   ),
                      // ),
                      // const Spacer(),
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
            const SizedBox(width: 12),
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
                'Subtotal'.tr(),
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
                  'Items'.tr(),
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
              Text(
                'Total'.tr(),
                style: const TextStyle(
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

class OrderInformation extends StatelessWidget {
  final OrderData order;

  const OrderInformation({Key? key, required this.order}) : super(key: key);

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
    final address = order.address;
    final itemsCount = order.items?.length ?? 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order information'.tr(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),

          // Name
          _buildInfoRow(
            label: 'Name:'.tr(),
            value: order.customer ?? 'N/A',
          ),

          const SizedBox(height: 12),

          // Number (Order ID or Phone)
          _buildInfoRow(
            label: 'Number:'.tr(),
            value: address?.phone ?? order.id?.toString() ?? 'Unknown',
          ),

          const SizedBox(height: 12),

          // Items Count
          _buildInfoRow(
            label: 'Items:'.tr(),
            value: itemsCount.toString(),
          ),

          const SizedBox(height: 12),

          // Shipping Address
          _buildInfoRow(
            label: 'Shipping Address:'.tr(),
            value: address != null
                ? [
                    address.address,
                    address.city,
                    address.state,
                    address.pinCode,
                    address.country,
                  ].where((e) => e != null && e.isNotEmpty).join(', ')
                : 'Unknown',
          ),

          const SizedBox(height: 12),

          // Payment Method
          _buildInfoRow(
            label: 'Payment method:'.tr(),
            value: order.paymentMethod?.capitalize() ?? '',
          ),

          const SizedBox(height: 12),

          // Payment Status
          _buildInfoRow(
            label: 'Payment Status:'.tr(),
            value: order.paymentStatus?.capitalize() ?? 'Unknown',
            action: EnumPaymentStatus.unpaid.name == (order.paymentStatus ?? '').toLowerCase()
                ? InkWell(
                    onTap: () => selectPaymentMethodDialog(
                      context,
                      orderId: order.id,
                      onPress: (paymentMethodName) {},
                    ),
                    child: SvgPicture.asset(AppIcons.retryPayIc),
                  )
                : const SizedBox(),
          ),

          const SizedBox(height: 12),

          // Subtotal
          _buildInfoRow(
            label: 'Subtotal'.tr(),
            value: '${_formatPrice(order.totalPrice)} Rial',
          ),

          const SizedBox(height: 12),

          // Total
          _buildInfoRow(
            label: 'Total'.tr(),
            value: '${_formatPrice(order.totalPrice)} Rial',
            valueColor: Colors.red,
            valueFontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    Color? valueColor,
    FontWeight? valueFontWeight,
    Widget? action,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: valueFontWeight ?? FontWeight.normal,
              color: valueColor ?? const Color(0xFF333333),
            ),
          ),
        ),
        action ?? const SizedBox(),
      ],
    );
  }
}

// Extension to capitalize first letter of string
extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
