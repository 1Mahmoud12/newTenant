import 'package:dobzz_seller/core/component/loadsErros/loading_widget.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/app_icons.dart';
import 'package:dobzz_seller/core/utils/constant_gaping.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/feature/Categories/presentation/manager/subCategroy/cubit/sub_category_cubit.dart';
import 'package:dobzz_seller/feature/home/views/manager/addToWhishlist/cubit/add_to_wish_list_cubit.dart';
import 'package:dobzz_seller/feature/home/views/manager/categories/cubit/categories_cubit.dart';
import 'package:dobzz_seller/feature/home/views/manager/removeFromWhislist/cubit/remove_from_whish_list_cubit.dart';
import 'package:dobzz_seller/feature/home/views/manager/topProduct/cubit/top_product_cubit.dart';
import 'package:dobzz_seller/feature/home/views/presentation/widgets/cart_floating_action_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';

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

  Future<void> loadData() async {
    await categoriesCubit.getCategories(context: context);
    await topProductCubit.getTopProduct(
      context: context,
    );
  }

  TopProductCubit topProductCubit = TopProductCubit();
  SubCategoryCubit subCategoryCubit = SubCategoryCubit();
  RemoveFromWhishListCubit removeFromWhishListCubit = RemoveFromWhishListCubit();
  AddToWishListCubit addToWishListCubit = AddToWishListCubit();
  CategoriesCubit categoriesCubit = CategoriesCubit();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      floatingActionButton: const CartFloatingAB(),
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

            // Categories Horizontal Scrolling List - Using SliverToBoxAdapter
            BlocProvider.value(
              value: categoriesCubit,
              child: BlocBuilder<CategoriesCubit, CategoriesState>(
                builder: (context, state) {
                  if (state is CategoriesLoading) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: LoadingWidget(),
                      ),
                    );
                  } else if (state is CategoriesError) {
                    return const SliverToBoxAdapter(child: SizedBox());
                  }

                  final categories = ConstantsModels.categoriesModel?.data;
                  if (categories == null || categories.isEmpty) {
                    return const SliverToBoxAdapter(child: SizedBox());
                  }

                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: SizedBox(
                        height: 35,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final isSelected = selectedCategoryIndex == index;
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedCategoryIndex = index;
                                  });
                                  topProductCubit.getTopProduct(
                                    context: context,
                                    subCategoryId: categories[index].id,
                                  );
                                },
                                borderRadius: BorderRadius.circular(24),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.primaryColor : Colors.white,
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
                                    ),
                                    // boxShadow: isSelected
                                    //     ? [
                                    //         BoxShadow(
                                    //           color: AppColors.primaryColor.withOpacity(0.3),
                                    //           blurRadius: 8,
                                    //           offset: const Offset(0, 4),
                                    //         ),
                                    //       ]
                                    //     : null,
                                  ),
                                  child: Center(
                                    child: Text(
                                      categories[index].name ?? 'Unknown Category'.tr(),
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: isSelected ? Colors.white : Colors.black87,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Product Grid - Using SliverPadding and SliverGrid
            BlocProvider.value(
              value: topProductCubit,
              child: BlocBuilder<TopProductCubit, TopProductState>(
                builder: (context, state) {
                  if (state is TopProductLoading) {
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
                  } else if (state is TopProductSuccess) {
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
                          final product = ConstantsModels.topProductModel?.data![index];
                          return EnhancedProductCard(
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
              child: SizedBox(height: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class EnhancedProductCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String price;
  final String description;
  final double rating;
  final int productId;
  final bool initialLiked;
  final Function(bool) onLikeTap;
  final bool useStaggered;

  const EnhancedProductCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.price,
    required this.description,
    required this.rating,
    required this.productId,
    required this.initialLiked,
    required this.onLikeTap,
    this.useStaggered = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with Like Button
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: useStaggered ? 1 : 1.2,
                  child: Image.network(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.grey[400],
                            size: 40,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: LikeButton(
                        initialLiked: initialLiked,
                        onTap: onLikeTap,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Product Information
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SvgPicture.asset(AppIcons.unSelectedCartC),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LikeButton extends StatefulWidget {
  final bool initialLiked;
  final Function(bool) onTap;

  const LikeButton({
    Key? key,
    required this.initialLiked,
    required this.onTap,
  }) : super(key: key);

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> with SingleTickerProviderStateMixin {
  late bool isLiked;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    isLiked = widget.initialLiked;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.grey,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                isLiked = !isLiked;
              });
              _controller.forward(from: 0.0);
              widget.onTap(isLiked);
            },
          ),
        );
      },
    );
  }
}
