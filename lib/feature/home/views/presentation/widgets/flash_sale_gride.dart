import 'package:dobzz_seller/core/component/loadsErros/loading_widget.dart';
import 'package:dobzz_seller/feature/home/views/manager/addToWhishlist/cubit/add_to_wish_list_cubit.dart';
import 'package:dobzz_seller/feature/home/views/manager/topProduct/cubit/top_product_cubit.dart';
import 'package:dobzz_seller/feature/home/views/presentation/widgets/flash_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';

class FlashSaleGrid extends StatefulWidget {
  const FlashSaleGrid({super.key});

  @override
  State<FlashSaleGrid> createState() => _FlashSaleGridState();
}

class _FlashSaleGridState extends State<FlashSaleGrid> {
  @override
  void initState() {
    super.initState();
    // Fetch top products when widget initializes
    topProductCubit.getTopProduct(context: context);
  }

  TopProductCubit topProductCubit = TopProductCubit();
  AddToWishListCubit addToWishListCubit = AddToWishListCubit();
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
              child: Text('Error: ${state.e}'),
            );
          } else if (state is TopProductSuccess) {
            // Access the loaded top products
            final topProducts = ConstantsModels.topProductModel?.data;

            if (topProducts == null || topProducts.isEmpty) {
              return const Center(
                child: Text('No products available'),
              );
            }
            return GridView.builder(
              itemCount: topProducts.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.6,
              ),
              itemBuilder: (context, index) {
                final product = topProducts[index];
                return ProductCard(
                  onLikeTap: (isNowLiked) {
                    if (isNowLiked) addToWishListCubit.addToWishList(context: context, productId: product.id ?? -1);
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
    );
  }
}
