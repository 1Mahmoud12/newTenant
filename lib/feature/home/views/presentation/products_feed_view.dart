import 'package:dobzz_seller/core/component/loadsErros/loading_widget.dart';
import 'package:dobzz_seller/feature/home/views/manager/topProduct/cubit/top_product_cubit.dart';
import 'package:dobzz_seller/feature/home/views/presentation/widgets/product_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/component/custom_app_bar.dart';

class ProductsFeedView extends StatefulWidget {
  const ProductsFeedView({super.key, required this.feed, required this.title});

  final ProductsFeed feed;
  final String title;

  @override
  State<ProductsFeedView> createState() => _ProductsFeedViewState();
}

class _ProductsFeedViewState extends State<ProductsFeedView> {
  late TopProductCubit _cubit;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _cubit = TopProductCubit();
    // Pass isRefresh: true to ensure clean start
    _cubit.getProductsByFeed(context: context, feed: widget.feed, isRefresh: true);

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
      _cubit.loadMoreProducts(context);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: widget.title),
      body: BlocProvider.value(
        value: _cubit,
        child: BlocBuilder<TopProductCubit, TopProductState>(
          builder: (context, state) {
            if ((state is TopProductLoading && _cubit.products.isEmpty) || state is TopProductInitial) {
              return Skeletonizer(
                effect: ShimmerEffect(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                ),
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.68,
                  ),
                  itemCount: 6, // Show 6 dummy items for shimmer
                  itemBuilder: (context, index) {
                    return ProductCard(
                      variants: [],
                      sku: 'sku',
                      description: 'Description',
                      rating: 5.0,
                      productId: 0,
                      initialLiked: false,
                      onLikeTap: (_) {},
                      imagePath: '',
                      title: 'Product Title',
                      price: '100',
                    );
                  },
                ),
              );
            }
            if (state is TopProductError && _cubit.products.isEmpty) {
              return Center(child: Text('${'Error:'.tr()}${state.e}'));
            }
            final products = _cubit.products;
            if (products.isEmpty) {
              return Center(child: Text('No products found'.tr()));
            }
            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.68,
                    ),
                    itemCount: products.length + (_cubit.isLoadingMore ? 2 : 0),
                    itemBuilder: (context, index) {
                      if (index >= products.length) {
                        return const Center(child: LoadingWidget());
                      }

                      final product = products[index];
                      return ProductCard(
                        variants: product.variants ?? [],
                        sku: product.slug,
                        description: product.description ?? 'No description available'.tr(),
                        rating: product.reviewsCount?.toDouble() ?? 0.0,
                        productId: product.id ?? -1,
                        initialLiked: false,
                        onLikeTap: (_) {},
                        imagePath: product.coverImageUrl ?? '',
                        title: product.name ?? 'Unknown Product'.tr(),
                        price: product.price?.toString() ?? '0',
                      );
                    },
                  ),
                ),
                if (_cubit.isLoadingMore)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: LoadingWidget()),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
