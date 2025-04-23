import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/auth/login/view/presentation/login_screen.dart';
import 'package:dobzz_seller/feature/navigation/view/presentation/navigation_view.dart';

Future<void> signInDialog(BuildContext context) async {
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              Text(
                'sign_in'.tr(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.dividerColor)),
                  child: const Icon(
                    Icons.close,
                    size: 15,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'need_from_you_to_sign_in_to_see_this_feature'.tr(),
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: CustomTextButton(
                    onPress: () {
                      Navigator.pop(context);
                      context.navigateToPage(const LoginScreen());
                    },
                    childText: 'sign_in'.tr(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomTextButton(
                    onPress: () {
                      Navigator.pop(context);
                      context.navigateToPage(const NavigationViewWithThemes());
                    },
                    childText: 'cancel'.tr(),
                    backgroundColor: AppColors.cSecondScaffoldBackGround,
                    colorText: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
