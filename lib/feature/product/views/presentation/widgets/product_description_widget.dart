import 'package:rova_star/core/themes/colors.dart';
import 'package:rova_star/core/themes/styles.dart';
import 'package:rova_star/feature/home/data/models/product_mdoel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// Product Description Widget
class ProductDescriptionWidget extends StatefulWidget {
  const ProductDescriptionWidget({Key? key, required this.productModelData}) : super(key: key);
  final Product productModelData;

  @override
  State<ProductDescriptionWidget> createState() => _ProductDescriptionWidgetState();
}

class _ProductDescriptionWidgetState extends State<ProductDescriptionWidget> {
  bool isArabic = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isArabic = context.locale.languageCode == 'ar';
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('product_description'.tr(), style: Styles.style16400.copyWith(color: AppColors.black)),
            InkWell(
              onTap: () {
                setState(() {
                  isArabic = !isArabic;
                });
              },
              child: Text(
                isArabic ? 'AR' : 'EN',
                style: Styles.style16400.copyWith(color: AppColors.black),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          isArabic ? widget.productModelData.descriptionAr.toString() : widget.productModelData.descriptionEn.toString(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
