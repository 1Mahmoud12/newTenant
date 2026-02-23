import 'package:rova_star/feature/home/data/models/product_mdoel.dart';
import 'package:rova_star/feature/product/views/presentation/widgets/items_product_details.dart';
import 'package:rova_star/feature/product/views/presentation/widgets/product_description_widget.dart';
import 'package:rova_star/feature/product/views/presentation/widgets/product_name_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// Product Information Section
class ProductInfoSection extends StatelessWidget {
  const ProductInfoSection({Key? key, required this.productModelData}) : super(key: key);
  final Product productModelData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductNameWidget(
            productModelData: productModelData,
          ),
          const SizedBox(height: 16),
          ProductDescriptionWidget(
            productModelData: productModelData,
          ),
          const SizedBox(height: 27),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              'basic_information'.tr(),
              style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 16),
          ProductInfoItem(label: 'quantity', value: '${productModelData.quantity}'),
          ProductInfoItem(
            label: 'price',
            value: '${productModelData.price} ${'SAR'.tr()}',
            isPrice: true,
          ),
          ItemListWidget(
            itemList: productModelData.categories?.map((e) {
                  return e.name ?? 'unknown';
                }).toList() ??
                [],
            label: 'category',
          ),
          if (productModelData.subCategories?.isNotEmpty ?? false)
            ItemListWidget(
              itemList: productModelData.subCategories?.map((e) {
                    return e.name ?? 'unknown';
                  }).toList() ??
                  [],
              label: 'sub_category',
            ),
        ],
      ),
    );
  }
}
