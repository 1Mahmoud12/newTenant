import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/auth/login/view/presentation/login_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../themes/colors.dart';
import 'buttons/custom_text_button.dart';


class LoginDialog extends StatelessWidget {
  final String? title;
  final String? message;
  final VoidCallback? onLoginSuccess;
  final VoidCallback? onCancel;
  final bool showCancelButton;

  const LoginDialog({
    super.key,
    this.title,
    this.message,
    this.onLoginSuccess,
    this.onCancel,
    this.showCancelButton = true,
  });

  static Future<bool?> show(
    BuildContext context, {
    String? title,
    String? message,
    VoidCallback? onLoginSuccess,
    VoidCallback? onCancel,
    bool showCancelButton = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible:
          showCancelButton, // Prevent dismissal if no cancel button
      builder: (context) => PopScope(
        canPop: showCancelButton, // Prevent back button if no cancel button
        child: LoginDialog(
          title: title,
          message: message,
          onLoginSuccess: onLoginSuccess,
          onCancel: onCancel,
          showCancelButton: showCancelButton,
        ).animate().scale(duration: Durations.medium4).fadeIn(
              duration: Durations.extralong1,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withAlpha((0.1 * 255).toInt()),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline,
                size: 48,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              title ?? 'login_required'.tr(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Message
            Text(
              message ?? 'please_login_to_use_this_feature'.tr(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey,
                fontSize: 18
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                if (showCancelButton) ...[
                  Expanded(
                    flex: 1,
                    child: CustomTextButton(
                      onPress: () {
                        Navigator.pop(context, false);
                        onCancel?.call();
                      },
                      childText: 'Cancel'.tr(),
                      backgroundColor: AppColors.grey.withOpacity(0.1),
                      colorText: AppColors.grey,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  flex: 2,
                  child: CustomTextButton(
                    onPress: () {
                      if (showCancelButton) {
                        Navigator.pop(context, true);
                      }
                      context
                          .navigateToPage(
                        const LoginScreen(),
                        animation: 800,
                      );
                      //     .then((value) {
                      //   // Check if login was successful
                      //   if (value == true) {
                      //     onLoginSuccess?.call();
                      //     if (!showCancelButton) {
                      //       Navigator.pop(context,
                      //           true); // Close dialog only on success if blocked
                      //     }
                      //   }
                      // });
                    },
                    childText: 'Login'.tr(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
