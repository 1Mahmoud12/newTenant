import 'package:dobzz_seller/core/component/cache_image.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/core/utils/extensions.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/allProducts/view/all_products_view.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Categories',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: TextField(
          //     decoration: InputDecoration(
          //       filled: true,
          //       fillColor: Colors.grey[100],
          //       hintText: 'Find your favorite items',
          //       prefixIcon: const Icon(Icons.search, color: Colors.grey),
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(10),
          //         borderSide: BorderSide.none,
          //       ),
          //       contentPadding: const EdgeInsets.symmetric(),
          //     ),
          //   ),
          const SizedBox(
            height: 20,
          ),
          // ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: List.generate(ConstantsModels.categoriesModel?.data?.length ?? 0, (index) {
                  final category = ConstantsModels.categoriesModel?.data?[index];
                  if (category == null) return const SizedBox();

                  return CategoryCard(
                    onTap: () {
                      context.navigateToPage(
                        const AllProductsView(),
                      );
                    },
                    title: category.name ?? 'Category',
                    imageUrl: category.imagePathFullUrl ?? category.imagePath ?? 'https://via.placeholder.com/150',
                  );
                }),
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
  final void Function()? onTap;
  const CategoryCard({
    Key? key,
    required this.title,
    required this.imageUrl,
    this.isSale = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
                CacheImage(
                  urlImage: imageUrl,
                  errorColor: Colors.grey,
                  fit: BoxFit.fill,
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
