import 'package:dobzz_seller/core/component/loadsErros/loading_widget.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/Categories/presentation/categorized_product_veiw.dart';
import 'package:dobzz_seller/feature/Categories/presentation/sub_category_view.dart';
import 'package:dobzz_seller/feature/home/data/models/categories_model.dart';
import 'package:dobzz_seller/feature/home/views/manager/categories/cubit/categories_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Main widget that decides which layout to use based on category count
class FeaturedCategory extends StatefulWidget {
  const FeaturedCategory({
    Key? key,
  }) : super(key: key);

  @override
  State<FeaturedCategory> createState() => _FeaturedCategoryState();
}

class _FeaturedCategoryState extends State<FeaturedCategory> {
  late CategoriesCubit _categoriesCubit;

  @override
  void initState() {
    super.initState();
    _categoriesCubit = CategoriesCubit();
    if (ConstantsModels.categoriesModel == null) {
      _categoriesCubit.getCategories(context: context);
    }
  }

  @override
  void dispose() {
    _categoriesCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      bloc: _categoriesCubit,
      builder: (context, state) {
        // Handle different states
        if (state is CategoriesLoading) {
          return const Center(
            child: LoadingWidget(),
          );
        }

        if (state is CategoriesError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Error loading categories: ${state.e}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _categoriesCubit.getCategories(context: context),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        // Success state or initial state with cached data
        if (state is CategoriesSuccess || ConstantsModels.categoriesModel != null) {
          // Ensure we never exceed 4 categories
          final int categoriesLength = ConstantsModels.categoriesModel?.data?.length ?? 0;
          final validCategories =
              categoriesLength >= 4 ? ConstantsModels.categoriesModel?.data?.sublist(0, 4) : ConstantsModels.categoriesModel?.data ?? [];

          // Choose layout based on number of categories
          if (validCategories?.isEmpty ?? true) {
            return const Center(
              child: Text('No categories available'),
            );
          }

          switch (validCategories?.length) {
            case 1:
              return SingleCategoryLayout(category: validCategories![0]);
            case 2:
              return TwoCategoryLayout(
                category1: validCategories![0],
                category2: validCategories[1],
              );
            case 3:
              return ThreeCategoryLayout(
                category1: validCategories![0],
                category2: validCategories[1],
                category3: validCategories[2],
              );
            case 4:
              return FourCategoryLayout(categories: validCategories ?? []);
            default:
              return const SizedBox(); // Empty widget for 0 categories
          }
        }

        // Initial state with no cached data (should be covered by the loading state)
        return const SizedBox();
      },
    );
  }
}

// Single category layout - takes full width
class SingleCategoryLayout extends StatelessWidget {
  final CategoryData category;

  const SingleCategoryLayout({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CategoryCard(category: category),
    );
  }
}

// Two category layout - horizontal layout
class TwoCategoryLayout extends StatelessWidget {
  final CategoryData category1;
  final CategoryData category2;

  const TwoCategoryLayout({
    Key? key,
    required this.category1,
    required this.category2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 160,
            margin: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
            child: CategoryCard(category: category1),
          ),
        ),
        Expanded(
          child: Container(
            height: 160,
            margin: const EdgeInsets.only(left: 8, right: 16, top: 8, bottom: 8),
            child: CategoryCard(category: category2),
          ),
        ),
      ],
    );
  }
}

// Three category layout - one large on top, two smaller below
class ThreeCategoryLayout extends StatelessWidget {
  final CategoryData category1;
  final CategoryData category2;
  final CategoryData category3;

  const ThreeCategoryLayout({
    Key? key,
    required this.category1,
    required this.category2,
    required this.category3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 160,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: CategoryCard(category: category1),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 140,
                margin: const EdgeInsets.only(left: 16, right: 8, bottom: 8),
                child: CategoryCard(category: category2),
              ),
            ),
            Expanded(
              child: Container(
                height: 140,
                margin: const EdgeInsets.only(left: 8, right: 16, bottom: 8),
                child: CategoryCard(category: category3),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Four category layout - grid with 2x2 items
class FourCategoryLayout extends StatelessWidget {
  final List<CategoryData> categories;

  const FourCategoryLayout({
    Key? key,
    required this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      padding: const EdgeInsets.all(16),
      children: categories.map((category) => CategoryCard(category: category)).toList(),
    );
  }
}

// Individual category card widget
class CategoryCard extends StatelessWidget {
  final CategoryData category;

  const CategoryCard({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.navigateToPage(
          CategorizedProductView(
            categoryId: category.id ?? 0,
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image background
            Image.network(
              category.imagePath ?? '',
              fit: BoxFit.cover,
            ),
            // Overlay for contrast with text
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
            ),
            // Category name
            Positioned(
              bottom: 16,
              left: 16,
              child: Text(
                category.name ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
