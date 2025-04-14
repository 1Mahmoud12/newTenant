import 'package:flutter/material.dart';
import 'package:dobzz_seller/core/themes/colors.dart';

class SharredDivider extends StatelessWidget {
  final double? height;

  const SharredDivider({
    super.key,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height ?? 30,
      color: AppColors.cBorderTextFormField,
    );
  }
}
