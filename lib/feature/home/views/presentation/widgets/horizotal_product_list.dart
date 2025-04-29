import 'package:dobzz_seller/core/component/loadsErros/loading_widget.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/feature/favorites/views/manager/wishList/cubit/wish_list_cubit.dart';
import 'package:dobzz_seller/feature/home/views/manager/addToWhishlist/cubit/add_to_wish_list_cubit.dart';
import 'package:dobzz_seller/feature/home/views/manager/removeFromWhislist/cubit/remove_from_whish_list_cubit.dart';
import 'package:dobzz_seller/feature/home/views/manager/topProduct/cubit/top_product_cubit.dart';
import 'package:dobzz_seller/feature/home/views/presentation/widgets/product_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlashSaleHorizontalList extends StatefulWidget {
  const FlashSaleHorizontalList({super.key, this.isItWhishList = false});

  final bool? isItWhishList;

  @override
  State<FlashSaleHorizontalList> createState() => _FlashSaleHorizontalListState();
}

class _FlashSaleHorizontalListState extends State<FlashSaleHorizontalList> {
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
        ? FavoriteHorizontalList(
            wishListCubit: wishListCubit,
            widget: widget,
            removeFromWhishListCubit: removeFromWhishListCubit,
          )
        : TopProductHorizontalList(
            topProductCubit: topProductCubit,
            widget: widget,
            removeFromWhishListCubit: removeFromWhishListCubit,
            addToWishListCubit: addToWishListCubit,
          );
  }
}

class TopProductHorizontalList extends StatelessWidget {
  const TopProductHorizontalList({
    super.key,
    required this.topProductCubit,
    required this.widget,
    required this.removeFromWhishListCubit,
    required this.addToWishListCubit,
  });

  final TopProductCubit topProductCubit;
  final FlashSaleHorizontalList widget;
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
                child: Text('No products available'.tr()),
              );
            }
            // Set a fixed height for the horizontal list items
            const double itemHeight = 280; // Adjust as needed
            const double itemWidth = 180; // Adjust as needed

            //return SizedBox();
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...List.generate(
                    topProducts.length > 4 ? 4 : topProducts.length,
                    (index) {
                      final product = topProducts[index];
                      return Container(
                        width: itemWidth,
                        margin: const EdgeInsets.only(right: 16),
                        child: ProductCard(
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
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }

          // Initial state or any other state
          return const SizedBox();
        },
      ),
    );
  }
}

class FavoriteHorizontalList extends StatelessWidget {
  const FavoriteHorizontalList({
    super.key,
    required this.wishListCubit,
    required this.widget,
    required this.removeFromWhishListCubit,
  });

  final WishListCubit wishListCubit;
  final FlashSaleHorizontalList widget;
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
            // Access the loaded wish list items
            final wishList = ConstantsModels.wishListModel?.data;

            if (wishList == null || wishList.isEmpty) {
              return Center(
                child: Text('No favorites products available'.tr()),
              );
            }

            // Set a fixed height for the horizontal list items
            const double itemHeight = 280; // Adjust as needed
            const double itemWidth = 180; // Adjust as needed

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: itemHeight,
              child: ListView.builder(
                itemCount: wishList.length,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemBuilder: (context, index) {
                  final wishListItem = wishList[index];
                  return Container(
                    width: itemWidth,
                    margin: const EdgeInsets.only(right: 16),
                    child: ProductCard(
                      productId: wishListItem.productId?.toInt() ?? -1,
                      initialLiked: true,
                      onLikeTap: (isNowLiked) {
                        // Add to wishlist
                        if (widget.isItWhishList!) {
                          // Remove from wishlist
                          removeFromWhishListCubit.removeFromWishList(
                            context: context,
                            productId: wishListItem.id?.toInt() ?? -1,
                          );
                        }
                      },
                      imagePath: wishListItem.productImagePath ?? '',
                      title: wishListItem.product ?? 'Unknown Product'.tr(),
                      price: '\$${wishListItem.priceForProduct?.toString() ?? '0'}',
                    ),
                  );
                },
              ),
            );
          }

          // Initial state or any other state
          return const SizedBox();
        },
      ),
    );
  }
}
