import 'package:dobzz_seller/core/component/cache_image.dart';
import 'package:dobzz_seller/core/component/loadsErros/loading_widget.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/core/utils/extensions.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/Categories/presentation/manager/subCategroy/cubit/sub_category_cubit.dart';
import 'package:dobzz_seller/feature/product/views/presentation/product_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubcategoryScreen extends StatefulWidget {
  final int categoryId;

  const SubcategoryScreen({
    Key? key,
    required this.categoryId,
  }) : super(key: key);

  @override
  State<SubcategoryScreen> createState() => _SubcategoryScreenState();
}

class _SubcategoryScreenState extends State<SubcategoryScreen> {
  @override
  void initState() {
    subCategoryCubit.getSubCategories(context: context, categoryId: widget.categoryId);
    super.initState();
  }

  SubCategoryCubit subCategoryCubit = SubCategoryCubit();
  @override
  Widget build(BuildContext context) {
    // List of subcategories with their image paths

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Subcategories',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocProvider.value(
        value: subCategoryCubit,
        child: BlocBuilder<SubCategoryCubit, SubCategoryState>(
          builder: (context, state) {
            if (state is SubCategoryLoading) {
              return const Center(child: LoadingWidget());
            }
            if (state is SubCategoryError) {
              return Center(child: Text(state.e));
            }
            if (state is SubCategorySuccess) {
              final subCategories = ConstantsModels.subCategoryModel?.data ?? [];

              if (subCategories.isEmpty) {
                return const Center(
                  child: Text(
                    'No subcategories found.',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.only(top: 8),
                itemCount: subCategories.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: Colors.grey[300],
                ),
                itemBuilder: (context, index) {
                  final subCategory = subCategories[index];
                  return SubcategoryTile(
                    subCategoryId: subCategory.id ?? -1,
                    name: subCategory.name ?? 'Subcategory',
                    imagePath: subCategory.imagePath ?? '',
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class SubcategoryTile extends StatelessWidget {
  final String name;
  final String imagePath;
  final int subCategoryId;
  const SubcategoryTile({
    Key? key,
    required this.name,
    required this.imagePath,
    required this.subCategoryId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.navigateToPage(
          ProductView(
            subCategoryId: subCategoryId,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        color: Colors.white,
        child: Row(
          children: [
            // Subcategory image
            CacheImage(
              height: 50,
              width: 50,
              urlImage: imagePath,
              errorColor: Colors.grey,
            ),
            const SizedBox(width: 16),

            // Subcategory name
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Forward arrow
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

// Adding the CategoriesScreen for reference and completeness
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Categories',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                hintText: 'Find your favorite items',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  CategoryCard(
                    title: 'Women',
                    imageUrl: 'assets/women.jpg',
                    onTap: () => Navigator.pushNamed(context, '/women'),
                  ),
                  CategoryCard(
                    title: 'Men',
                    imageUrl: 'assets/men.jpg',
                    onTap: () {},
                  ),
                  CategoryCard(
                    title: 'Kids',
                    imageUrl: 'assets/kids.jpg',
                    onTap: () {},
                  ),
                  CategoryCard(
                    title: 'Accessories',
                    imageUrl: 'assets/accessories.jpg',
                    onTap: () {},
                  ),
                  CategoryCard(
                    title: 'Offers',
                    imageUrl: 'assets/sale.jpg',
                    isSale: true,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final bool isSale;
  final VoidCallback onTap;

  const CategoryCard({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.onTap,
    this.isSale = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: isSale ? Colors.amber[700] : Colors.grey[300],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image or sale background
              if (isSale)
                Container(
                  color: Colors.amber[700],
                  child: const Center(
                    child: Text(
                      'SALE',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              else
                Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                ),

              // Black overlay label at bottom
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  color: Colors.black.withOpacityNew(0.5),
                  child: Center(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
