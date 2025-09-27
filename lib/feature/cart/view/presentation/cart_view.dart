import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/component/cache_image.dart';
import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:dobzz_seller/core/component/loadsErros/loading_widget.dart';
import 'package:dobzz_seller/core/network/local/cache.dart';
import 'package:dobzz_seller/core/utils/app_icons.dart';
import 'package:dobzz_seller/core/utils/constant_gaping.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/core/utils/errorLoadingWidgets/empty_widget.dart';
import 'package:dobzz_seller/core/utils/extensions.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:dobzz_seller/feature/cart/data/models/cart_item_model.dart';
import 'package:dobzz_seller/feature/cart/view/manager/addToCart/cubit/add_to_cart_cubit.dart';
import 'package:dobzz_seller/feature/cart/view/manager/cartItems/cubit/cart_items_cubit.dart';
import 'package:dobzz_seller/feature/cart/view/manager/deleteFromCart/cubit/delete_from_cart_cubit.dart';
import 'package:dobzz_seller/feature/checkout/presentation/manager/checkoutDetails/cubit/checkout_details_cubit.dart';
import 'package:dobzz_seller/feature/checkout/presentation/view/check_out_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final AddToCartCubit addToCartCubit = AddToCartCubit();
  final DeleteFromCartCubit deleteFromCartCubit = DeleteFromCartCubit();
  final CheckoutDetailsCubit checkoutDetailsCubit = CheckoutDetailsCubit();

  // Track items that are currently loading
  final Map<int, bool> loadingItems = {};

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  void _loadCartItems() {
    CartItemsCubit.of(context).getCartItems(context: context);
    checkoutDetailsCubit.getCheckoutDetails(context: context);
  }

  // Handle add quantity with loading indicator
// Handle add quantity with loading indicator
  void onAdd(CartItemData item) async {
    final itemId = item.id ?? -1;
    if (itemId == -1 || loadingItems[itemId] == true) return;
    if (item.quantity! >= item.availableQuantity!) {
      Utils.showToast(title: '${'Maximum quantity is'.tr()} ${item.availableQuantity!}', state: UtilState.error);
      return;
    }
    setState(() {
      item.quantity = (item.quantity ?? 0) + 1; // Fixed parentheses
    });

    // Rest of your method remains the same
    try {
      await addToCartCubit.updateCartItem(
        context: context,
        cartItemId: itemId,
        quantity: item.quantity ?? 0, // Use the updated quantity
      );

      // Refresh checkout details and cart items from server
      if (mounted) {
        await checkoutDetailsCubit.getCheckoutDetails(context: context);
      }
    } catch (e) {
      if (mounted) {
        Utils.showToast(title: 'Failed to update quantity. Please try again.', state: UtilState.error);
      }
    } finally {
      if (mounted) {
        setState(() {
          loadingItems[itemId] = false;
        });
      }
    }
  }

