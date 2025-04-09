import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mamlaka/core/component/buttons/custom_text_button.dart';
import 'package:mamlaka/core/themes/colors.dart';
import 'package:mamlaka/core/utils/app_icons.dart';
import 'package:mamlaka/core/utils/app_images.dart';
import 'package:mamlaka/core/utils/constants.dart';
import 'package:mamlaka/core/utils/extensions.dart';
import 'package:mamlaka/core/utils/navigate.dart';
import 'package:mamlaka/feature/auth/login/view/presentation/login_screen.dart';
import 'package:mamlaka/feature/auth/signUp/view/presentation/sign_up_view.dart';
import 'package:mamlaka/feature/navigation/view/manager/homeBloc/cubit.dart';
import 'package:page_transition/page_transition.dart';

class SplashTwoScreen extends StatefulWidget {
  const SplashTwoScreen({super.key});

  @override
  State<SplashTwoScreen> createState() => _SplashTwoScreenState();
}

class _SplashTwoScreenState extends State<SplashTwoScreen> {
  late Timer timer;
  bool isOpen = false;
  @override
  void initState() {
    super.initState();
    //currentLocation();
    Future.delayed(const Duration(seconds: 2), () {
      isOpen = true;
      setState(() {});
    });
    timer = Timer(
      const Duration(seconds: 3),
      () {
        //context.navigateToPage(userCacheValue?.data != null ? const BottomNavBarScreen() : const LoginScreen());
        // userCacheValue.data != null
        //     ? context.navigateToPage(const LoginScreen())
        //     : context.navigateToPage(const LoginScreen(), pageTransitionType: PageTransitionType.rightToLeft, animation: 400);
        // // userCache?.put(onBoardingKey, false);
      },
    );
  }

/*  String? long;
  String? lat;

  void currentLocation() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      try {
        final Position position = await Geolocator.getCurrentPosition();
        lat = position.latitude.toString();
        long = position.longitude.toString();
        appCacheBox!.put(latCacheName, lat);
        appCacheBox!.put(longCacheName, long);
        latCache = lat;
        longCache = long;
      } catch (e) {
        return;
      }
    } else {}
  }*/

  @override
  void dispose() {
    timer.cancel(); // Cancel the Timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Constants.currentLanguage = context.locale.languageCode;

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () {
                  HomeCubit.of(context).changeLanguage(
                    Locale(
                      context.locale.languageCode == 'ar' ? 'en' : 'ar',
                      context.locale.languageCode == 'ar' ? 'US' : 'SA',
                    ),
                    context,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xff138DFF).withOpacity(.3), width: 3),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    context.locale.languageCode == 'ar' ? 'EN' : 'AR',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.cB600),
                  ),
                ),
              ),
              const Spacer(
                flex: 2,
              ),
              Hero(
                tag: 'splash',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppIcons.appLogo,
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    SvgPicture.asset(AppIcons.nameLogo),
                  ],
                ),
              ),
              const Spacer(
                flex: 4,
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Image.asset(
                    AppImages.backgroundSplashTwo,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ).animate(delay: 1000.ms).slideY(begin: 1, duration: 800.ms, curve: Curves.linear),
                ),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Image.asset(
                      AppImages.splashTwo,
                      fit: BoxFit.fitHeight,
                      width: double.infinity,
                      height: context.screenHeight * .8,
                    ).animate(delay: 1000.ms).slideY(begin: 1, duration: 800.ms, curve: Curves.linear),
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: context.screenHeight * .15,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.white,
                                    AppColors.white.withOpacity(0),
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                            Container(
                              height: context.screenHeight * .4,
                              width: double.infinity,
                              color: AppColors.white,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: 'find_the_ '.tr(),
                                  style: const TextStyle(fontSize: 35, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
                                  children: [
                                    TextSpan(
                                      text: '${'right_doctor'.tr()}\n',
                                      style:
                                          const TextStyle(fontSize: 35, fontWeight: FontWeight.w500, fontFamily: 'Poppins', color: AppColors.cB500),
                                    ),
                                    TextSpan(
                                      text: 'and_book_in_seconds'.tr(),
                                      style: const TextStyle(
                                        fontSize: 35,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                'seamless_scheduling'.tr(),
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.cB900,
                                      fontFamily: 'Poppins',
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              CustomTextButton(
                                borderRadius: 20,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                onPress: () {
                                  context.navigateToPage(const SignUpView(), pageTransitionType: PageTransitionType.rightToLeft);
                                },
                                childText: 'get_started'.tr(),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xff0038B9),
                                    Color(0xff033CBD),
                                    Color(0xff215EE1),
                                    Color(0xff0A84F6),
                                  ],
                                  begin: AlignmentDirectional.bottomStart,
                                  end: AlignmentDirectional.topEnd,
                                ),
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextButton(
                                      onPress: () {
                                        context.navigateToPage(const LoginScreen(), pageTransitionType: PageTransitionType.rightToLeft);
                                      },
                                      colorText: AppColors.cB900,
                                      borderColor: AppColors.cB900.withOpacity(.4),
                                      backgroundColor: Colors.transparent,
                                      borderRadius: 20,
                                      borderWidth: 2,
                                      child: Text(
                                        'login'.tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(fontWeight: FontWeight.w600, fontSize: 17.sp, fontFamily: 'Poppins'),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: CustomTextButton(
                                      onPress: () {},
                                      colorText: AppColors.cB900,
                                      borderColor: AppColors.cB500.withOpacity(.4),
                                      backgroundColor: Colors.transparent,
                                      borderRadius: 20,
                                      borderWidth: 2,
                                      child: Text(
                                        'guest'.tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(fontWeight: FontWeight.w600, fontSize: 17.sp, fontFamily: 'Poppins', color: AppColors.cB500),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ).animate(delay: 2000.ms).fade(duration: 800.ms),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
//.scale(duration: const Duration(milliseconds: 100))
