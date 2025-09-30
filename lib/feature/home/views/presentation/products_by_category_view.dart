import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:dobzz_seller/core/component/loadsErros/loading_widget.dart';
import 'package:dobzz_seller/feature/home/views/manager/topProduct/cubit/top_product_cubit.dart';
import 'package:dobzz_seller/feature/home/views/presentation/widgets/product_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsByCategoryView extends StatefulWidget {
  const ProductsByCategoryView({super.key, required this.categoryId, required this.title});

  final int categoryId;
  final String title;

  @override
  State<ProductsByCategoryView> createState() => _ProductsByCategoryViewState();
}

class _ProductsByCategoryViewState extends State<ProductsByCategoryView> {
  late TopProductCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = TopProductCubit();
    // Use the generic search endpoint for category browsing
    _cubit.getTopProduct(
      context: context,
      subCategoryId: widget.categoryId,
    );
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
                  productId: product.id?.toInt() ?? -1,
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