// Handle remove quantity with loading indicator
  void onRemove(CartItemData item) async {
    final itemId = item.id ?? -1;
    if (itemId == -1 || loadingItems[itemId] == true || (item.quantity ?? 0) <= 1) return;

    setState(() {
      item.quantity = (item.quantity ?? 0) - 1; // Fixed parentheses
    });

    // Rest of your method is the same
    try {
      await addToCartCubit.updateCartItem(
        context: context,
        cartItemId: itemId,
        quantity: item.quantity ?? 0, // Use the updated quantity
      );

      if (mounted) {
        await checkoutDetailsCubit.getCheckoutDetails(context: context);
      }
    } catch (e) {
      if (mounted) {
        Utils.showToast(title: 'Failed to update quantity. Please try again.', state: UtilState.error);
      }
    } finally {
      if (mounted) {
        setState(() {
          loadingItems[itemId] = false;
        });
      }
    }
  }

  // Handle item delete with loading indicator
  void onDelete(CartItemData item) async {
    final itemId = item.id ?? -1;
    if (itemId == -1 || loadingItems[itemId] == true) return;

    // Set this item as loading
    setState(() {
      loadingItems[itemId] = true;
    });

    try {
      // Send the delete request to the server
      await deleteFromCartCubit.deleteFromCart(context: context, itemId: itemId);

      // Immediately remove the item from the local list
      setState(() {
        if (ConstantsModels.cartItemModel?.data != null) {
          ConstantsModels.cartItemModel!.data!.removeWhere((element) => element.id == itemId);
          CartItemsCubit.of(context).removeCartItems();
        }
      });

      // Refresh checkout details and cart items from server
      if (mounted) {
        await checkoutDetailsCubit.getCheckoutDetails(context: context);
        // We can keep this commented out since we've already updated the UI
        // await cartCubit.getCartItems(context: context);
      }
    } catch (e) {
      if (mounted) {
        Utils.showToast(title: 'Failed to delete item. Please try again.', state: UtilState.error);
      }
    } finally {
      // Clear loading state if we're still mounted
      if (mounted) {
        setState(() {
          loadingItems[itemId] = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: checkoutDetailsCubit),
        BlocProvider.value(value: addToCartCubit),
        BlocProvider.value(value: deleteFromCartCubit),
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
            appBar: customAppBar(context: context, title: 'Cart'.tr()),
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
        return EmptyWidget(
          data: 'Your Cart Is Empty!'.tr(),
          subData: 'When you add products, they’ll appear here.'.tr(),
          emptyImage: EmptyImages.noCartItems,
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
                  addToCartCubit: addToCartCubit,
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
            color: Colors.grey.withOpacityNew(0.5),
          ),
          h20,
          CustomTextButton(
            borderRadius: 8,
            onPress: () {
              final items = ConstantsModels.cartItemModel?.data ?? [];
              if (items.isNotEmpty) {
                for (final element in items) {
                  if ((element.quantity ?? 0) > (element.availableQuantity ?? 0)) {
                    Utils.showToast(title: '${'you_must_request_a_little_amount_from_'.tr()}${element.product}', state: UtilState.error);
                    return;
                  }
                }
                context.navigateToPage(const CheckoutView());
              }

              if (userCacheValue?.data?.phone == Constants.demoAccount) {
                Utils.showToast(title: 'This is demo account you can not create order ', state: UtilState.error);
              } else {
                context.navigateToPage(const CheckoutView());
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Text(
                  'Go To Check out'.tr(),
                  style: TextStyle(fontSize: Constants.tablet ? 16 : 16.sp, fontWeight: FontWeight.w500, color: Colors.white),
                ),
                w10,
                const Icon(Icons.arrow_forward, color: Colors.white),
                s,
              ],
            ),
          ),
          const SizedBox(
            height: 20,
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
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: Constants.tablet ? 16 : 16.sp, color: labelColor ?? Colors.grey.shade400),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(fontSize: Constants.tablet ? 16 : 16.sp, color: Colors.black),
          ),
          w5,
          SvgPicture.asset(
            AppIcons.currency,
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
            height: 14,
            width: 14,
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
  final AddToCartCubit addToCartCubit;

  const CartItemWidget({
    super.key,
    required this.cartItem,
    required this.onRemove,
    required this.onAdd,
    required this.onDelete,
    required this.addToCartCubit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border.all(color: Colors.grey.shade300),
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
                          cartItem.product ?? '',
                          style: TextStyle(
                            fontSize: Constants.tablet ? 12 : 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      w7,
                      BlocProvider.value(
                        value: addToCartCubit,
                        child: BlocBuilder<AddToCartCubit, AddToCartState>(
                          builder: (context, state) {
                            return InkWell(
                              onTap: state is AddToCartLoading ? null : onDelete,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration:
                                    BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.red.withOpacityNew(0.2))),
                                child: Icon(
                                  Icons.delete_outline,
                                  color: state is AddToCartLoading ? Colors.grey : Colors.red,
                                  size: Constants.tablet ? 15 : 15.sp,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  if (cartItem.size != null)
                    Text(
                      '${'Size'.tr()} ${cartItem.size}',
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: Constants.tablet ? 14 : 14.sp, color: Colors.grey),
                    )
                  else
                    const SizedBox(
                      height: 10,
                    ),
                  if (cartItem.availableQuantity != null)
                    Text(
                      '${'available_quantity'.tr()} ${cartItem.availableQuantity}',
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: Constants.tablet ? 14 : 14.sp, color: Colors.grey),
                    )
                  else
                    const SizedBox(
                      height: 10,
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(
                        child: Row(
                          children: [
                            Text(
                              cartItem.priceForProduct.toString(),
                              style: TextStyle(
                                fontSize: Constants.tablet ? 14 : 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            w5,
                            SvgPicture.asset(
                              AppIcons.currency,
                              colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                              height: 14,
                              width: 14,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      BlocProvider.value(
                        value: addToCartCubit,
                        child: BlocBuilder<AddToCartCubit, AddToCartState>(
                          builder: (context, state) {
                            return _QuantityButton(
                              icon: Icons.remove,
                              onTap: onRemove,
                              isLoading: state is AddToCartLoading,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 20,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            cartItem.quantity.toString(),
                            style: TextStyle(fontSize: Constants.tablet ? 16 : 16.sp),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      BlocProvider.value(
                        value: addToCartCubit,
                        child: BlocBuilder<AddToCartCubit, AddToCartState>(
                          builder: (context, state) {
                            return _QuantityButton(
                              icon: Icons.add,
                              onTap: onAdd,
                              isLoading: state is AddToCartLoading,
                            );
                          },
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

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isLoading;

  const _QuantityButton({
    required this.icon,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: 20.w,
        height: 20.h,
        decoration: BoxDecoration(
          border: Border.all(color: isLoading ? Colors.grey.shade200 : Colors.grey.shade400),
          borderRadius: BorderRadius.circular(6.r),
          color: isLoading ? Colors.grey.shade100 : Colors.transparent,
        ),
        child: Icon(
          icon,
          size: Constants.tablet ? 18 : 18.sp,
          color: isLoading ? Colors.grey.shade400 : Colors.black,
        ),
      ),
    );
  }
}
