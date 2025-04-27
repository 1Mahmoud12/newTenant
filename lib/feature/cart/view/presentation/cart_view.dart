import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/component/cache_image.dart';
import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:dobzz_seller/core/component/loadsErros/loading_widget.dart';
import 'package:dobzz_seller/core/utils/constant_gaping.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:dobzz_seller/feature/cart/data/models/cart_item_model.dart';
import 'package:dobzz_seller/feature/cart/view/checkout/presentation/check_out_view.dart';
import 'package:dobzz_seller/feature/cart/view/checkout/presentation/manager/checkoutDetails/cubit/checkout_details_cubit.dart';
import 'package:dobzz_seller/feature/cart/view/manager/addToCart/cubit/add_to_cart_cubit.dart';
import 'package:dobzz_seller/feature/cart/view/manager/cartItems/cubit/cart_items_cubit.dart';
import 'package:dobzz_seller/feature/cart/view/manager/deleteFromCart/cubit/delete_from_cart_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final CartItemsCubit cartCubit = CartItemsCubit();
  final AddToCartCubit addToCartCubit = AddToCartCubit();
  final DeleteFromCartCubit deleteFromCartCubit = DeleteFromCartCubit();
  final CheckoutDetailsCubit checkoutDetailsCubit = CheckoutDetailsCubit();

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  void _loadCartItems() {
    cartCubit.getCartItems(context: context);
    checkoutDetailsCubit.getCheckoutDetails(context: context);
  }

  // Handle add quantity with optimistic UI update
  // Handle add quantity with optimistic UI update
  void onAdd(CartItemData item) async {
    final previousQuantity = item.quantity ?? 0;
    if (!mounted) return;
    setState(() {
      item.quantity = previousQuantity + 1;
      _updateLocalSubtotal();
    });

    try {
      await addToCartCubit.updateCartItem(context: context, cartItemId: item.id ?? -1, quantity: item.quantity ?? 0);
      if (mounted) {
        await checkoutDetailsCubit.getCheckoutDetails(context: context);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        item.quantity = previousQuantity;
        _updateLocalSubtotal();
      });
      Utils.showToast(title: 'Failed to update quantity. Please try again.', state: UtilState.error);
    }
  }

// Handle remove quantity with optimistic UI update
  void onRemove(CartItemData item) async {
    final previousQuantity = item.quantity ?? 0;
    if (previousQuantity <= 1) return;
    if (!mounted) return;
    setState(() {
      item.quantity = previousQuantity - 1;
      _updateLocalSubtotal();
    });

    try {
      await addToCartCubit.updateCartItem(context: context, cartItemId: item.id ?? -1, quantity: item.quantity ?? 0);
      if (mounted) {
        await checkoutDetailsCubit.getCheckoutDetails(context: context);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        item.quantity = previousQuantity;
        _updateLocalSubtotal();
      });
      Utils.showToast(title: 'Failed to update quantity. Please try again.', state: UtilState.error);
    }
  }

// Handle item delete with optimistic UI update
  void onDelete(CartItemData item) async {
    final itemIndex = ConstantsModels.cartItemModel?.data?.indexOf(item) ?? -1;
    if (itemIndex == -1) return;
    if (!mounted) return;
    setState(() {
      ConstantsModels.cartItemModel?.data?.removeAt(itemIndex);
      _updateLocalSubtotal();
    });

    try {
      await deleteFromCartCubit.deleteFromCart(context: context, itemId: item.id ?? -1);
      if (mounted) {
        await checkoutDetailsCubit.getCheckoutDetails(context: context);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        ConstantsModels.cartItemModel?.data?.insert(itemIndex, item);
        _updateLocalSubtotal();
      });
      Utils.showToast(title: 'Failed to update quantity. Please try again.', state: UtilState.error);
    }
  }

  // Update local subtotal price estimate for immediate UI feedback
  void _updateLocalSubtotal() {
    if (ConstantsModels.cartItemModel?.data == null) return;

    double subtotal = 0;
    for (final item in ConstantsModels.cartItemModel!.data!) {
      subtotal += (item.price ?? 0) * (item.quantity ?? 0);
    }

    if (ConstantsModels.checkoutDetailsModel != null) {
      ConstantsModels.checkoutDetailsModel!.subTotalPrice = subtotal.toInt();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: cartCubit),
        BlocProvider.value(value: checkoutDetailsCubit),
      ],
      child: BlocBuilder<CartItemsCubit, CartItemsState>(
        builder: (context, state) {
          return Scaffold(
            persistentFooterButtons: ConstantsModels.cartItemModel != null &&
                    ConstantsModels.cartItemModel?.data != null &&
                    ConstantsModels.cartItemModel!.data!.isNotEmpty
                ? [
                    GoToCheckOutButton(
                      checkoutDetailsCubit: checkoutDetailsCubit,
                    ),
                  ]
                : null,
            appBar: customAppBar(context: context, title: 'Cart'.tr(), stopLeading: true),
            body: _buildCartBody(state),
          );
        },
      ),
    );
  }

  Widget _buildCartBody(CartItemsState state) {
    if (state is CartItemsLoading) {
      return const Center(child: LoadingWidget());
    } else if (state is CartItemsError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${'Error:'.tr()}${state.e}'),
            ElevatedButton(
              onPressed: _loadCartItems,
              child: Text('Retry'.tr()),
            ),
          ],
        ),
      );
    } else if (state is CartItemsSuccess || ConstantsModels.cartItemModel?.data != null) {
      final cartItems = ConstantsModels.cartItemModel?.data ?? [];

      if (cartItems.isEmpty) {
        return Center(
          child: Text('Your cart is empty'.tr()),
        );
      }

      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // Loop through the cart items list to create CartItemWidget for each
              for (final item in cartItems)
                CartItemWidget(
                  cartItem: item,
                  onRemove: () => onRemove(item),
                  onAdd: () => onAdd(item),
                  onDelete: () => onDelete(item),
                ),
            ],
          ),
        ),
      );
    } else {
      // Initial state or any other state
      return Center(
        child: Text('Loading cart...'.tr()),
      );
    }
  }
}

