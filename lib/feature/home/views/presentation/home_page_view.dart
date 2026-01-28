import 'dart:developer';

import 'package:dobzz_seller/core/component/fields/custom_text_form_field.dart';
import 'package:dobzz_seller/core/component/loadsErros/loading_widget.dart';
import 'package:dobzz_seller/core/component/see_all_widget.dart';
import 'package:dobzz_seller/core/utils/constant_gaping.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/Categories/presentation/categories_veiw.dart';
import 'package:dobzz_seller/feature/home/views/manager/categories/cubit/categories_cubit.dart';
import 'package:dobzz_seller/feature/home/views/manager/salesBanner/cubit/sales_banner_cubit.dart';
import 'package:dobzz_seller/feature/home/views/manager/topProduct/cubit/top_product_cubit.dart';
import 'package:dobzz_seller/feature/home/views/presentation/products_by_category_view.dart';
import 'package:dobzz_seller/feature/home/views/presentation/products_feed_view.dart';
// import 'package:dobzz_seller/feature/home/views/presentation/products_feed_view.dart';
import 'package:dobzz_seller/feature/home/views/presentation/search_product_home_view.dart';
import 'package:dobzz_seller/feature/home/views/presentation/widgets/cart_floating_action_button.dart';
import 'package:dobzz_seller/feature/home/views/presentation/widgets/categories_list.dart';
// import 'package:dobzz_seller/feature/home/views/presentation/widgets/featured_category.dart';
import 'package:dobzz_seller/feature/home/views/presentation/widgets/home_page_header.dart';
import 'package:dobzz_seller/feature/home/views/presentation/widgets/home_slider.dart';
import 'package:dobzz_seller/feature/home/views/presentation/widgets/horizotal_product_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  late TopProductCubit bestsellerCubit;
  late TopProductCubit topCubit;
  late TopProductCubit newCubit;
  @override
  void initState() {
    // if (ConstantsModels.salesBannerModel == null) {
    //   salesBannerCubit.getSaleBanner(context: context);
    // }
    bestsellerCubit = TopProductCubit();
    topCubit = TopProductCubit();
    newCubit = TopProductCubit();
    super.initState();
  }

  SalesBannerCubit salesBannerCubit = SalesBannerCubit();

  @override
  void dispose() {
    bestsellerCubit.close();
    topCubit.close();
    newCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const CartFloatingAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20), // prevent clipping at bottom
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                h20,
                const HomePageHeader(),
                h10,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GestureDetector(
                    onTap: () {
                      context.navigateToPage(const SearchProductHomeView());
                    },
                    child: CustomTextFormField(
                      prefixIcon: const Icon(Icons.search),
                      fillColor: Colors.white,
                      enable: false,
                      controller: TextEditingController(),
                      hintText: 'Search product..'.tr(),
                      outPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                h10,
                const HomeSlider(),
                h10,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SeeAllWidget(
                    title: 'Categories'.tr(),
                    onTap: () {
                      context.navigateToPage(const CategoriesScreen());
                    },
                  ),
                ),
                h10,
                const CategoriesList(),
                h10,
                // Commenting out other sections as requested

                BlocProvider.value(
                  value: bestsellerCubit,
                  child: BlocBuilder<TopProductCubit, TopProductState>(
                    builder: (context, state) {
                      final cubit = TopProductCubit.of(context);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (cubit.bestsellerHasProducts)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              child: SeeAllWidget(
                                title: 'Our Bestseller'.tr(),
                                onTap: () {
                                  context.navigateToPage(
                                    const ProductsFeedView(
                                      feed: ProductsFeed.bestSeller,
                                      title: 'Our Bestseller',
                                    ),
                                  );
                                },
                              ),
                            ),
                          h10,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 7),
                            child: FlashSaleHorizontalList(
                              isHorizontal: true,
                              feed: ProductsFeed.bestSeller,
                              topProductCubit: bestsellerCubit,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                /*  BlocProvider.value(
                  value: topCubit,
                  child: BlocBuilder<TopProductCubit, TopProductState>(
                    builder: (context, state) {
                      final cubit = TopProductCubit.of(context);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (cubit.topHasProducts)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              child: SeeAllWidget(
                                title: 'Top Product'.tr(),
                                onTap: () {
                                  context.navigateToPage(
                                    const ProductsFeedView(
                                      feed: ProductsFeed.top,
                                      title: 'Top Product',
                                    ),
                                  );
                                },
                              ),
                            ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 7),
                            child: FlashSaleHorizontalList(
                              isHorizontal: true,
                              topProductCubit: topCubit,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                BlocProvider.value(
                  value: newCubit,
                  child: BlocBuilder<TopProductCubit, TopProductState>(
                    builder: (context, state) {
                      final cubit = TopProductCubit.of(context);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (cubit.newArrivalHasProducts)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              child: SeeAllWidget(
                                title: 'New Arrival'.tr(),
                                onTap: () {
                                  context.navigateToPage(
                                    const ProductsFeedView(
                                      feed: ProductsFeed.newArrival,
                                      title: 'New Arrival',
                                    ),
                                  );
                                },
                              ),
                            ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 7),
                            child: FlashSaleHorizontalList(
                              isHorizontal: true,
                              feed: ProductsFeed.newArrival,
                              topProductCubit: newCubit,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                h10,
                const FeaturedCategory(),
                const FeaturedList(),
                */
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FeaturedList extends StatefulWidget {
  const FeaturedList({super.key});

  @override
  State<FeaturedList> createState() => _FeaturedListState();
}

class _FeaturedListState extends State<FeaturedList> {
  late CategoriesCubit _categoriesCubit;

  @override
  void initState() {
    super.initState();
    _categoriesCubit = CategoriesCubit();

    // Always fetch categories when this widget is initialized
    _categoriesCubit.getCategories(context: context);
  }

  @override
  void dispose() {
    _categoriesCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _categoriesCubit,
      child: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          if (state is CategoriesLoading) {
            return const Center(
              child: LoadingWidget(),
            );
          } else if (state is CategoriesError) {
            return Center(
              child: Text('Failed to load categories'.tr()),
            );
          } else if (state is CategoriesSuccess || ConstantsModels.categoriesModel != null) {
            // Use the categories model from state or from constants if available
            final categoriesData = ConstantsModels.categoriesModel?.data ?? [];
            final int length = categoriesData.length >= 4 ? 4 : categoriesData.length;

            if (length == 0) {
              return const SizedBox();
            }

            log('Categories loaded successfully with $length items');

            return Column(
              children: List.generate(length, (index) {
                return FeaturedCategoriesItem(
                  featuredName: categoriesData[index].name ?? 'Unknown',
                  categoryId: categoriesData[index].id ?? 0,
                );
              }),
            );
          }

          // Return empty container for initial state
          return const SizedBox();
        },
      ),
    );
  }
}

class FeaturedCategoriesItem extends StatefulWidget {
  const FeaturedCategoriesItem({
    super.key,
    required this.featuredName,
    required this.categoryId,
  });

  final String featuredName;
  final int categoryId;

  @override
  State<FeaturedCategoriesItem> createState() => _FeaturedCategoriesItemState();
}

class _FeaturedCategoriesItemState extends State<FeaturedCategoriesItem> {
  bool _hasProducts = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_hasProducts)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: SeeAllWidget(
              title: widget.featuredName,
              onTap: () {
                context.navigateToPage(
                  ProductsByCategoryView(
                    categoryId: widget.categoryId,
                    title: widget.featuredName,
                  ),
                );
              },
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: FlashSaleHorizontalList(
            isHorizontal: false,
            categoryId: widget.categoryId,
            topProductCubit: TopProductCubit(),
            onProductsLoaded: (count) {
              if (mounted) {
                setState(() {
                  _hasProducts = count > 0;
                });
              }
            },
          ),
        ),
      ],
    );
  }
}
