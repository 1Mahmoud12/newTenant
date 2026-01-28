import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/themes/styles.dart';
import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:dobzz_seller/feature/favorites/views/manager/wishList/cubit/wish_list_cubit.dart';
import 'package:dobzz_seller/feature/home/data/models/product_mdoel.dart';
import 'package:dobzz_seller/feature/product/views/presentation/widgets/items_product_details.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

class ProductVariantsSection extends StatefulWidget {
  final Product productModelData;
  final Variants? selectVariant;
  final Function(Variants? variant, int qunatity) onSelectVariant;

  const ProductVariantsSection({
    super.key,
    required this.productModelData,
    required this.onSelectVariant,
    this.selectVariant,
  });

  @override
  State<ProductVariantsSection> createState() => _ProductVariantsSectionState();
}

class _ProductVariantsSectionState extends State<ProductVariantsSection> {
  final Map<String, int> _variantQuantityBySku = {};

  int _getQuantityForSku(String? sku) {
    if (sku == null) return 1;
    return _variantQuantityBySku[sku] ?? 1;
  }

  void _setQuantityForSku(String? sku, int quantity) {
    if (sku == null) return;
    _variantQuantityBySku[sku] = quantity;
  }

  void toggleLike({required int productId}) {
    if (context.read<WishListCubit>().isWishListed(productId: productId)) {
      context.read<WishListCubit>().removeFromWishList(context: context, productId: productId);
    } else {
      context.read<WishListCubit>().addToWishList(context: context, productId: productId);
    }
  }

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
            'options_&_variants'.tr(),
            style: Styles.style16400.copyWith(color: AppColors.black, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          ...List.generate(widget.productModelData.variants?.length ?? 0, (index) {
            final item = widget.productModelData.variants![index];
            final bool isSelected = widget.selectVariant?.skuCode == item.skuCode;
            final int currentQty = _getQuantityForSku(item.skuCode);
            final int maxQty = (item.quantity ?? 1).toInt();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${'variant'.tr()}: ${index + 1}',
                      style: Styles.style16400.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (widget.productModelData.id != null) {
                          toggleLike(productId: widget.productModelData.id!);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.black87,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          context.watch<WishListCubit>().isWishListed(productId: widget.productModelData.id ?? -1)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                ProductSpecItem(
                  label: 'sku',
                  value: (item.skuCode ?? 0).toString(),
                ),
                ProductSpecItem(
                  label: 'size',
                  value: (item.size ?? 0).toString(),
                ),
                ProductSpecItem(
                  label: 'color',
                  value: (item.color ?? 0).toString(),
                ),
                ProductColorsItem(colors: [HexColor(item.colorCode!)]),
                ProductSpecItem(
                  label: 'quantity',
                  value: (item.quantity ?? 0).toString(),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (currentQty > 1) {
                                setState(() {
                                  _setQuantityForSku(
                                    item.skuCode,
                                    currentQty - 1,
                                  );
                                });
                              }
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          Text('$currentQty', style: Styles.style16400),
                          IconButton(
                            onPressed: () {
                              if (currentQty < maxQty) {
                                setState(() {
                                  _setQuantityForSku(
                                    item.skuCode,
                                    currentQty + 1,
                                  );
                                });
                              } else {
                                Utils.showToast(
                                  title: '${'Maximum quantity is'.tr()} $maxQty',
                                  state: UtilState.warning,
                                );
                              }
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextButton(
                        onPress: () {
                          if (isSelected) {
                            widget.onSelectVariant(null, 1);
                          } else {
                            widget.onSelectVariant(item, currentQty);
                          }
                        },
                        childText: (isSelected ? 'selected' : 'select').tr(),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
