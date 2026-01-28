import 'package:dobzz_seller/core/component/cache_image.dart';
import 'package:dobzz_seller/feature/home/data/models/product_mdoel.dart';
import 'package:flutter/material.dart';

// Product Image Section
class ProductImageSection extends StatelessWidget {
  const ProductImageSection({Key? key, required this.productModelData}) : super(key: key);
  final Product productModelData;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      child: CacheImage(
        width: double.infinity,
        height: 250,
        borderRadius: 0,
        urlImage: productModelData.coverImageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}
