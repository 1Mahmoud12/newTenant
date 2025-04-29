import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SeeAllWidget extends StatelessWidget {
  const SeeAllWidget({
    super.key,
    required this.title,
    this.onTap,
    this.showSeeAll = true,
  });

  final String title;
  final bool showSeeAll;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title.tr(),
          style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: Constants.tablet ? 18 : 18.sp, fontWeight: FontWeight.bold),
        ),
        InkWell(
          onTap: onTap,
          child: Text(
            'View All'.tr(),
            style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w500, color: AppColors.grey),
          ),
        ),
      ],
    );
  }
}
