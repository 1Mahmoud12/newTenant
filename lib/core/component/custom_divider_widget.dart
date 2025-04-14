import 'package:flutter/material.dart';
import 'package:dobzz_seller/core/themes/colors.dart';

class CustomDividerWidget extends StatelessWidget {
  final double? height;
  final double? endIndent;
  final double? indent;

  const CustomDividerWidget({
    super.key,
    this.height,
    this.endIndent,
    this.indent,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: AppColors.cBorderTextFormField,
      height: height,
      endIndent: endIndent,
      indent: indent,
    );
  }
}
