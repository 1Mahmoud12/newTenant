import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/feature/allProducts/manager/cubit/all_products_cubit.dart';
import 'package:dobzz_seller/feature/allProducts/view/widgets/category_tabs.dart';
import 'package:dobzz_seller/feature/allProducts/view/widgets/products_grid.dart';
import 'package:dobzz_seller/feature/home/views/manager/categories/cubit/categories_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AllProductsView extends StatefulWidget {
  const AllProductsView({super.key});

  @override
  State<AllProductsView> createState() => _AllProductsViewState();
}

class _AllProductsViewState extends State<AllProductsView> {
  late final AllProductsCubit _productsCubit;
  late final CategoriesCubit _categoriesCubit;

  @override
  void initState() {
    super.initState();
    _productsCubit = AllProductsCubit();
    _categoriesCubit = CategoriesCubit();

    _productsCubit.fetchProducts();
    _categoriesCubit.getAllCategories();
  }

  @override
  void dispose() {
    _productsCubit.close();
    _categoriesCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context: context,
        title: 'All Products'.tr(),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _productsCubit),
          BlocProvider.value(value: _categoriesCubit),
        ],
        child: BlocBuilder<AllProductsCubit, AllProductsState>(
          builder: (context, productsState) {
            if (productsState is AllProductsLoading) {
              return _buildLoadingState();
            }

            if (productsState is AllProductsError) {
              return _buildErrorState(productsState.message);
            }

            if (productsState is AllProductsSuccess) {
              return Column(
                children: [
                  BlocBuilder<CategoriesCubit, CategoriesState>(
                    builder: (context, categoriesState) {
                      if (categoriesState is CategoriesSuccess) {
                        return CategoryTabs(
                          categories: categoriesState.data,
                          selectedCategoryId: productsState.selectedCategoryId,
                          onCategoryTap: (categoryId) {
                            _productsCubit.filterByCategory(categoryId);
                          },
                        );
                      }
                      return const SizedBox(height: 50); // Placeholder height
                    },
                  ),
                  Expanded(
                    child: ProductsGrid(
                      products: productsState.filteredProducts,
                    ),
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Skeletonizer(
      enabled: true,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 12,
                        width: 80,
                        color: Colors.grey.shade300,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading products'.tr(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              _productsCubit.fetchProducts();
              _categoriesCubit.getAllCategories();
            },
            icon: const Icon(Icons.refresh),
            label: Text('Retry'.tr()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
