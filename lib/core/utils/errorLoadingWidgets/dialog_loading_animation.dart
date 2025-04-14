import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dobzz_seller/core/themes/colors.dart';

void animationDialogLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black26,
    barrierDismissible: false,
    builder: (context) => Dialog(
      backgroundColor: AppColors.transparent,
      child: const SizedBox(
        height: 50,
        width: 50,
        child: SpinKitChasingDots(
          color: AppColors.primaryColor,
        ),
      ),
    ),
  );
}

void closeDialog(BuildContext context) {
  Navigator.pop(context);
}
