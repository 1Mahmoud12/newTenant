import 'package:rova_star/core/component/loadsErros/loading_widget.dart';
import 'package:rova_star/feature/home/views/manager/topProduct/cubit/top_product_cubit.dart';
import 'package:rova_star/feature/home/views/presentation/widgets/product_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  @override
  void initState() {
    super.initState();
    _cubit = TopProductCubit();
    _cubit.getProductsByFeed(context: context, feed: widget.feed);
  }

  @override
  void dispose() {
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
            if (state is TopProductLoading && _cubit.products.isEmpty) {
              return const Center(child: LoadingWidget());
            }
            if (state is TopProductError) {
              return Center(child: Text('${'Error:'.tr()}${state.e}'));
            }
            final products = _cubit.products;
            if (products.isEmpty) {
              return Center(child: Text('No products found'.tr()));
            }
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.68,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  variants: product.variants ?? [],
                  sku: product.skuCode,
                  description: product.description ?? 'No description available'.tr(),
                  rating: product.reviewsCount?.toDouble() ?? 0.0,
                  productId: product.id ?? -1,
                  initialLiked: false,
                  onLikeTap: (_) {},
                  imagePath: product.imagePath ?? '',
                  title: product.name ?? 'Unknown Product'.tr(),
                  price: product.price?.toString() ?? '0',
                );
              },
            );
          },
        ),
      ),
    );
  }
}
