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
import 'package:dobzz_seller/feature/checkout/presentation/view/check_out_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'cart_item_skeleton.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final AddToCartCubit addToCartCubit = AddToCartCubit();
  final DeleteFromCartCubit deleteFromCartCubit = DeleteFromCartCubit();

  // Track items that are currently loading
  final Map<int, bool> loadingItems = {};

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  void _loadCartItems() {
    CartItemsCubit.of(context).getCartItems(context: context);
    // checkoutDetailsCubit.getCheckoutDetails(context: context);
  }

  // Handle add quantity with loading indicator
// Handle add quantity with loading indicator
  void onAdd(CartProduct item) async {
    final itemId = item.productId ?? -1;
    if (itemId == -1 || loadingItems[itemId] == true) return;
    // if (item.qty! >= item.availableQuantity!) {
    //   Utils.showToast(title: '${'Maximum quantity is'.tr()} ${item.availableQuantity!}', state: UtilState.error);
    //   return;
    // }

    setState(() {
      loadingItems[itemId] = true;
    });
    // setState(() {
    //   item.qty = (item.qty ?? 0) + 1; // Fixed parentheses
    // });

    // Rest of your method remains the same
    try {
      await addToCartCubit.updateCartItem(
        isIncrease: true,
        context: context,
        cartItemId: itemId,
        quantity: item.qty ?? 0, // Use the updated quantity
        variantId: item.variantId ?? 0,
      );

      // Refresh checkout details and cart items from server
      if (mounted) {
        // await checkoutDetailsCubit.getCheckoutDetails(context: context);
      }
    } catch (e) {
      if (mounted) {
        Utils.showToast(
            title: 'Failed to update quantity. Please try again.',
            state: UtilState.error);
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
  void onRemove(CartProduct item) async {
    final itemId = item.productId ?? -1;
    if (itemId == -1 || loadingItems[itemId] == true || (item.qty ?? 0) <= 1)
      return;

    // setState(() {
    //   item.qty = (item.qty ?? 0) - 1; // Fixed parentheses
    // });

    setState(() {
      loadingItems[itemId] = true;
    });

    // Rest of your method is the same
    try {
      await addToCartCubit.updateCartItem(
        isIncrease: false,
        context: context,
        cartItemId: itemId,
        quantity: item.qty ?? 0, // Use the updated quantity
        variantId: item.variantId ?? 0,
      );

      if (mounted) {
        // await checkoutDetailsCubit.getCheckoutDetails(context: context);
      }
    } catch (e) {
      if (mounted) {
        Utils.showToast(
            title: 'Failed to update quantity. Please try again.',
            state: UtilState.error);
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
  void onDelete(CartProduct item) async {
    final itemId = item.productId ?? -1;
    if (itemId == -1 || loadingItems[itemId] == true) return;

    // Set this item as loading
    // Set this item as loading
    setState(() {
      loadingItems[itemId] = true;
    });

    try {
      // Send the delete request to the server
      await addToCartCubit.updateCartItem(
        isIncrease: null,
        context: context,
        cartItemId: itemId,
        quantity: item.qty ?? 0, // Use the updated quantity
        variantId: item.variantId ?? 0,
      );

      // Immediately remove the item from the local list
      setState(() {
        if (ConstantsModels.cartItemModel?.data != null) {
          ConstantsModels.cartItemModel!.data!.productList!
              .removeWhere((element) => element.cartId == itemId);
          CartItemsCubit.of(context).removeCartItems();
        }
      });

      // Refresh checkout details and cart items from server
      if (mounted) {
        // await checkoutDetailsCubit.getCheckoutDetails(context: context);
        // We can keep this commented out since we've already updated the UI
        // await cartCubit.getCartItems(context: context);
      }
    } catch (e) {
      if (mounted) {
        Utils.showToast(
            title: 'Failed to delete item. Please try again.',
            state: UtilState.error);
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
        BlocProvider.value(value: addToCartCubit),
        BlocProvider.value(value: deleteFromCartCubit),
      ],
      child: BlocBuilder<CartItemsCubit, CartItemsState>(
        builder: (context, state) {
          return BlocListener<AddToCartCubit, AddToCartState>(
            listener: (context, state) {
              if (state is AddToCartSuccess) {
                _loadCartItems();
              }
            },
            child: Scaffold(
              persistentFooterButtons: ConstantsModels.cartItemModel != null &&
                      ConstantsModels.cartItemModel?.data != null &&
                      ConstantsModels.cartItemModel!.data!.productList !=
                          null &&
                      ConstantsModels
                          .cartItemModel!.data!.productList!.isNotEmpty
                  ? [
                      GoToCheckOutButton(
                        totalPrice: ConstantsModels
                                .cartItemModel?.data?.totalFinalPrice
                                ?.toString() ??
                            '0',
                      ),
                    ]
                  : null,
              appBar: customAppBar(context: context, title: 'Cart'.tr()),
              body: _buildCartBody(state),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCartBody(CartItemsState state) {
    if (state is CartItemsLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Skeletonizer(
          enabled: true,
          effect: ShimmerEffect(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
          ),
          child: ListView.builder(
            itemCount: 3,
            itemBuilder: (context, index) => const CartItemSkeleton(),
          ),
        ),
      );
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
    } else if (state is CartItemsSuccess ||
        ConstantsModels.cartItemModel?.data != null) {
      final cartItems = ConstantsModels.cartItemModel?.data?.productList ?? [];

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
                  isLoading: loadingItems[item.productId ?? -1] ?? false,
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
    required this.totalPrice,
  });
  final String totalPrice;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          CheckOutItem(
            label: 'Sub-total'.tr(),
            value: totalPrice ?? '0',
          ),
          Divider(
            thickness: 0.7,
            color: Colors.grey.withOpacityNew(0.5),
          ),
          h20,
          CustomTextButton(
            borderRadius: 8,
            onPress: () {
              final items =
                  ConstantsModels.cartItemModel?.data?.productList ?? [];
              if (items.isNotEmpty) {
                for (final element in items) {
                  // if ((element.qty ?? 0) > (element.availableQuantity ?? 0)) {
                  //   Utils.showToast(title: '${'you_must_request_a_little_amount_from_'.tr()} ${element.product}', state: UtilState.error);
                  //   return;
                  // }
                }
                context.navigateToPage(CheckoutView(
                  cartData: ConstantsModels.cartItemModel!.data!,
                ));
              }

              if (loginCacheValue?.data?.email == Constants.demoAccount) {
                Utils.showToast(
                    title: 'This is demo account you can not create order ',
                    state: UtilState.error);
              } else {
                context.navigateToPage(CheckoutView(
                  cartData: ConstantsModels.cartItemModel!.data!,
                ));
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Text(
                  'Go To Check out'.tr(),
                  style: TextStyle(
                      fontSize: Constants.tablet ? 16 : 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
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
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: Constants.tablet ? 16 : 16.sp,
                color: labelColor ?? Colors.grey.shade400),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
                fontSize: Constants.tablet ? 16 : 16.sp, color: Colors.black),
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
  final CartProduct cartItem;
  final VoidCallback onRemove;
  final VoidCallback onAdd;
  final VoidCallback onDelete;
  final AddToCartCubit addToCartCubit;
  final bool isLoading;

  const CartItemWidget({
    super.key,
    required this.cartItem,
    required this.onRemove,
    required this.onAdd,
    required this.onDelete,
    required this.addToCartCubit,
    this.isLoading = false,
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
              urlImage: cartItem.image,
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
                          cartItem.name ?? '',
                          style: TextStyle(
                            fontSize: Constants.tablet ? 12 : 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      w7,
                      InkWell(
                        onTap: isLoading ? null : onDelete,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: Colors.red.withOpacityNew(0.2))),
                          child: Icon(
                            Icons.delete_outline,
                            color: isLoading ? Colors.grey : Colors.red,
                            size: Constants.tablet ? 15 : 15.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (cartItem.variantName != null)
                    Text(
                      '${'Size'.tr()} ${cartItem.variantName}',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: Constants.tablet ? 14 : 14.sp,
                          color: Colors.grey),
                    )
                  else
                    const SizedBox(
                      height: 10,
                    ),
                  // if (cartItem.availableQuantity != null)
                  //   Text(
                  //     '${'available_quantity'.tr()} ${cartItem.availableQuantity}',
                  //     style: TextStyle(fontWeight: FontWeight.w500, fontSize: Constants.tablet ? 14 : 14.sp, color: Colors.grey),
                  //   )
                  // else
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
                              cartItem.finalPrice.toString(),
                              style: TextStyle(
                                fontSize: Constants.tablet ? 14 : 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            w5,
                            SvgPicture.asset(
                              AppIcons.currency,
                              colorFilter: const ColorFilter.mode(
                                  Colors.black, BlendMode.srcIn),
                              height: 14,
                              width: 14,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      _QuantityButton(
                        icon: Icons.remove,
                        onTap: cartItem.qty! > 1 ? onRemove : null,
                        cartItem: cartItem,
                        isLoading: isLoading,
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 20,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            cartItem.qty?.toString() ?? '',
                            style: TextStyle(
                                fontSize: Constants.tablet ? 16 : 16.sp),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _QuantityButton(
                        icon: Icons.add,
                        onTap: onAdd,
                        cartItem: cartItem,
                        isLoading: isLoading,
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
  final VoidCallback? onTap;
  final bool isLoading;
  final CartProduct cartItem;

  const _QuantityButton({
    required this.icon,
    required this.onTap,
    required this.cartItem,
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
          border: Border.all(
              color: isLoading ? Colors.grey.shade200 : Colors.grey.shade400),
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
