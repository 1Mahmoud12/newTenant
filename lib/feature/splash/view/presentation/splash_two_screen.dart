import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/network/local/cache.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/app_images.dart';
import 'package:dobzz_seller/core/utils/constant_gaping.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/auth/login/view/presentation/login_screen.dart';
import 'package:dobzz_seller/feature/navigation/view/presentation/navigation_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashTwoScreen extends StatefulWidget {
  const SplashTwoScreen({super.key});

  @override
  State<SplashTwoScreen> createState() => _SplashTwoScreenState();
}

class _SplashTwoScreenState extends State<SplashTwoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        CustomTextButton(
          borderRadius: 8,
          onPress: () async {
            onBoardingValue = false;
            await userCache?.put(onBoardingKey, false);

            context.navigateToPage(const NavigationViewWithThemes());
          },
          child: Row(
            children: [
              s,
              Text(
                'Get Start'.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Constants.tablet ? 16 : 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              w5,
              const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
              s,
            ],
          ),
        ),
      ],
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                AppImages.splashShape,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: context.locale.languageCode == 'ar' ? 30 : 10,
              left: context.locale.languageCode == 'ar' ? 0 : 10,
              right: context.locale.languageCode == 'ar' ? 10 : 0,
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: Text(
                  'Define\nyourself in\nyour unique\nway.'.tr(),
                  style: TextStyle(
                    fontSize: Constants.tablet
                        ? context.locale.languageCode == 'ar'
                            ? 40
                            : 50
                        : context.locale.languageCode == 'ar'
                            ? 40.sp
                            : 50.sp,
                    height: 0.9,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
