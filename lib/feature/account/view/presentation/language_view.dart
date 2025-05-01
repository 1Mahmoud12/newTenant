import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/app_icons.dart';
import 'package:dobzz_seller/mainCubit/cubit/main_cubit_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LanguageView extends StatefulWidget {
  const LanguageView({super.key});

  @override
  State<LanguageView> createState() => _LanguageViewState();
}

class _LanguageViewState extends State<LanguageView> {
  late bool arabicValue;

  @override
  void initState() {
    super.initState();
    arabicValue = false;
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        arabicValue = context.locale.languageCode == 'ar';
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: 'language'.tr()),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(
            height: 20,
          ),
          InkWell(
            splashColor: AppColors.transparent,
            highlightColor: AppColors.transparent,
            onTap: () {
              arabicValue = true;
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                border: Border.all(color: arabicValue ? AppColors.primaryColor : AppColors.transparent),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(AppIcons.SAIc),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    'عربية',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w400),
                  ),
                  const Spacer(),
                  Text(
                    '(العربية)',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.cB200),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          InkWell(
            splashColor: AppColors.transparent,
            highlightColor: AppColors.transparent,
            onTap: () {
              arabicValue = false;
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                border: Border.all(color: !arabicValue ? AppColors.primaryColor : AppColors.transparent),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(AppIcons.EN),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    'English',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w400),
                  ),
                  const Spacer(),
                  Text(
                    '(English)',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.cB200),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        CustomTextButton(
          onPress: () {
            if (arabicValue && !(context.locale.languageCode == 'ar')) {
              MainCubitCubit.of(context).changeLanguage(const Locale('ar', 'SA'), context);
            } else if (!arabicValue && !(context.locale.languageCode == 'en')) {
              MainCubitCubit.of(context).changeLanguage(const Locale('en', 'US'), context);
            }
          },
          childText: 'confirm'.tr(),
        ),
      ],
    );
  }
}
