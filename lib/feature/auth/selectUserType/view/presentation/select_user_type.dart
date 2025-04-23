import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/app_icons.dart';
import 'package:dobzz_seller/core/utils/extensions.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/core/utils/screen_spaces_extension.dart';
import 'package:dobzz_seller/feature/auth/login/view/presentation/login_screen.dart';
import 'package:dobzz_seller/feature/auth/selectUserType/view/presentation/widgets/switch_language_widget.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../navigation/view/presentation/navigation_view.dart';
import '../../../signUp/view/presentation/sign_up_view.dart';

class SelectUserType extends StatelessWidget {
  const SelectUserType({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Container(
            color: AppColors.cSecondScaffoldBackGround,
            height: kToolbarHeight + 10,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ClipPath(
                    clipper: CustomClipPath(),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.cSecondScaffoldBackGround,
                        // borderRadius: BorderRadius.only(
                        //   bottomRight: Radius.circular(100),
                        //   bottomLeft: Radius.circular(100),
                        // ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SwitchLanguageWidget(),
                          50.ESH(),
                          SvgPicture.asset(
                            AppIcons.appLogo,
                            height: context.screenHeight * .35,
                          )
                              .animate(delay: const Duration(milliseconds: 200))
                              .slide(duration: const Duration(seconds: 2), curve: Curves.elasticOut, begin: const Offset(0, 1), end: Offset.zero),
                          Container(
                            height: 60.h,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 120,
                                  offset: const Offset(0, -13),
                                  color: AppColors.black.withOpacity(.05),
                                ),
                              ],
                            ),
                          ),
                          //   SizedBox(height: context.screenHeight * .02),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 24.5, left: 24.5),
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: "let's ".tr(),
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                            children: [
                              TextSpan(
                                text: 'find_the_top-notch_laundry'.tr(),
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: AppColors.primaryColor),
                              ),
                              TextSpan(
                                text: ' services'.tr(),
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 28),
                        CustomTextButton(
                          borderRadius: 78,
                          padding: const EdgeInsets.symmetric(vertical: 14.5),
                          onPress: () {
                            context.navigateToPage(const LoginScreen(), pageTransitionType: PageTransitionType.rightToLeft);
                          },
                          child: Text(
                            'sign_in'.tr(),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.white,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 14),
                        CustomTextButton(
                          borderRadius: 78,
                          backgroundColor: AppColors.secondPrimaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 14.5),
                          child: Text(
                            'continue_as_a_guest'.tr(),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryColor,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          onPress: () {
                            context.navigateToPage(const NavigationViewWithThemes(), pageTransitionType: PageTransitionType.bottomToTop);
                          },
                        ),
                        const SizedBox(height: 14),
                        Text.rich(
                          TextSpan(
                            text: 'don’t_have_account '.tr(),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w400),
                            children: [
                              TextSpan(
                                text: 'sign_up'.tr(),
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.primaryColor,
                                      decoration: TextDecoration.underline,
                                      decorationColor: AppColors.primaryColor,
                                    ),
                                recognizer: TapGestureRecognizer()..onTap = () => context.navigateToPage(const SignUpView()),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 28),
                      ],
                    ),
                  )
                      .animate(delay: const Duration(milliseconds: 200))
                      .slide(duration: const Duration(seconds: 2), curve: Curves.elasticOut, begin: const Offset(0, 1), end: Offset.zero),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // x =width
    // y = height
    final Path path = Path();
    final double height = size.height;
    final double width = size.width;
    path.lineTo(0, height - 40);
    // path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 100);
    path.quadraticBezierTo(height * .5, width + 80, width, height - 40);
    // path.lineTo(width, height - 100);
    path.lineTo(height, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
