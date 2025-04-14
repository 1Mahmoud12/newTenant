import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/item_above_modal_bottom_sheet.dart';

Future<void> deleteModalBottomSheet(
  BuildContext context, {
  required String title,
  String? onSubmitTitle,
  String? subTitle,
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
                      Expanded(
                        child: Text(
                          title.tr(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                if (subTitle != null)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      subTitle.tr(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextButton(
                        backgroundColor: AppColors.cBackGroundColor,
                        child: Text(
                          'cancel'.tr(),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: AppColors.primaryColor),
                          textAlign: TextAlign.center,
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
                          onSubmitTitle ?? 'yes_delete'.tr(),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: AppColors.white),
                          textAlign: TextAlign.center,
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
