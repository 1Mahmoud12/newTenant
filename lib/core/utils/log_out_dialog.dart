import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rova_star/core/component/buttons/custom_text_button.dart';
import 'package:rova_star/core/themes/colors.dart';
import 'package:rova_star/core/themes/styles.dart';

Future<void> laundryutDialog(
  BuildContext context,
) async {
  showDialog(
    context: context,
    builder: (context) => Stack(
      alignment: AlignmentDirectional.center,
      children: [
        AlertDialog(
          backgroundColor: AppColors.white,
          titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          title: Text(
            'Are you sure to delete your account with us?'.tr(),
            textAlign: TextAlign.center,
            style: Styles.style16400,
          ),
          actions: [
            CustomTextButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'I want to follow the account'.tr(),
                    textAlign: TextAlign.center,
                    style: Styles.style16400.copyWith(fontWeight: FontWeight.w500, color: AppColors.white),
                  ),
                ],
              ),
              onPress: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(
              height: 12,
            ),
            CustomTextButton(
              backgroundColor: AppColors.transparent,
              borderColor: AppColors.cErrorColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'I want to log out the account'.tr(),
                    textAlign: TextAlign.center,
                    style: Styles.style16400.copyWith(fontWeight: FontWeight.w500, color: AppColors.cErrorColor),
                  ),
                ],
              ),
              onPress: () {
                //      context.navigateToPageWithClearStack(const LoginScreen());
              },
            ),
          ],
        ),
        /*Positioned(
          top: 187.h,
          right: 50.w,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.white, width: 2),
            ),
            child: const Icon(
              Icons.close,
              color: AppColors.white,
            ),
          ),
        ),*/
      ],
    ),
  );
}
