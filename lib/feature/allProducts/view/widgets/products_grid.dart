import 'package:dobzz_seller/feature/home/data/models/product_mdoel.dart';
import 'package:dobzz_seller/feature/home/views/presentation/widgets/product_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ProductsGrid extends StatelessWidget {
  final List<Product> products;

  const ProductsGrid({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No products found'.tr(),
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try selecting a different category'.tr(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          productId: product.id ?? 0,
          imagePath: product.coverImageUrl ?? '',
          title: product.name ?? '',
          price: product.salePrice?.toString() ?? product.price?.toString() ?? '0',
          discountPercentage: _calculateDiscount(product),
          description: product.description ?? '',
          rating: product.averageRating?.toDouble() ?? 0.0,
          initialLiked: product.inWhishlist ?? false,
          variants: product.variants ?? [],
          sku: product.skuCode,
        );
      },
    );
  }

  String? _calculateDiscount(Product product) {
    if (product.priceOld != null && product.salePrice != null && product.priceOld! > product.salePrice!) {
      final discount = ((product.priceOld! - (product.salePrice as num)) / product.priceOld! * 100).round();
      return '$discount%';
    }
    return null;
  }
}
