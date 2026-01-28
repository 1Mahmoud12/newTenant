import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// Product Specification Item Widget
class ProductSpecItem extends StatelessWidget {
  final String label;
  final String value;

  const ProductSpecItem({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: const Border(
          bottom: BorderSide(
            color: Color(0xFFEDEDED),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${label.tr()}: ',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

// Product Sizes Item Widget
class ItemListWidget extends StatelessWidget {
  final List<String> itemList;
  final String label;

  const ItemListWidget({Key? key, required this.itemList, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displaySizes = itemList.take(10).toList();
    final hasMore = itemList.length > 10;

    return Container(
      //  margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: const Border(
          bottom: BorderSide(
            color: Color(0xFFEDEDED),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      label.tr(),
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: displaySizes.map((size) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Text(
                            size,
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        );
                      }).toList(),
                    ),
                    if (hasMore) ...[
                      const SizedBox(height: 8),
                      Text(
                        '+${itemList.length - 10} more sizes',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Product Information Item Widget
class ProductInfoItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isPrice;

  const ProductInfoItem({
    Key? key,
    required this.label,
    required this.value,
    this.isPrice = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: const Border(
          bottom: BorderSide(
            color: Color(0xFFEDEDED),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  label.tr(),
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.tr(),
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

// Product Colors Item Widget
class ProductColorsItem extends StatelessWidget {
  final List<Color?>? colors;

  const ProductColorsItem({Key? key, required this.colors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayColors = colors?.take(10).toList();
    final hasMore = (colors?.length ?? 0) > 10;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: const Border(
          bottom: BorderSide(
            color: Color(0xFFEDEDED),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${'colors'.tr()}: ',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: displayColors?.map((color) {
                            return Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 2,
                                ),
                              ),
                            );
                          }).toList() ??
                          [],
                    ),
                    if (hasMore) ...[
                      const SizedBox(height: 8),
                      Text(
                        '+${(colors?.length ?? 0) - 10} ${'more_colors'.tr()}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
