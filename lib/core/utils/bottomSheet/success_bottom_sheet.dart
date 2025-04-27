import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/themes/styles.dart';
import 'package:dobzz_seller/core/utils/app_icons.dart';
import 'package:dobzz_seller/core/utils/extensions.dart';

Future<void> successModalBottomSheet(
  BuildContext context, {
  required String title,
  String? subTitle,
  required String nameButton,
  required Function onPress,
}) async {
  await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: AppColors.white,
        child: SuccessBottomSheet(title: title, subTitle: subTitle, nameButton: nameButton, onPress: onPress),
      ).animate().slideY(begin: 1);
    },
  );
}

class SuccessBottomSheet extends StatefulWidget {
  final String title;
  final String? subTitle;
  final String nameButton;
  final Function onPress;

  const SuccessBottomSheet({
    super.key,
    required this.title,
    this.subTitle,
    required this.nameButton,
    required this.onPress,
  });

  @override
  State<SuccessBottomSheet> createState() => _SuccessBottomSheetState();
}

class _SuccessBottomSheetState extends State<SuccessBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 40,
              ),
              //   SvgPicture.asset(AppIcons.successDialogIc),
              Text(
                widget.title.tr(),
                textAlign: TextAlign.center,
                style: Styles.style24700.copyWith(fontWeight: FontWeight.w700, color: AppColors.primaryColor),
              ),
              if (widget.subTitle != null)
                Text(
                  widget.subTitle!.tr(),
                  textAlign: TextAlign.center,
                  style: Styles.style12300,
                ),
              CustomTextButton(
                backgroundColor: AppColors.primaryColor,
                borderColor: Colors.transparent,
                childText: widget.nameButton.tr(),
                padding: const EdgeInsets.symmetric(vertical: 12),
                onPress: () {
                  Navigator.pop(context);
                  widget.onPress();
                },
              ),
            ].paddingDirectional(bottom: 16),
          ),
        ],
      ),
    );
  }
}
