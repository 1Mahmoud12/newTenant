import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mamlaka/core/themes/colors.dart';

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
          style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        InkWell(
          onTap: onTap,
          child: Text(
            'see_all'.tr(),
            style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w500, color: AppColors.primaryColor),
          ),
        ),
      ],
    );
  }
}
