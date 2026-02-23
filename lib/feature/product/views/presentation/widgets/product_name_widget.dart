import 'package:rova_star/core/themes/styles.dart';
import 'package:rova_star/core/utils/constants.dart';
import 'package:rova_star/feature/home/data/models/product_mdoel.dart';
import 'package:flutter/material.dart';

// Product Name Widget
class ProductNameWidget extends StatelessWidget {
  const ProductNameWidget({Key? key, required this.productModelData}) : super(key: key);
  final Product productModelData;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${productModelData.nameEn ?? Constants.unKnownValue} (${productModelData.nameAr ?? Constants.unKnownValue})',
      style: Styles.style20600.copyWith(
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }
}
