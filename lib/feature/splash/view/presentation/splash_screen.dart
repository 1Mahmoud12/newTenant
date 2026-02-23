import 'dart:async';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rova_star/core/network/local/cache.dart';
import 'package:rova_star/core/utils/app_images.dart';
import 'package:rova_star/core/utils/constants.dart';
import 'package:rova_star/core/utils/extensions.dart';
import 'package:rova_star/core/utils/navigate.dart';
import 'package:rova_star/core/utils/utils.dart';
import 'package:rova_star/feature/auth/login/view/presentation/login_screen.dart';
import 'package:rova_star/feature/navigation/view/presentation/navigation_view.dart';
import 'package:rova_star/feature/splash/view/presentation/splash_two_screen.dart';

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
        //   context.navigateToPage(const NavigationView());
        if (onBoardingValue) {
          context.navigateToPage(const SplashTwoScreen());
        } else {
          context.navigateToPage(loginCacheValue?.data != null ? const NavigationViewWithThemes() : const LoginScreen());
        }
        // userCacheValue.data != null ? context.navigateToPage(const NavigationView()) : context.navigateToPage(const LoginScreen());
        // userCache?.put(onBoardingKey, false);
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
      backgroundColor: const Color(0xfffff5f7),
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
                  color: Colors.white.withOpacityNew(0.1), // light blur effect
                ),
              ),
            ),
          ),
          Center(
            child: Image.asset(
              AppImages.appLogoWhite,
              width: 200,
            ),
          ),
        ],
      ),
    );
  }
}
//.scale(duration: const Duration(milliseconds: 100))
