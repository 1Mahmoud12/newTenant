import 'dart:io';

import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/notification/presentation/notification_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              onPressed: onPressLeading ?? () => Navigator.pop(context),
              icon: Platform.isAndroid ? const Icon(Icons.arrow_back) : const Icon(Icons.arrow_back_ios),
            ),
          ),
    leadingWidth: 50,
    centerTitle: centerTitle,
    title: Text(
      (title ?? '').tr(),
      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20.sp, fontWeight: FontWeight.bold),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: InkWell(
          onTap: () {
            context.navigateToPage(const NotificationsView());
          },
          child: actions ??
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(Icons.notifications_none, size: 28.sp),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
        ),
      ),
    ],
    bottom: bottom,
    toolbarHeight: 60,
  );
}
