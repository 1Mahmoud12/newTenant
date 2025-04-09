import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mamlaka/core/utils/app_icons.dart';

PreferredSizeWidget customAppBar({
  bool stopLeading = false,
  bool centerTitle = true,
  required BuildContext context,
  void Function()? onPressLeading,
  Widget? actions,
  String? title,
  PreferredSizeWidget? bottom,
}) {
  return AppBar(
    // systemOverlayStyle: const SystemUiOverlayStyle(
    //   statusBarColor: AppColors.scaffoldBackGround,
    //   statusBarIconBrightness: Brightness.dark,
    //   statusBarBrightness: Brightness.dark,
    //   systemStatusBarContrastEnforced: false,
    // ),
    leading: stopLeading
        ? const SizedBox.shrink()
        : Padding(
            padding:
                EdgeInsets.only(top: 17, left: context.locale.languageCode == 'ar' ? 0 : 16, right: context.locale.languageCode == 'ar' ? 16 : 0),
            child: IconButton(
              onPressed: onPressLeading ?? () => Navigator.pop(context),
              icon: Platform.isAndroid
                  ? RotatedBox(quarterTurns: context.locale.languageCode == 'ar' ? 2 : 0, child: SvgPicture.asset(AppIcons.arrowBackIc))
                  : const Icon(Icons.arrow_back_ios),
            ),
          ),
    leadingWidth: 75,
    centerTitle: centerTitle,
    title: Padding(
      padding: const EdgeInsets.only(top: 17.0),
      child: Text(
        (title ?? '').tr(),
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(top: 17),
        child: actions ?? Container(),
      ),
    ],
    bottom: bottom,
    toolbarHeight: 80,
  );
}
