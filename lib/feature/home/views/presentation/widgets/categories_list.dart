import 'package:dobzz_seller/core/utils/app_icons.dart';
import 'package:dobzz_seller/core/utils/constant_gaping.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: List.generate(6, (index) {
            return Container(
              margin: EdgeInsets.only(right: context.locale.languageCode == 'ar' ? 0 : 8, left: context.locale.languageCode == 'en' ? 0 : 8),
              //   color: Colors.amber,
              width: 60,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade300,
                    ),
                    child: SvgPicture.asset(AppIcons.tShirtCate),
                  ),
                  h5,
                  Text(
                    'T-shirt'.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