class GoToCheckOutButton extends StatelessWidget {
  const GoToCheckOutButton({
    super.key,
    required this.checkoutDetailsCubit,
  });
  final CheckoutDetailsCubit checkoutDetailsCubit;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          BlocBuilder<CheckoutDetailsCubit, CheckoutDetailsState>(
            builder: (context, state) {
              return CheckOutItem(
                label: 'Sub-total'.tr(),
                value: ConstantsModels.checkoutDetailsModel?.subTotalPrice.toString() ?? '0',
              );
            },
          ),
          Divider(
            thickness: 0.7,
            color: Colors.grey.withOpacity(0.5),
          ),
          h20,
          CustomTextButton(
            borderRadius: 8,
            onPress: () {
              context.navigateToPage(const CheckoutView());
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Text(
                  'Go To Check out'.tr(),
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.white),
                ),
                w10,
                const Icon(Icons.arrow_forward, color: Colors.white),
                s,
              ],
            ),
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}

class CheckOutItem extends StatelessWidget {
  const CheckOutItem({
    super.key,
    required this.label,
    required this.value,
    this.labelColor,
  });
  final String label;
  final String value;
  final Color? labelColor;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp, color: labelColor ?? Colors.grey.shade400),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(fontSize: 16.sp, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class CartItem {
  final String imageUrl;
  final String title;
  final String size;
  final String price;
  int quantity; // Quantity is now mutable (can be updated)

  CartItem({
    required this.imageUrl,
    required this.title,
    required this.size,
    required this.price,
    required this.quantity,
  });
}

class CartItemWidget extends StatelessWidget {
  final CartItemData cartItem;
  final VoidCallback onRemove;
  final VoidCallback onAdd;
  final VoidCallback onDelete;

  const CartItemWidget({
    super.key,
    required this.cartItem,
    required this.onRemove,
    required this.onAdd,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            CacheImage(
              urlImage: cartItem.productImagePath,
              errorColor: Colors.grey,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          cartItem.product?.name ?? '',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: onDelete,
                        child: Icon(Icons.delete_outline, color: Colors.red, size: 20.sp),
                      ),
                    ],
                  ),
                  if (cartItem.selectedSize != null)
                    Text(
                      '${'Size'.tr()} ${cartItem.selectedSize}',
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp, color: Colors.grey),
                    )
                  else
                    const SizedBox(
                      height: 10,
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        cartItem.price.toString(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      _QuantityButton(
                        icon: Icons.remove,
                        onTap: onRemove,
                        isEnabled: (cartItem.quantity ?? 0) > 1,
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 20,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            cartItem.quantity.toString(),
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _QuantityButton(
                        icon: Icons.add,
                        onTap: onAdd,
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

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isEnabled;

  const _QuantityButton({
    required this.icon,
    required this.onTap,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: 30.w,
        height: 30.w,
        decoration: BoxDecoration(
          border: Border.all(color: isEnabled ? Colors.grey.shade400 : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(6.r),
          color: isEnabled ? Colors.transparent : Colors.grey.shade100,
        ),
        child: Icon(
          icon,
          size: 18.sp,
          color: isEnabled ? Colors.black : Colors.grey.shade400,
        ),
      ),
    );
  }
}
