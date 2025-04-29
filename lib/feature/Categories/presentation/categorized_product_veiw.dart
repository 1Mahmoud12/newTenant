import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:dobzz_seller/core/component/custom_list.dart';
import 'package:dobzz_seller/core/component/loadsErros/loading_widget.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/feature/Categories/presentation/manager/subCategroy/cubit/sub_category_cubit.dart';
import 'package:dobzz_seller/feature/home/views/manager/addToWhishlist/cubit/add_to_wish_list_cubit.dart';
import 'package:dobzz_seller/feature/home/views/manager/removeFromWhislist/cubit/remove_from_whish_list_cubit.dart';
import 'package:dobzz_seller/feature/home/views/manager/topProduct/cubit/top_product_cubit.dart';
import 'package:dobzz_seller/feature/home/views/presentation/widgets/product_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategorizedProductView extends StatefulWidget {
  const CategorizedProductView({super.key, required this.categoryId});
  final int categoryId;

  @override
  State<CategorizedProductView> createState() => _CategorizedProductViewState();
}

class _CategorizedProductViewState extends State<CategorizedProductView> {
  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    subCategoryCubit.getSubCategories(context: context, categoryId: widget.categoryId);
    topProductCubit.getTopProduct(
      context: context,
      subCategoryId: ConstantsModels.subCategoryModel?.data?.isNotEmpty ?? false ? ConstantsModels.subCategoryModel?.data![0].id : widget.categoryId,
    );
  }

  TopProductCubit topProductCubit = TopProductCubit();
  SubCategoryCubit subCategoryCubit = SubCategoryCubit();
  RemoveFromWhishListCubit removeFromWhishListCubit = RemoveFromWhishListCubit();
  AddToWishListCubit addToWishListCubit = AddToWishListCubit();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: 'Category'),
      body: Column(
        children: [
          // SubCategory List - Fixed Height Part
          if (ConstantsModels.subCategoryModel?.data?.isNotEmpty ?? true)
            BlocProvider.value(
              value: subCategoryCubit,
              child: BlocBuilder<SubCategoryCubit, SubCategoryState>(
                builder: (context, state) {
                  if (state is SubCategoryLoading) {
                    return const Center(
                      child: LoadingWidget(),
                    );
                  } else if (state is SubCategoryError) {
                    return const SizedBox();
                  }
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: CustomList(
                          borderOnlySelection: true,
                          tabs: List.generate(ConstantsModels.subCategoryModel?.data?.length ?? 0, (index) {
                            return ConstantsModels.subCategoryModel?.data![index].name ?? 'unKnowSubCategory';
                          }),
                          onTabChanged: (index) {
                            // Handle tab change logic here
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          const SizedBox(height: 20),

          // Product Grid - Scrollable Part
          BlocProvider.value(
            value: topProductCubit,
            child: BlocBuilder<TopProductCubit, TopProductState>(
              builder: (context, state) {
                if (state is TopProductLoading) {
                  return const Expanded(
                    child: Center(
                      child: LoadingWidget(),
                    ),
                  );
                } else if (state is TopProductError) {
                  return Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 60, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading products'.tr(),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => loadData(),
                            child: Text('Try Again'.tr()),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state is TopProductSuccess) {
                  // Check if products list is empty
                  if (ConstantsModels.productsModel?.data == null || ConstantsModels.productsModel!.data!.isEmpty) {
                    return Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'No products found'.tr(),
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32),
                              child: Text(
                                'There are no products available in this category right now'.tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () => loadData(),
                              child: Text('Refresh'.tr()),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Display products if list is not empty
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.builder(
                        itemCount: ConstantsModels.productsModel?.data?.length ?? 0,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.6,
                        ),
                        itemBuilder: (context, index) {
                          final product = ConstantsModels.productsModel?.data![index];
                          return ProductCard(
                            description: product?.description ?? 'No description available'.tr(),
                            rating: product?.reviewsCount?.toDouble() ?? 0.0,
                            productId: product?.id ?? -1,
                            initialLiked: false,
                            onLikeTap: (isNowLiked) {
                              addToWishListCubit.addToWishList(context: context, productId: product?.id ?? -1);
                            },
                            imagePath: product?.imagePath ?? '',
                            title: product?.name ?? 'Unknown Product'.tr(),
                            price: '\$${product?.price?.toString() ?? '0'}',
                          );
                        },
                      ),
                    ),
                  );
                }

                // Default fallback
                return Expanded(
                  child: Center(
                    child: Text('Loading products...'.tr()),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
