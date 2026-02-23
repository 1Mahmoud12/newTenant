import 'package:rova_star/core/component/loadsErros/loading_widget.dart';
import 'package:rova_star/core/utils/constants_models.dart';
import 'package:rova_star/core/utils/custom_show_toast.dart';
import 'package:rova_star/core/utils/utils.dart';
import 'package:rova_star/feature/favorites/views/manager/wishList/cubit/wish_list_cubit.dart';
import 'package:rova_star/feature/home/views/manager/topProduct/cubit/top_product_cubit.dart';
import 'package:rova_star/feature/home/views/presentation/widgets/empty_product.dart';
import 'package:rova_star/feature/home/views/presentation/widgets/product_card.dart';
import 'package:rova_star/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlashSaleHorizontalList extends StatefulWidget {
  const FlashSaleHorizontalList({
    super.key,
    this.isItWhishList = false,
    required this.isHorizontal,
    this.categoryId,
    this.feed = ProductsFeed.top,
    this.onProductsLoaded,
    required this.topProductCubit,
  });

  final bool? isItWhishList;
  final bool isHorizontal;
  final int? categoryId;
  final ProductsFeed feed;
  final TopProductCubit topProductCubit;
  final ValueChanged<int>? onProductsLoaded;
  @override
  State<FlashSaleHorizontalList> createState() => _FlashSaleHorizontalListState();
}

class _FlashSaleHorizontalListState extends State<FlashSaleHorizontalList> {
  @override
  void initState() {
    super.initState();
    topProductCubit = widget.topProductCubit;
    // Fetch top products when widget initializes
    if (widget.isItWhishList!) {
      WishListCubit.get(context).getWishList(context: context);
    } else {
      // If a category is specified, use the generic search endpoint (shop/products)
      if (widget.categoryId != null) {
        topProductCubit.getTopProduct(
          context: context,
          subCategoryId: widget.categoryId,
        );
      } else {
        // Otherwise use the selected feed endpoint
        topProductCubit.getProductsByFeed(
          context: context,
          feed: widget.feed,
        );
      }
    }
  }

  late TopProductCubit topProductCubit;

  @override
  Widget build(BuildContext context) {
    return !mounted
        ? const SizedBox()
        : widget.isItWhishList!
            ? FavoriteHorizontalList(
                widget: widget,
              )
            : TopProductHorizontalList(
                isHorizontal: widget.isHorizontal,
                topProductCubit: topProductCubit,
                widget: widget,
                //onProductsLoaded: widget.onProductsLoaded,
              );
  }
}

class TopProductHorizontalList extends StatelessWidget {
  const TopProductHorizontalList({
    super.key,
    required this.topProductCubit,
    required this.widget,
    required this.isHorizontal,
    this.feed = ProductsFeed.top,
    this.onProductsLoaded,
  });

  final TopProductCubit topProductCubit;
  final FlashSaleHorizontalList widget;
  final bool isHorizontal;
  final ProductsFeed feed;
  final ValueChanged<int>? onProductsLoaded;

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
            // Notify empty on error
            onProductsLoaded?.call(0);
            return Center(
              child: Text('${'Error:'.tr()}${state.e}'),
            );
          } else if (topProductCubit.products.isNotEmpty) {
            // Access the loaded top products
            final topProducts = topProductCubit.products;
            // Notify parent of products count
            onProductsLoaded?.call(topProducts.length);

            if (topProducts.isEmpty) {
              return Center(
                child: NoProductsAvailable(
                  message: 'No products found in this category',
                  buttonText: 'Browse other categories',
                  onButtonPressed: () {
                    // Navigate to categories or perform other actions
                  },
                ),
              );
            }
            // Set a fixed height for the horizontal list items
            final double itemWidth = isHorizontal ? 300 : 180; // Adjust as needed

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
                        child: isHorizontal
                            ? HorizontalProductCard(
                                variants: product.variants ?? [],
                                description: product.description ?? 'No description available'.tr(),
                                rating: product.reviewsCount?.toDouble() ?? 0.0,
                                sku: product.skuCode,
                                productId: product.id ?? -1,
                                initialLiked: widget.isItWhishList!,
                                onLikeTap: (isNowLiked) {
                                  final sku = product.skuCode ?? product.variants?.firstOrNull?.skuCode;
                                  if (sku == null) {
                                    Utils.showToast(
                                      title: 'not_sku_for_this_item'.tr(),
                                      state: UtilState.warning,
                                    );
                                    return;
                                  }
                                  if (isNowLiked) {
                                    // Remove from wishlist
                                    context.read<WishListCubit>().removeFromWishList(
                                          context: context,
                                          skuCode: sku,
                                        );
                                  } else {
                                    logger.i(
                                      'Add to wishlist WishListed $isNowLiked',
                                    );
                                    // Add to wishlist
                                    context.read<WishListCubit>().addToWishList(
                                          context: context,
                                          skuCode: sku,
                                          product: product,
                                        );
                                  }
                                },
                                imagePath: product.imagePath ?? '',
                                title: product.name ?? 'Unknown Product'.tr(),
                                price: product.price?.toString() ?? '0',
                              )
                            : ProductCard(
                                variants: product.variants ?? [],
                                sku: product.skuCode,
                                description: product.description ?? 'No description available'.tr(),
                                rating: product.reviewsCount?.toDouble() ?? 0.0,
                                productId: product.id ?? -1,
                                initialLiked: widget.isItWhishList!,
                                onLikeTap: (isNowLiked) {
                                  final sku = product.skuCode ?? product.variants?.firstOrNull?.skuCode;
                                  if (sku == null) {
                                    customShowToast(
                                      context,
                                      'not_sku_for_this_item'.tr(),
                                    );
                                    return;
                                  }
                                  if (isNowLiked) {
                                    // Add to wishlist
                                    context.read<WishListCubit>().removeFromWishList(
                                          context: context,
                                          skuCode: sku,
                                        );
                                  } else {
                                    context.read<WishListCubit>().addToWishList(
                                          context: context,
                                          skuCode: sku,
                                          product: product,
                                        );
                                  }
                                },
                                imagePath: product.imagePath ?? '',
                                title: product.name ?? 'Unknown Product'.tr(),
                                price: product.price?.toString() ?? '0',
                              ),
                      );
                    },
                  ),
                ],
              ),
            );
          }

          // Do not trigger fetches here to avoid repeated calls on rebuilds.
          // Fetching is handled once in initState of FlashSaleHorizontalList.
          // If we reach here with no data, notify empty
          onProductsLoaded?.call(0);
          return const SizedBox();
        },
      ),
    );
  }
}

class FavoriteHorizontalList extends StatelessWidget {
  const FavoriteHorizontalList({
    super.key,
    required this.widget,
  });

  final FlashSaleHorizontalList widget;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishListCubit, WishListState>(
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
          const double itemHeight = 300; // Adjust as needed
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

                  ///TODO: add sku
                  child: ProductCard(
                    variants: const [],
                    productId: wishListItem.productId?.toInt() ?? -1,
                    initialLiked: true,
                    onLikeTap: (isNowLiked) {
                      final sku = wishListItem.skuCode;
                      if (sku == null) {
                        customShowToast(context, 'not_sku_for_this_item'.tr());
                        return;
                      }
                      context.read<WishListCubit>().removeFromWishList(context: context, skuCode: sku);
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
    );
  }
}
