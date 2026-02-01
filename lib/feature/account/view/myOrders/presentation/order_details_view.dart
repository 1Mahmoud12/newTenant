import 'package:dobzz_seller/core/component/cache_image.dart';
import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:dobzz_seller/core/network/end_points.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/core/utils/errorLoadingWidgets/empty_widget.dart';
import 'package:dobzz_seller/core/utils/extensions.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/account/view/myOrders/data/models/order_detail_model.dart';
import 'package:dobzz_seller/feature/account/view/myOrders/manager/cubit/order_details_cubit.dart';
import 'package:dobzz_seller/feature/account/view/myOrders/presentation/expandable_section_container.dart';
import 'package:dobzz_seller/feature/product/views/presentation/product_details_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

enum EnumPaymentStatus {
  paid,
  unpaid,
}

class OrderDetailsScreen extends StatelessWidget {
  final int orderId;

  const OrderDetailsScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderDetailsCubit()..getOrderDetails(orderId),
      child: Scaffold(
        appBar: customAppBar(context: context, title: 'Order Details'.tr()),
        body: SafeArea(
          child: BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
            builder: (context, state) {
              if (state is OrderDetailsLoading) {
                return const OrderDetailsShimmer();
              } else if (state is OrderDetailsError) {
                return Center(
                  child: EmptyWidget(
                    data: state.error,
                    onTap: () {
                      context.read<OrderDetailsCubit>().getOrderDetails(orderId);
                    },
                  ),
                );
              } else if (state is OrderDetailsSuccess) {
                return _buildBody(state.order);
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(OrderDetailData order) {
    return SingleChildScrollView(
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
              children: order.product?.map((item) => OrderItem(item: item)).toList() ?? [],
            ),
          ),
          const SizedBox(height: 12),

          OrderInformation(order: order),
        ],
      ),
    );
  }
}

class OrderDetailsShimmer extends StatelessWidget {
  const OrderDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(height: 150, width: double.infinity, color: Colors.white),
            const SizedBox(height: 16),
            Container(height: 200, width: double.infinity, color: Colors.white),
            const SizedBox(height: 16),
            Container(height: 300, width: double.infinity, color: Colors.white),
          ],
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
  final OrderDetailData order;

  const StatusTimeline({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor;

    switch (order.orderStatusText?.toLowerCase()) {
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
              Expanded(
                child: Text(
                  '${'Order #'.tr()} ${order.orderId ?? order.id}',
                  style: TextStyle(
                    fontSize: Constants.tablet ? 20 : 20.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF333333),
                  ),
                ),
              ),
              //   const Spacer(),
              if (order.deliveryDate != null)
                Text(
                  order.deliveryDate != null
                      ? order
                          .deliveryDate! // DateFormat('MMM dd, yyyy').format(DateTime.parse(order.deliveryDate!)) // Assuming it comes formatted or handle parsing if needed
                      : 'Unknown date'.tr(),
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
                  order.orderStatusText ?? 'Unknown'.tr(),
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

class OrderItem extends StatelessWidget {
  final ProductItem item;

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
                    urlImage: '${EndPoints.domain}/${item.image}',
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
                    '${item.qty ?? 1}',
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
                          item.name ?? 'Unknown Product'.tr(),
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
                        '${_formatPrice(item.finalPrice)} EGP',
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

class OrderInformation extends StatelessWidget {
  final OrderDetailData order;

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
    final billing = order.billingInformations;
    final deliveryInfo = order.deliveryInformations;
    final itemsCount = order.product?.length ?? 0;

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
            value: billing?.name ?? deliveryInfo?.name ?? 'N/A',
          ),

          const SizedBox(height: 12),

          // Number (Order ID or Phone)
          _buildInfoRow(
            label: 'Number:'.tr(),
            value: billing?.phone ?? deliveryInfo?.phone ?? order.orderId ?? 'Unknown',
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
            value: deliveryInfo != null
                ? [
                    deliveryInfo.name,
                    deliveryInfo.address,
                    deliveryInfo.city,
                    deliveryInfo.state,
                    deliveryInfo.postCode,
                    deliveryInfo.country,
                  ].where((e) => e != null && e.isNotEmpty).join(', ')
                : billing != null
                    ? [
                        billing.address,
                        billing.city,
                        billing.state,
                        billing.postCode,
                        billing.country,
                      ].where((e) => e != null && e.isNotEmpty).join(', ')
                    : 'Unknown',
          ),

          const SizedBox(height: 12),

          // Payment Method
          _buildInfoRow(
            label: 'Payment method:'.tr(),
            value: order.paymentType?.capitalize() ?? '',
          ),

          // const SizedBox(height: 12),

          // Payment Status
          // _buildInfoRow(
          //   label: 'Payment Status:'.tr(),
          //   value: order.paymentStatus?.capitalize() ?? 'Unknown',
          //   action: EnumPaymentStatus.unpaid.name ==
          //           (order.paymentStatus?.toLowerCase() ?? '')
          //       ? InkWell(
          //           onTap: () => selectPaymentMethodDialog(
          //             context,
          //             orderId: order.id,
          //             onPress: (paymentMethodName) {},
          //           ),
          //           child: SvgPicture.asset(AppIcons.retryPayIc),
          //         )
          //       : const SizedBox(),
          // ),

          const SizedBox(height: 12),

          // Subtotal
          _buildInfoRow(
            label: 'Subtotal'.tr(),
            value: '${_formatPrice(order.subTotal)} Rial',
          ),

          const SizedBox(height: 12),

          // Total
          _buildInfoRow(
            label: 'Total'.tr(),
            value: '${_formatPrice(order.finalPrice)} Rial',
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
              fontSize: 16.sp,
              color: valueColor ?? const Color(0xFF333333),
              fontWeight: valueFontWeight ?? FontWeight.w500,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        if (action != null) ...[
          const SizedBox(width: 8),
          action,
        ],
      ],
    );
  }
}
