import 'package:rova_star/core/component/cache_image.dart';
import 'package:rova_star/core/themes/colors.dart';
import 'package:rova_star/core/themes/styles.dart';
import 'package:rova_star/feature/home/data/models/product_mdoel.dart';
import 'package:rova_star/feature/product/views/presentation/widgets/items_product_details.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// Product Specifications Section
class ProductSpecsSection extends StatelessWidget {
  const ProductSpecsSection({Key? key, required this.productModelData}) : super(key: key);
  final Product productModelData;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'specifications'.tr(),
            style: Styles.style16400.copyWith(color: AppColors.black, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),

          Row(
            children: [
              Expanded(child: ProductSpecItem(label: 'weight', value: (productModelData.weight ?? 0).toString())),
              Expanded(child: ProductSpecItem(label: 'length', value: (productModelData.length ?? 0).toString())),
            ],
          ),
          Row(
            children: [
              Expanded(child: ProductSpecItem(label: 'width', value: (productModelData.width ?? 0).toString())),
              Expanded(child: ProductSpecItem(label: 'height', value: (productModelData.height ?? 0).toString())),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'additional_info'.tr(),
            style: Styles.style16400.copyWith(color: AppColors.black, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          ProductSpecItem(label: 'tax', value: productModelData.tax ?? 'unknown'),
          ProductSpecItem(label: 'brand', value: productModelData.brand ?? 'unknown'),
          ProductSpecItem(label: 'label', value: productModelData.label ?? 'unknown'),
          if (productModelData.images?.isNotEmpty ?? false) ...[
            const SizedBox(height: 24),
            Text(
              'additional_images'.tr(),
              style: Styles.style16400.copyWith(color: AppColors.black, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            LayoutBuilder(
              builder: (context, constraints) => Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: constraints.maxWidth * .04,
                      runSpacing: 10,
                      children: [
                        ...List.generate(productModelData.images?.length ?? 0, (index) {
                          return CacheImage(width: constraints.maxWidth * .48, height: 150, urlImage: productModelData.images?[index].image);
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          // ItemListWidget(
          //   itemList: productModelData.sizes?.map((e) {
          //         return e.name ?? '';
          //       }).toList() ??
          //       [],
          //   label: 'Sizes',
          // ),
          // ProductColorsItem(colors: colors),
        ],
      ),
    );
  }
}
