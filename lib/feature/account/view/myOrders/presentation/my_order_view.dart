import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:dobzz_seller/core/component/fields/custom_text_form_field.dart';
import 'package:dobzz_seller/core/component/loadsErros/loading_widget.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/core/utils/errorLoadingWidgets/empty_widget.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/account/view/myOrders/data/models/order_model.dart';
import 'package:dobzz_seller/feature/account/view/myOrders/presentation/manager/order/cubit/order_cubit.dart';
import 'package:dobzz_seller/feature/account/view/myOrders/presentation/order_details_view.dart';
import 'package:dobzz_seller/feature/account/view/myOrders/presentation/track_order_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyOrderView extends StatefulWidget {
  const MyOrderView({super.key});

  @override
  State<MyOrderView> createState() => _MyOrderViewState();
}

class _MyOrderViewState extends State<MyOrderView> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  OrderCubit orderCubit = OrderCubit();

  @override
  void initState() {
    orderCubit.getOrders(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: 'My Orders'.tr()),
      body: SafeArea(
        child: BlocProvider.value(
          value: orderCubit,
          child: BlocBuilder<OrderCubit, OrderState>(
            builder: (context, state) {
              if (state is OrderLoading) {
                return const Center(child: LoadingWidget());
              }
              if (state is OrderError) {
                return Center(
                  child: Text(
                    state.e,
                    style: TextStyle(fontSize: Constants.tablet ? 16 : 16.sp, color: Colors.red),
                  ),
                );
              }
              if (state is OrderSuccess) {
                return Column(
                  children: [
                    Expanded(
                      child: ConstantsModels.orderModel?.data?.isEmpty ?? true
                          ?  Center(
                              child: EmptyWidget(
                                data: 'No Ongoing Orders!'.tr(),
                                subData: 'You don’t have any ongoing orders at this time.'.tr(),
                                emptyImage: EmptyImages.noOrders,
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: ConstantsModels.orderModel?.data?.length ?? 0,
                              itemBuilder: (context, index) {
                                return OrderCard(
                                  order: ConstantsModels.orderModel?.data![index] ?? OrderData(),
                                  onViewDetails: () {
                                    context.navigateToPage(
                                      OrderDetailsScreen(
                                        order: ConstantsModels.orderModel?.data![index] ?? OrderData(),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final OrderData order;
  final Function()? onViewDetails;

  const OrderCard({
    Key? key,
    required this.order,
    this.onViewDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = order.items ?? [];
    final status = order.status ?? 'unknown'.tr();
    final statusColor = _getStatusColor(status);
    final paymentStatus = order.paymentStatus ?? 'unknown'.tr();
    final paymentMethod = order.paymentMethod ?? 'unknown'.tr();

    DateTime? createdAt;
    try {
      createdAt = DateTime.parse(order.createdAt ?? '');
    } catch (e) {
      createdAt = DateTime.now();
    }

    final dateFormatted = DateFormat('MMM dd, yyyy').format(createdAt);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.1),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.withOpacity(0.1),
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with order number and status
            _buildHeader(statusColor),
            const SizedBox(height: 5),
            // Order details
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product images
                  _buildProductImages(items),

                  const SizedBox(height: 12),

                  // Order info
                  _buildOrderInfo(
                    items,
                    dateFormatted,
                    paymentMethod,
                    paymentStatus,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // Shipping address summary
                  if (order.address != null) _buildAddressSummary(order.address!),

                  const SizedBox(height: 10),

                  // Payment info
                  _buildPaymentInfo(order.totalPrice ?? '0.00'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Header with order number and status
  Widget _buildHeader(Color statusColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.2))),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long, size: 18),
              const SizedBox(width: 6),
              Text(
                '${'Order'.tr()} #${order.id}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: statusColor),
            ),
            child: Center(
              child: Text(
                (order.status ?? '').toUpperCase(),
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Stacked product images
  Widget _buildProductImages(List<Items> items) {
    if (items.isEmpty) {
      return  SizedBox(
        height: 120,
        child: Center(
          child: Text('No items available'.tr()),
        ),
      );
    }

    return SizedBox(
      height: 120,
      child: Stack(
        children: [
          // Show at most 3 images with a counter for additional items
          ...List.generate(
            items.length > 3 ? 3 : items.length,
            (index) {
              final horizontalOffset = index * 60.0;

              return Positioned(
                left: horizontalOffset,
                child: Container(
                  width: 100,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Image.network(
                      items[index].productImagePath ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Icon(Icons.image_not_supported),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),

          // Additional items counter
          if (items.length > 3)
            Positioned(
              left: 180,
              child: Container(
                width: 100,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    '+${items.length - 3}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Order information (items, total, date)
  Widget _buildOrderInfo(
    List items,
    String date,
    String paymentMethod,
    String paymentStatus,
  ) {
    final paymentStatusColor = paymentStatus == 'paid' ? Colors.green : Colors.orange;
    final paymentIcon = paymentMethod == 'card' ? Icons.credit_card : Icons.money;
    // Limit to at most 3 items
    final limitedItems = items.take(3).toList();
    final remainingCount = items.length - limitedItems.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Items list
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${items.length} ${items.length > 1 ? 'Items'.tr() : 'Item'.tr()}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            ...limitedItems.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  '• ${item.product ?? 'Unknown'.tr()} (${item.quantity ?? 1}x)',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            if (remainingCount > 0)
              Text(
                '• +$remainingCount ${'more...'.tr()}',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontStyle: FontStyle.italic,
                  fontSize: 13,
                ),
              ),
          ],
        ),

        const SizedBox(height: 5),

        // Price and date
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(paymentIcon, size: 16, color: Colors.grey.shade700),
                const SizedBox(width: 4),
                Text(
                  paymentMethod.toUpperCase(),
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: paymentStatusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Icon(
                    paymentStatus == 'paid' ? Icons.check_circle : Icons.pending,
                    size: 14,
                    color: paymentStatusColor,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    paymentStatus.toUpperCase(),
                    style: TextStyle(
                      color: paymentStatusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Text(
              date,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Address summary
  Widget _buildAddressSummary(Address address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 5,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.location_on_outlined, size: 16, color: Colors.grey.shade700),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                '${'Shipping to:'.tr()} ${address.name ?? 'N/A'}, ${address.city ?? ''}, ${address.state ?? ''}, ${address.country ?? ''}',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 13,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Payment information
  Widget _buildPaymentInfo(String totalPrice) {
    return Row(
      children: [
        Text(
          _formatCurrency(totalPrice),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17.sp,
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 3,
          child: CustomTextButton(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            onPress: onViewDetails,
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Details'.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Single View Details button

  // Helper methods
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.amber;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.indigo;
      case 'delivered':
        return Colors.green;
      case 'canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatCurrency(String price) {
    try {
      final double amount = double.parse(price);
      return 'EGP ${amount.toStringAsFixed(2)}';
    } catch (e) {
      return 'EGP 0.00';
    }
  }
}

// Example usage in a page:
class OrdersPage extends StatelessWidget {
  final List<OrderData> orders;

  const OrdersPage({Key? key, required this.orders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: orders.isEmpty
          ? const Center(child: Text('No orders found'))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return OrderCard(
                  order: orders[index],
                  onViewDetails: () {
                    // Navigate to order details page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailsPage(order: orders[index]),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

// Placeholder for OrderDetailsPage
class OrderDetailsPage extends StatelessWidget {
  final OrderData order;

  const OrderDetailsPage({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${order.id}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Detailed order information would go here
            Text('Order Details', style: Theme.of(context).textTheme.headlineSmall),
            // ...more widgets
          ],
        ),
      ),
    );
  }
}
// Example usage in a page:
// Placeholder for OrderDetailsPage

class ReviewWidget extends StatelessWidget {
  const ReviewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showReviewBottomSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.star, color: Colors.amber, size: 16.sp),
            const SizedBox(width: 4),
            Text(
              '4.0/5',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showReviewBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return const ReviewBottomSheet();
      },
    );
  }
}

class ReviewBottomSheet extends StatefulWidget {
  const ReviewBottomSheet({Key? key}) : super(key: key);

  @override
  _ReviewBottomSheetState createState() => _ReviewBottomSheetState();
}

class _ReviewBottomSheetState extends State<ReviewBottomSheet> {
  double _rating = 0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(20)),
                  height: 7,
                  width: 90,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Leave a Review',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'How was your order?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Please give your rating and also your review.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: RatingBar.builder(
                  minRating: 1,
                  unratedColor: Colors.grey.shade300,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star_rounded,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              CustomTextFormField(
                controller: _reviewController,
                hintText: 'Write your review...',
                maxLines: 5,
                outPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle submit logic here
                    // print('Rating: $_rating');
                    // print('Review: ${_reviewController.text}');
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderStatus extends StatelessWidget {
  const OrderStatus({
    super.key,
    required this.isItCompleted,
  });

  final bool isItCompleted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isItCompleted ? const Color(0xff0C9409).withOpacity(0.2) : const Color(0xffE6E6E6),
      ),
      child: Text(
        isItCompleted ? 'Completed' : 'In Transit',
        style: TextStyle(
          color: isItCompleted ? const Color(0xff0C9409) : Colors.black,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class TrackOrder extends StatelessWidget {
  const TrackOrder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.navigateToPage(const TrackOrderView());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.black,
        ),
        child: Text(
          'Track order',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class OrderItem {
  final String name;
  final String size;
  final String price;

  OrderItem({
    required this.name,
    required this.size,
    required this.price,
  });
}

// Padding(
//   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//   child: Container(
//     decoration: BoxDecoration(
//       color: Colors.grey[200],
//       borderRadius: BorderRadius.circular(12),
//     ),
//     height: 50,
//     child: Row(
//       children: [
//         _buildTabButton('Ongoing', 0),
//         _buildTabButton('Completed', 1),
//       ],
//     ),
//   ),
// ),
// Expanded(
//   child: PageView(
//     controller: _pageController,
//     onPageChanged: (index) {
//       setState(() {
//         _activeTabIndex = index;
//       });
//     },
//     children: [
//       _buildOrderList(ongoingOrders, false),
//       _buildOrderList(completedOrders, true),
//     ],
//   ),
// ),

/**
 *
 */
