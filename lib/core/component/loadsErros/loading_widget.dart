import 'package:flutter/material.dart';
import 'package:rova_star/core/themes/colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
    this.loadingColor,
  });
  final Color? loadingColor;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: Center(
        child: CircularProgressIndicator(
          color: loadingColor ?? AppColors.primaryColor,
          strokeWidth: 2,
        ),
      ),
    );
  }
}
