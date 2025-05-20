import 'package:dobzz_seller/core/component/loadsErros/loading_widget.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/core/utils/errorLoadingWidgets/empty_widget.dart';
import 'package:dobzz_seller/feature/favorites/views/manager/wishList/cubit/wish_list_cubit.dart';
import 'package:dobzz_seller/feature/home/views/manager/addToWhishlist/cubit/add_to_wish_list_cubit.dart';
import 'package:dobzz_seller/feature/home/views/manager/removeFromWhislist/cubit/remove_from_whish_list_cubit.dart';
import 'package:dobzz_seller/feature/home/views/manager/topProduct/cubit/top_product_cubit.dart';
import 'package:dobzz_seller/feature/home/views/presentation/widgets/empty_product.dart';
import 'package:dobzz_seller/feature/home/views/presentation/widgets/product_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';

class FlashSaleGrid extends StatefulWidget {
  const FlashSaleGrid({super.key, this.isItWhishList = false});
  final bool? isItWhishList;
  @override
  State<FlashSaleGrid> createState() => _FlashSaleGridState();
}

class _FlashSaleGridState extends State<FlashSaleGrid> {
  @override
  void initState() {
    super.initState();
    // Fetch top products when widget initializes
    if (widget.isItWhishList!) {
      wishListCubit.getWishList(context: context);
    } else {
      if (ConstantsModels.topProductModel == null) {
        topProductCubit.getTopProduct(context: context);
      }
    }
  }

  TopProductCubit topProductCubit = TopProductCubit();
  AddToWishListCubit addToWishListCubit = AddToWishListCubit();
  RemoveFromWhishListCubit removeFromWhishListCubit = RemoveFromWhishListCubit();
  WishListCubit wishListCubit = WishListCubit();
  @override
  Widget build(BuildContext context) {
    return widget.isItWhishList!
        ? FavoriteGrid(
            wishListCubit: wishListCubit,
            widget: widget,
            removeFromWhishListCubit: removeFromWhishListCubit,
          )
        : TopProductGrid(
            topProductCubit: topProductCubit,
            widget: widget,
            removeFromWhishListCubit: removeFromWhishListCubit,
            addToWishListCubit: addToWishListCubit,
          );
  }
}

class TopProductGrid extends StatelessWidget {
  const TopProductGrid({
    super.key,
    required this.topProductCubit,
    required this.widget,
    required this.removeFromWhishListCubit,
    required this.addToWishListCubit,
  });

  final TopProductCubit topProductCubit;
  final FlashSaleGrid widget;
  final RemoveFromWhishListCubit removeFromWhishListCubit;
  final AddToWishListCubit addToWishListCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: topProductCubit,
      child: BlocBuilder<TopProductCubit, TopProductState>(
        builder: (context, state) {
          if (state is TopProductLoading) {
            return const Center(
              child: LoadingWidget(),
            );
          } else if (state is TopProductError) {
            return Center(
              child: Text('${'Error:'.tr()}${state.e}'),
            );
          } else if (ConstantsModels.topProductModel != null) {
            // Access the loaded top products
            final topProducts = ConstantsModels.topProductModel?.data;

            if (topProducts == null || topProducts.isEmpty) {
              return Center(
                child: NoProductsAvailable(
                  message: 'No products found in this category',
                  buttonText: 'Browse other categories',
                  onButtonPressed: () {
             
                  },
                ),
              );
            }
            return GridView.builder(
              itemCount: topProducts.length > 2 ? 2 : topProducts.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.6,
              ),
              itemBuilder: (context, index) {
                final product = topProducts[index];
                return ProductCard(
                  description: product.description ?? 'No description available'.tr(),
                  rating: product.reviewsCount?.toDouble() ?? 0.0,
                  productId: product.id ?? -1,
                  initialLiked: widget.isItWhishList!,
                  onLikeTap: (isNowLiked) {
                    if (isNowLiked) {
                      // Add to wishlist
                      if (widget.isItWhishList!) {
                        // Remove from wishlist
                        removeFromWhishListCubit.removeFromWishList(context: context, productId: product.id ?? -1);
                      } else {
                        addToWishListCubit.addToWishList(context: context, productId: product.id ?? -1);
                      }
                    }
                  },
                  imagePath: product.imagePath ?? '',
                  title: product.name ?? 'Unknown Product'.tr(),
                  price: '\$${product.price?.toString() ?? '0'}',
                );
              },
            );
          }

          // Initial state or any other state
          return const SizedBox();
        },
      ),
    );
  }
}

class FavoriteGrid extends StatelessWidget {
  const FavoriteGrid({
    super.key,
    required this.wishListCubit,
    required this.widget,
    required this.removeFromWhishListCubit,
  });

  final WishListCubit wishListCubit;
  final FlashSaleGrid widget;
  final RemoveFromWhishListCubit removeFromWhishListCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: wishListCubit,
      child: BlocBuilder<WishListCubit, WishListState>(
        builder: (context, state) {
          if (state is WishListLoading) {
            return const Center(
              child: LoadingWidget(),
            );
          } else if (state is WishListError) {
            return Center(
              child: Text('${'Error:'.tr()}${state.e}'),
            );
          } else if (state is WishListSuccess) {
            // Access the loaded top products
            final wishList = ConstantsModels.wishListModel?.data;

            if (wishList == null || wishList.isEmpty) {
              return EmptyWidget(
                data: 'No Saved Items!'.tr(),
                subData: 'You don’t have any saved items. Go to home and add some.'.tr(),
                emptyImage: EmptyImages.noSavedItem,
              );
            }
            return GridView.builder(
              itemCount: wishList.length,
              shrinkWrap: true,

              ///    physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.56,
              ),
              itemBuilder: (context, index) {
                final wishListItem = wishList[index];
                return ProductCard(
                  //  rating: wishListItem.,
                  productId: wishListItem.productId?.toInt() ?? -1,
                  initialLiked: true,
                  description: wishListItem.descriptionProduct ?? unknownValue,
                  onLikeTap: (isNowLiked) {
                    // Add to wishlist
                    if (widget.isItWhishList!) {
                      // Remove from wishlist
                      removeFromWhishListCubit.removeFromWishList(context: context, productId: wishListItem.id?.toInt() ?? -1);
                    }
                  },
                  imagePath: wishListItem.productImagePath ?? '',
                  title: wishListItem.product ?? 'Unknown Product'.tr(),
                  price: '\$${wishListItem.priceForProduct?.toString() ?? '0'}',
                );
              },
            );
          }

          // Initial state or any other state
          return const SizedBox();
        },
      ),
    );
  }
}
