import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rova_star/core/component/buttons/custom_text_button.dart';
import 'package:rova_star/core/themes/colors.dart';
import 'package:rova_star/core/utils/app_images.dart';

class NotificationPermissionView extends StatelessWidget {
  const NotificationPermissionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImages.notificationPermission),
            const SizedBox(
              height: 36,
            ),
            Text(
              'enable_notification'.tr(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'enable_notifications_to_receive_real-time_updates .'.tr(),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.cSecondaryBlack),
            ),
            const SizedBox(
              height: 36,
            ),
            CustomTextButton(
              onPress: () {},
              childText: 'allow_notification'.tr(),
            ),
            const SizedBox(
              height: 16,
            ),
            CustomTextButton(
              backgroundColor: AppColors.transparent,
              colorText: AppColors.primaryColor,
              onPress: () {},
              childText: 'maybe_later'.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
