import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:dobzz_seller/core/component/custom_drop_down_menu.dart';
import 'package:dobzz_seller/core/component/fields/custom_text_form_field.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/constant_gaping.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/core/utils/extensions.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:dobzz_seller/feature/checkout/presentation/manager/discount/cubit/discount_cubit.dart';
import 'package:dobzz_seller/feature/checkout/presentation/manager/processToCheckout/cubit/process_to_checkout_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/network/local/cache.dart';
import '../../data/models/place_order_model.dart';
import '../../../cart/data/models/cart_item_model.dart';
import '../../../address/view/manager/address/cubit/address_cubit.dart';
import '../../../address/view/presentation/add_address_view.dart';

class CheckoutView extends StatefulWidget {
  final CartData cartData;
  const CheckoutView({Key? key, required this.cartData}) : super(key: key);

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final TextEditingController promoCodeController = TextEditingController();
  AddressCubit addressCubit = AddressCubit();
  ProcessToCheckoutCubit processToCheckoutCubit = ProcessToCheckoutCubit();
  DiscountCubit discountCubit = DiscountCubit();

  @override
  void initState() {
    addressCubit.getAddress(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        BlocProvider.value(
          value: processToCheckoutCubit,
          child: BlocBuilder<ProcessToCheckoutCubit, ProcessToCheckoutState>(
            builder: (context, state) {
              return CustomTextButton(
                borderRadius: 8,
                onPress: () {
                  if (ConstantsModels.addressModel?.data?.data?.isEmpty ??
                      true) {
                    context.navigateToPage(
                      AddAddressView(
                        addressCubit: addressCubit,
                      ),
                    );
                  } else {
                    final selectedAddressId =
                        int.tryParse(processToCheckoutCubit.addressId) ?? 0;

                    if (selectedAddressId <= 0) {
                      Utils.showToast(
                          title: 'please_select_address'.tr(),
                          state: UtilState.error);
                      return;
                    }

                    final selectedAddress =
                        ConstantsModels.addressModel?.data?.data?.firstWhere(
                      (element) => element.id == selectedAddressId,
                      orElse: () =>
                          ConstantsModels.addressModel!.data!.data!.first,
                    );

                    if (selectedAddress != null) {
                      final billingInfo = BillingInfoModel(
                        billingPostecode: selectedAddress.postcode.toString(),
                        email: loginCacheValue?.data?.email ?? '',
                        billingCity: selectedAddress.cityName ?? '',
                        lastname: '',
                        billingCompanyName: '',
                        deliveryCity: selectedAddress.cityName ?? '',
                        deliveryState: selectedAddress.stateId.toString(),
                        billingAddress: selectedAddress.address ?? '',
                        deliveryPostcode: selectedAddress.postcode.toString(),
                        billingUserTelephone: selectedAddress.phone ?? '',
                        firstname: selectedAddress.fullName ?? '',
                        deliveryCountry: selectedAddress.countryId.toString(),
                        billingCountry: selectedAddress.countryId.toString(),
                        deliveryAddress: selectedAddress.address ?? '',
                        billingState: selectedAddress.stateId.toString(),
                      );

                      final body = PlaceOrderBodyModel(
                        themeId: "stylique",
                        paymentType: "cod",
                        billingInfo: billingInfo,
                        couponInfo: {},
                        deliveryComment: "",
                        userId: loginCacheValue?.data?.id.toString() ?? "0",
                        customerId: loginCacheValue?.data?.id.toString() ?? "0",
                        paymentComment: "",
                        methodId: "1",
                        shippingId: "3",
                        price: widget.cartData.subTotal?.toString() ?? "0",
                      );

                      processToCheckoutCubit.placeOrder(
                          context: context, body: body);
                    } else {
                      Utils.showToast(
                          title: 'please_select_address'.tr(),
                          state: UtilState.error);
                    }
                  }
                },
                child: state is ProcessToCheckoutLoading
                    ? const Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          'Place Order'.tr(),
                          style: TextStyle(
                            fontSize: Constants.tablet ? 16 : 16.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              );
            },
          ),
        ),
      ],
      appBar: customAppBar(context: context, title: 'Checkout'.tr()),
      body: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: addressCubit),
          BlocProvider.value(value: processToCheckoutCubit),
          BlocProvider.value(value: discountCubit),
        ],

        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: BlocBuilder<DiscountCubit, DiscountState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Delivery Address Section
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Delivery Address'.tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 7,
                          child: BlocBuilder<AddressCubit, AddressState>(
                            builder: (context, state) {
                              final addresses =
                                  ConstantsModels.addressModel?.data?.data ??
                                      [];
                              final firstAddress =
                                  addresses.isNotEmpty ? addresses.first : null;
                              final initialName =
                                  (Constants.defaultAddress.name != null &&
                                          Constants
                                              .defaultAddress.name!.isNotEmpty)
                                      ? Constants.defaultAddress.name!
                                      : (firstAddress?.fullName ?? 'Address');
                              final initialId =
                                  (Constants.defaultAddress.addressId != null)
                                      ? Constants.defaultAddress.addressId!
                                      : (firstAddress?.id ?? 0);

                              // Ensure addressId is set if we have a default/first address
                              if (processToCheckoutCubit.addressId.isEmpty ||
                                  processToCheckoutCubit.addressId == '-1') {
                                if (initialId != 0) {
                                  processToCheckoutCubit.addressId =
                                      initialId.toString();
                                }
                              }

                              return CustomDropDownMenu(
                                menuItemPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                hasError: addresses.isEmpty,
                                errorText:
                                    'you should create address first'.tr(),
                                nameField: 'Address'.tr(),
                                borderColor: Colors.grey.withOpacityNew(0.2),
                                selectedItem: DropDownModel(
                                    name: initialName, value: initialId),
                                items: addresses.map((e) {
                                  return DropDownModel(
                                      name: e.title ?? '', value: e.id ?? -1);
                                }).toList(),
                                onChanged: (value) {
                                  // setState(() {});
                                  processToCheckoutCubit.addressId =
                                      value?.value.toString() ?? '-1';
                                  // cityCubit.getAddress(context: context, stateId: addAddressCubit.stateId);
                                  // addAddressCubit.stateId = value?.value ?? -1;
                                },
                              );
                            },
                          ),
                        ),
                        w5,
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              context.navigateToPage(
                                AddAddressView(
                                  addressCubit: addressCubit,
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 25),
                              height: 40.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.primaryColor,
                              ),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // const SizedBox(height: 8),
                    // Divider(
                    //   thickness: 0.7,
                    //   color: Colors.grey.withOpacityNew(0.3),
                    // ),
                    // const SizedBox(height: 8),
                    // Payment Method Section
                    // Text(
                    //   'Payment Method'.tr(),
                    //   style: const TextStyle(
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    // const SizedBox(height: 12),

                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 5),
                    //   child: BlocBuilder<ProcessToCheckoutCubit, ProcessToCheckoutState>(
                    //     buildWhen: (previous, current) => current is GetAllPaymentsSuccess,
                    //     builder: (context, state) => CustomList(
                    //       borderOnlySelection: true,
                    //       tabs: processToCheckoutCubit.paymentMethod,
                    //       // showTabs: false, // This is fine if you don't want text labels
                    //       // prefixIcon: true, // You need to set this to true to show icons
                    //       // useSvgIcons: true,
                    //       // svgIcons: const [AppIcons.pay1, AppIcons.pay2, AppIcons.pay3, AppIcons.pay4],
                    //       onTabChanged: (index) {
                    //         processToCheckoutCubit.changePaymentMethod(processToCheckoutCubit.paymentMethod[index]);
                    //       },
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 8),
                    Divider(
                      thickness: 0.7,
                      color: Colors.grey.withOpacityNew(0.3),
                    ),
                    const SizedBox(height: 8),
                    // Payment Method Section

                    // Order Summary Section
                    Text(
                      'Order Summary'.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildOrderSummaryRow('Sub-total'.tr(),
                        '\$ ${widget.cartData.subTotal ?? 0}'),
                    const SizedBox(height: 12),
                    _buildOrderSummaryRow('VAT (%)'.tr(),
                        '\$ ${widget.cartData.totalTaxPrice ?? 0}'),
                    const SizedBox(height: 12),
                    _buildOrderSummaryRow('Shipping fee'.tr(),
                        '\$ ${widget.cartData.shippingOriginalPrice ?? 0}'),
                    const SizedBox(height: 8),
                    Divider(
                      thickness: 0.7,
                      color: Colors.grey.withOpacityNew(0.3),
                    ),
                    const SizedBox(height: 8),
                    // Payment Method Section
                    _buildOrderSummaryRow('Total'.tr(),
                        '\$ ${widget.cartData.totalFinalPrice ?? 0}',
                        isTotal: true),

                    // Payment Method Section
                    const SizedBox(height: 8),
                    // Promo Code Section
                    PromoCode(
                      discountCubit: discountCubit,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummaryRow(String title, String amount,
      {bool isTotal = false}) {
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

class PromoCode extends StatefulWidget {
  const PromoCode({
    super.key,
    required this.discountCubit,
  });

  final DiscountCubit discountCubit;

  @override
  State<PromoCode> createState() => _PromoCodeState();
}

class _PromoCodeState extends State<PromoCode> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: CustomTextFormField(
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(
                    Icons.local_offer_outlined,
                    color: Colors.grey.shade400,
                  ),
                ),
                outPadding: EdgeInsets.zero,
                controller: widget.discountCubit.discountCode,
                hintText: 'promo code'.tr(),
              ),
            ),
            w10,
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: () {
                  if (widget.discountCubit.discountCode.text.isEmpty) {
                    Utils.showToast(
                        title: 'Please Enter promo code'.tr(),
                        state: UtilState.error);
                  } else {
                    widget.discountCubit.discount(context: context);
                  }
                },
                child: BlocProvider.value(
                  value: widget.discountCubit,
                  child: BlocBuilder<DiscountCubit, DiscountState>(
                    builder: (context, state) {
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: state is DiscountLoading
                            ? const Center(
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Center(
                                child: Text(
                                  'Add'.tr(),
                                  style: TextStyle(
                                    fontSize: Constants.tablet ? 16 : 16.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
