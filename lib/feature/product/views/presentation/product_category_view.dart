import 'package:rova_star/core/component/loadsErros/loading_widget.dart';
import 'package:rova_star/core/themes/colors.dart';
import 'package:rova_star/core/utils/constants_models.dart';
import 'package:rova_star/core/utils/custom_show_toast.dart';
import 'package:rova_star/core/utils/navigate.dart';
import 'package:rova_star/feature/Categories/presentation/manager/subCategroy/cubit/sub_category_cubit.dart';
import 'package:rova_star/feature/cart/view/presentation/cart_view.dart';
import 'package:rova_star/feature/favorites/views/manager/wishList/cubit/wish_list_cubit.dart';
import 'package:rova_star/feature/home/views/manager/categories/cubit/categories_cubit.dart';
import 'package:rova_star/feature/home/views/manager/topProduct/cubit/top_product_cubit.dart';
import 'package:rova_star/feature/home/views/presentation/widgets/cart_floating_action_button.dart';
import 'package:rova_star/feature/product/views/presentation/widgets/product_card_theme_two.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ProductCategoryView extends StatefulWidget {
  const ProductCategoryView({super.key});

  @override
  State<ProductCategoryView> createState() => _ProductCategoryViewState();
}

class _ProductCategoryViewState extends State<ProductCategoryView> {
  int selectedCategoryIndex = -1;
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ProductCategoryView oldWidget) {
    loadData();
    super.didUpdateWidget(oldWidget);
  }

  Future<void> loadData() async {
    await categoriesCubit.getCategories(context: context);
    await topProductCubit.getTopProduct(
      context: context,
    );
  }

  TopProductCubit topProductCubit = TopProductCubit();
  SubCategoryCubit subCategoryCubit = SubCategoryCubit();
  CategoriesCubit categoriesCubit = CategoriesCubit();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      floatingActionButton: CartFloatingAB(
        onTap: () async {
          await context.navigateToPage(const CartView());
          await topProductCubit.getTopProduct(
            context: context,
          );
        },
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Custom App Bar
            SliverAppBar(
              title: Text(
                'Products'.tr(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              centerTitle: true,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.white,
              expandedHeight: 65,
              automaticallyImplyLeading: false,
            ),

            // // Categories Horizontal Scrolling List - Using SliverToBoxAdapter
            // BlocProvider.value(
            //   value: categoriesCubit,
            //   child: BlocBuilder<CategoriesCubit, CategoriesState>(
            //     builder: (context, state) {
            //       if (state is CategoriesLoading && (ConstantsModels.categoriesModel?.data?.isEmpty ?? true)) {
            //         return const SliverToBoxAdapter(
            //           child: Center(
            //             child: LoadingWidget(),
            //           ),
            //         );
            //       } else if (state is CategoriesError) {
            //         return const SliverToBoxAdapter(child: SizedBox());
            //       }
            //
            //       final categories = ConstantsModels.categoriesModel?.data;
            //       if (categories == null || categories.isEmpty) {
            //         return const SliverToBoxAdapter(child: SizedBox());
            //       }
            //
            //       return SliverToBoxAdapter(
            //         child: Padding(
            //           padding: const EdgeInsets.symmetric(vertical: 16.0),
            //           child: SizedBox(
            //             height: 35,
            //             child: ListView.builder(
            //               padding: const EdgeInsets.symmetric(horizontal: 16),
            //               scrollDirection: Axis.horizontal,
            //               itemCount: categories.length,
            //               itemBuilder: (context, index) {
            //                 final isSelected = selectedCategoryIndex == index;
            //                 return Padding(
            //                   padding: const EdgeInsets.only(right: 12),
            //                   child: InkWell(
            //                     onTap: () {
            //                       setState(() {
            //                         selectedCategoryIndex = index;
            //                       });
            //                       topProductCubit.getTopProduct(
            //                         context: context,
            //                         subCategoryId: categories[index].id,
            //                       );
            //                     },
            //                     borderRadius: BorderRadius.circular(24),
            //                     child: AnimatedContainer(
            //                       duration: const Duration(milliseconds: 200),
            //                       padding: const EdgeInsets.symmetric(horizontal: 20),
            //                       decoration: BoxDecoration(
            //                         color: isSelected ? AppColors.primaryColor : Colors.white,
            //                         borderRadius: BorderRadius.circular(24),
            //                         border: Border.all(
            //                           color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
            //                         ),
            //                         // boxShadow: isSelected
            //                         //     ? [
            //                         //         BoxShadow(
            //                         //           color: AppColors.primaryColor.withOpacityNew(0.3),
            //                         //           blurRadius: 8,
            //                         //           offset: const Offset(0, 4),
            //                         //         ),
            //                         //       ]
            //                         //     : null,
            //                       ),
            //                       child: Center(
            //                         child: Text(
            //                           categories[index].name ?? 'Unknown Category'.tr(),
            //                           style: TextStyle(
            //                             fontSize: 16.sp,
            //                             color: isSelected ? Colors.white : Colors.black87,
            //                             fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            //                           ),
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 );
            //               },
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),

            // Product Grid - Using SliverPadding and SliverGrid
            BlocProvider.value(
              value: topProductCubit,
              child: BlocBuilder<TopProductCubit, TopProductState>(
                builder: (context, state) {
                  if (state is TopProductLoading && (ConstantsModels.topProductModel?.data?.isEmpty ?? true)) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: LoadingWidget(),
                      ),
                    );
                  } else if (state is TopProductError) {
                    return SliverFillRemaining(
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                              child: Text('Try Again'.tr()),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (ConstantsModels.topProductModel?.data?.isNotEmpty ?? false) {
                    // Check if products list is empty
                    if (ConstantsModels.topProductModel?.data == null || ConstantsModels.topProductModel!.data!.isEmpty) {
                      return SliverFillRemaining(
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
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                ),
                                child: Text('Refresh'.tr()),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // Display products if list is not empty
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverMasonryGrid.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childCount: ConstantsModels.topProductModel?.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          final product = ConstantsModels.topProductModel!.data![index];
                          return ProductCardThemeTwo(
                            sku: product.variants ?? [],
                            skuCode: product.skuCode,
                            description: product.description ?? 'No description available'.tr(),
                            rating: product.reviewsCount?.toDouble() ?? 0.0,
                            productId: product.id ?? -1,
                            initialLiked: false,
                            onLikeTap: (isNowLiked) {
                              final sku = product.skuCode ?? product.variants?.firstOrNull?.skuCode;
                              if (sku == null) {
                                customShowToast(context, 'not_sku_for_this_item'.tr());
                                return;
                              }
                              if (!isNowLiked) {
                                // Add to wishlist
                                context.read<WishListCubit>().addToWishList(context: context, skuCode: sku, product: product);
                              } else {
                                context.read<WishListCubit>().removeFromWishList(context: context, skuCode: sku);
                              }
                            },
                            imagePath: product.imagePath ?? '',
                            title: product.name ?? 'Unknown Product'.tr(),
                            price: '\$${product.price?.toString() ?? '0'}',

                            // Add staggered effect by alternating heights
                            useStaggered: index % 5 == 0 || index % 5 == 3,
                          );
                        },
                      ),
                    );
                  }

                  // Default fallback
                  return SliverFillRemaining(
                    child: Center(
                      child: Text('Loading products...'.tr()),
                    ),
                  );
                },
              ),
            ),

            // Bottom spacing
            const SliverToBoxAdapter(
              child: SizedBox(height: 1000),
            ),
          ],
        ),
      ),
    );
  }
}
