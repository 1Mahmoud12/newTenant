import 'dart:async';
import 'dart:ui';

import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/account/view/presentation/account_view.dart';
import 'package:dobzz_seller/feature/cart/view/presentation/cart_view.dart';
import 'package:dobzz_seller/feature/favorites/views/presentation/favorite_view.dart';
import 'package:dobzz_seller/feature/home/views/presentation/home_page_view.dart';
import 'package:dobzz_seller/feature/navigation/view/presentation/navigation_view.dart';
import 'package:dobzz_seller/feature/product/views/presentation/product_details_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/app_images.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/core/utils/utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
        context.navigateToPage(const NavigationView());

        //context.navigateToPage(userCacheValue?.data != null ? const BottomNavBarScreen() : const LoginScreen());
        // userCacheValue.data != null
        //     ? context.navigateToPage(const NavigationView())
        //     : context.navigateToPage(const SelectUserType(), pageTransitionType: PageTransitionType.rightToLeft, animation: 400);
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
    Utils.buildSetSystemUIOverlayStyle();
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(100),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(
                  width: 150,
                  height: 150,
                  color: Colors.white.withOpacity(0.1), // light blur effect
                ),
              ),
            ),
          ),
          Center(
            child: Image.asset(
              AppImages.splashLogo,
            ),
          ),
        ],
      ),
    );
  }
}
//.scale(duration: const Duration(milliseconds: 100))
