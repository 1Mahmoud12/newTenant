import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mamlaka/core/component/buttons/custom_text_button.dart';
import 'package:mamlaka/core/themes/colors.dart';
import 'package:mamlaka/core/utils/item_above_modal_bottom_sheet.dart';

Future<void> blockedModalBottomSheet(
  BuildContext context, {
  required Function onCancel,
  required Function onSubmit,
}) async {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: ItemAboveModalBottomSheet(),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.cCustomDividerColor,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'blocked_account'.tr(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'seems_like_the_account_you_used_to_sign_In_is_blocked,_please_try_again_with_allowed_account'.tr(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.cSecondaryBlack, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextButton(
                        backgroundColor: AppColors.cBackGroundColor,
                        child: Text(
                          'ok'.tr(),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: AppColors.primaryColor),
                        ),
                        onPress: () {
                          Navigator.pop(context);
                          onCancel();
                        },
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: CustomTextButton(
                        child: Text(
                          'tell_us'.tr(),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: AppColors.white),
                        ),
                        onPress: () {
                          Navigator.pop(context);
                          onSubmit();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
