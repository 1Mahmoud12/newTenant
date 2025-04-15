import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:dobzz_seller/core/component/custom_list.dart';
import 'package:dobzz_seller/core/component/fields/custom_text_form_field.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/constant_gaping.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/cart/view/address/presentation/address_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({Key? key}) : super(key: key);

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  String selectedPaymentMethod = 'Card';
  final TextEditingController promoCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        CustomTextButton(
          borderRadius: 8,
          onPress: () {},
          childText: 'Place Order ',
        ),
      ],
      appBar: customAppBar(context: context, title: 'Checkout'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Delivery Address Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Delivery Address',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      context.navigateToPage(const AddressView());
                    },
                    child: Text(
                      'Change',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline, // 👈 adds underline
                        decorationColor: Colors.black,
                        decorationThickness: 15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: Colors.black54,
                              size: 20,
                            ),
                            w5,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Home',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                const Text(
                                  '925 S Chugach St #APT 10, Alaska 99645',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Divider(
                thickness: 0.7,
                color: Colors.grey.withOpacity(0.3),
              ),
              const SizedBox(height: 8),
              // Payment Method Section
              const Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: CustomList(
                  tabs: const ['Card', 'Cash', 'Apple Pay'],
                  prefixIcon: true,
                  icons: const [Icons.credit_card, Icons.monetization_on_outlined, Icons.apple],
                  onTabChanged: (index) {
                    //  print('Selected Tab: $index');
                    // Handle tab change logic here
                  },
                ),
              ),
              const SizedBox(height: 8),
              Divider(
                thickness: 0.7,
                color: Colors.grey.withOpacity(0.3),
              ),
              const SizedBox(height: 8),
              // Payment Method Section

              // Order Summary Section
              const Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildOrderSummaryRow('Sub-total', '\$ 5,870'),
              const SizedBox(height: 12),
              _buildOrderSummaryRow('VAT (%)', '\$ 0.00'),
              const SizedBox(height: 12),
              _buildOrderSummaryRow('Shipping fee', '\$ 80'),
              const SizedBox(height: 8),
              Divider(
                thickness: 0.7,
                color: Colors.grey.withOpacity(0.3),
              ),
              const SizedBox(height: 8),
              // Payment Method Section
              _buildOrderSummaryRow('Total', '\$ 5,950', isTotal: true),

              // Payment Method Section
              const SizedBox(height: 8),
              // Promo Code Section
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: CustomTextFormField(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Icon(
                            Icons.local_offer_outlined,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        outPadding: EdgeInsets.zero,
                        controller: TextEditingController(),
                        hintText: 'promo code',
                      ),
                    ),
                    w10,
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Add',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummaryRow(String title, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isTotal ? Colors.black : Colors.grey,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
      ],
    );
  }
}
