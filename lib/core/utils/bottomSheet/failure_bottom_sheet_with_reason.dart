import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mamlaka/core/component/buttons/custom_text_button.dart';
import 'package:mamlaka/core/themes/colors.dart';
import 'package:mamlaka/core/utils/item_above_modal_bottom_sheet.dart';

Future<void> failureModalBottomSheetWithReason(BuildContext context, {required List reasons, required Function onPress}) async {
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
                        'Error'.tr(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                // Text(
                //   'there_is_an_error_in_your_card_information,_please_check_the_following'.tr(),
                //   textAlign: TextAlign.center,
                //   style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.cSecondaryBlack, fontWeight: FontWeight.w600),
                // ),
                const SizedBox(height: 12),
                ...List.generate(
                  reasons.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '${index + 1}. ${reasons[index]}',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.cSecondaryBlack, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                CustomTextButton(
                  child: Text(
                    'ok'.tr(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: AppColors.white),
                    textAlign: TextAlign.center,
                  ),
                  onPress: () {
                    Navigator.pop(context);
                    onPress();
                  },
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
