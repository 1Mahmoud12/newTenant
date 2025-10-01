import 'package:dobzz_seller/core/component/loadsErros/loading_widget.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/core/utils/custom_show_toast.dart';
import 'package:dobzz_seller/core/utils/errorLoadingWidgets/empty_widget.dart';
import 'package:dobzz_seller/feature/favorites/views/manager/wishList/cubit/wish_list_cubit.dart';
import 'package:dobzz_seller/feature/home/views/manager/topProduct/cubit/top_product_cubit.dart';
import 'package:dobzz_seller/feature/home/views/presentation/widgets/empty_product.dart';
import 'package:dobzz_seller/feature/home/views/presentation/widgets/product_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      WishListCubit.get(context).getWishList(context: context);
    } else {
      if (ConstantsModels.topProductModel == null) {
        topProductCubit.getTopProduct(context: context);
      }
    }
  }

  TopProductCubit topProductCubit = TopProductCubit();
  @override
  Widget build(BuildContext context) {
    return widget.isItWhishList!
        ? FavoriteGrid(
            widget: widget,
          )
        : TopProductGrid(
            topProductCubit: topProductCubit,
            widget: widget,
          );
  }
}

class TopProductGrid extends StatelessWidget {
  const TopProductGrid({
    super.key,
    required this.topProductCubit,
    required this.widget,
  });

  final TopProductCubit topProductCubit;
  final FlashSaleGrid widget;

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
                  onButtonPressed: () {},
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
                  variants: product.variants ?? [],
                  description: product.description ?? 'No description available'.tr(),
                  rating: product.reviewsCount?.toDouble() ?? 0.0,
                  productId: product.id ?? -1,
                  initialLiked: widget.isItWhishList!,
                  onLikeTap: (isNowLiked) {
                    final sku = product.skuCode ?? product.variants?.firstOrNull?.skuCode;
                    if (sku == null) {
                      customShowToast(context, 'not_sku_for_this_item'.tr());
                      return;
                    }
                    if (isNowLiked) {
                      // Add to wishlist
                      context.read<WishListCubit>().removeFromWishList(context: context, skuCode: sku);
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
    required this.widget,
  });

  final FlashSaleGrid widget;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: WishListCubit.get(context),
      child: BlocBuilder<WishListCubit, WishListState>(
        builder: (context, state) {
          if (state is WishListLoading && WishListCubit.get(context).wishList.isEmpty) {
            return const Center(
              child: LoadingWidget(),
            );
          } else if (state is WishListError) {
            return Center(
              child: Text('${'Error:'.tr()}${state.e}'),
            );
          } else if (WishListCubit.get(context).wishList.isNotEmpty) {
            // Access the loaded top products
            final wishList = WishListCubit.get(context).wishList;

            if (wishList.isEmpty) {
              return EmptyWidget(
                data: 'No Saved Items!'.tr(),
                subData: 'You don’t have any saved items. Go to home and add some.'.tr(),
                emptyImage: EmptyImages.noSavedItem,
              );
            }
            return Stack(
              children: [
                GridView.builder(
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

                    ///TODO: add sku
                    return ProductCard(
                      variants: const [],
                      //  rating: wishListItem.,
                      sku: wishListItem.skuCode,
                      productId: wishListItem.productId?.toInt() ?? -1,
                      initialLiked: true,
                      description: wishListItem.descriptionProduct ?? unknownValue,
                      onLikeTap: (isNowLiked) {
                        final sku = wishListItem.skuCode;
                        if (sku == null) {
                          customShowToast(
                            context,
                            'not_sku_for_this_item'.tr(),
                          );
                          return;
                        }
                        if (isNowLiked) {
                          context.read<WishListCubit>().removeFromWishList(
                                context: context,
                                skuCode: sku,
                              );
                        }
                      },
                      imagePath: wishListItem.productImagePath ?? '',
                      title: wishListItem.product ?? 'Unknown Product'.tr(),
                      price: '\$${wishListItem.priceForProduct?.toString() ?? '0'}',
                    );
                  },
                ),
                if (state is WishListLoading && WishListCubit.get(context).wishList.isNotEmpty) ...[
                  const Center(
                    child: LoadingWidget(),
                  ),
                ],
              ],
            );
          }

          // Initial state or any other state
          return const SizedBox();
        },
      ),
    );
  }
}
