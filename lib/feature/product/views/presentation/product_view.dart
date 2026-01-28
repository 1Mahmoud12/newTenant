import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:dobzz_seller/core/component/loadsErros/loading_widget.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/feature/favorites/views/manager/wishList/cubit/wish_list_cubit.dart';
import 'package:dobzz_seller/feature/home/views/manager/topProduct/cubit/top_product_cubit.dart';
import 'package:dobzz_seller/feature/home/views/presentation/widgets/empty_product.dart';
import 'package:dobzz_seller/feature/home/views/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key, this.subCategoryId});
  final int? subCategoryId;
  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      topProductCubit = TopProductCubit.of(context);
      topProductCubit.getTopProduct(
        context: context,
        subCategoryId: widget.subCategoryId,
      );
    });
    super.initState();
  }

  late TopProductCubit topProductCubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: 'Products'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocProvider.value(
          value: topProductCubit,
          child: BlocBuilder<TopProductCubit, TopProductState>(
            builder: (context, state) {
              if (state is TopProductLoading) {
                return const Center(
                  child: LoadingWidget(),
                );
              } else if (state is TopProductError) {
                return Center(
                  child: Text('Error: ${state.e}'),
                );
              } else if (state is TopProductSuccess) {
                // Access the loaded top products
                final products = widget.subCategoryId == null ? ConstantsModels.topProductModel?.data : ConstantsModels.productsModel?.data;

                if (products == null || products.isEmpty) {
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
                return GridView.builder(
                  itemCount: products.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.58,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(
                      variants: product.variants ?? [],
                      productId: product.id ?? -1,
                      initialLiked: false,
                      sku: product.skuCode,
                      onLikeTap: (isNowLiked) {
                        if (isNowLiked && product.id != null) {
                          context.read<WishListCubit>().addToWishList(
                                context: context,
                                productId: product.id!,
                              );
                        }
                      },
                      imagePath: product.imagePath ?? '',
                      title: product.name ?? 'Unknown Product',
                      price: '\$${product.price?.toString() ?? '0'}',
                    );
                  },
                );
              }

              // Initial state or any other state
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
