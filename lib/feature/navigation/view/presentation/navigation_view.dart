import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mamlaka/core/network/local/cache.dart';
import 'package:mamlaka/core/themes/colors.dart';
import 'package:mamlaka/core/utils/app_icons.dart';
import 'package:mamlaka/core/utils/bottomSheet/sign_in_dialog.dart';
import 'package:mamlaka/core/utils/custom_show_toast.dart';
import 'package:mamlaka/core/utils/extensions.dart';
import 'package:mamlaka/core/utils/versionAndUpdateApp/alert_dialog_for_update_app.dart';

class NavigationView extends StatefulWidget {
  final int customIndex;

  const NavigationView({super.key, this.customIndex = 0});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> with SingleTickerProviderStateMixin {
  int index = 0;
  late AnimationController _animationController;
  List<Widget> screens = [
    const SizedBox(),
    const SizedBox(),
    const SizedBox(),
    const SizedBox(),
    const SizedBox(),
  ];
  int currentInterIndex = 0;

  @override
  void initState() {
    super.initState();
    index = widget.customIndex;
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userCacheValue.data != null) {
        // BlocProvider.of<ManageAddressesCubit>(context).getAllMyAddresses(context: context);
        //  BlocProvider.of<HomeCubit>(context).getNotificationCount();

        //  CartCubit.of(context).getCart(context: context);
      }

      log('start Connectivity');

      // Update App
      checkVersion(context);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  void _onItemTapped(int newIndex, BuildContext context) {
    if (userCacheValue.data == null && (newIndex == 0 || newIndex == 2)) {
      notRequireSignIn(newIndex);
    } else if (userCacheValue.data == null) {
      signInDialog(context);
    } else {
      notRequireSignIn(newIndex);
    }
  }

  void notRequireSignIn(int newIndex) {
    if (newIndex != index) {
      setState(() {
        index = newIndex;
      });
      _animationController.forward(from: 0);
    }
  }

  int exitApp = 0;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        exitApp++;
        //Utils.showToast(title: 'swipe twice to exit', state: UtilState.success);
        customShowToast(context, 'swipe_again_to_exit_app'.tr(), showToastStatus: ShowToastStatus.warning);
        Future.delayed(
          const Duration(seconds: 5),
          () {
            exitApp = 0;
            setState(() {});
          },
        );
        if (exitApp == 2) {
          exit(0);
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: index,
          children: screens,
        ),
        bottomNavigationBar: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.cBorderTextFormField,
            ),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0C000000),
                blurRadius: 34,
                offset: Offset(0, 20),
              ),
            ],
          ),
          child: Stack(
            children: [
              BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: SvgPicture.asset(
                        index == 0 ? AppIcons.selectedHome : AppIcons.unSelectedHome,
                      ),
                    ),
                    label: 'home'.tr(),
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: SvgPicture.asset(
                        index == 1 ? AppIcons.selectedOrders : AppIcons.unSelectedOrders,
                      ),
                    ),
                    label: 'orders'.tr(),
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: SvgPicture.asset(
                        index == 2 ? AppIcons.selectedOffers : AppIcons.unSelectedOffers,
                      ),
                    ),
                    label: 'offers'.tr(),
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: SvgPicture.asset(
                        index == 3 ? AppIcons.selectedCart : AppIcons.unSelectedCart,
                      ), /*BlocBuilder<CartCubit, CartState>(
                        builder: (context, state) => Badge(
                          isLabelVisible: ConstantsModels.cartModel != null &&
                              ConstantsModels.cartModel!.data != null &&
                              ConstantsModels.cartModel!.data!.totalAmount != 0,
                          smallSize: 10,
                          backgroundColor: AppColors.red,
                          child: SvgPicture.asset(
                            index == 3 ? AppIcons.selectedCart : AppIcons.unSelectedCart,
                          ),
                        ),
                      ),*/
                    ),
                    label: 'cart'.tr(),
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: SvgPicture.asset(
                        index == 4 ? AppIcons.selectedProfile : AppIcons.unSelectedProfile,
                      ),
                    ),
                    label: 'profile'.tr(),
                  ),
                ],
                backgroundColor: AppColors.transparent,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                selectedLabelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                unselectedLabelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                elevation: 0,
                selectedItemColor: AppColors.primaryColor,
                unselectedItemColor: AppColors.grey,
                currentIndex: index,
                // Set the current index
                type: BottomNavigationBarType.fixed,
                onTap: (int value) {
                  _onItemTapped(value, context);
                  if (value == 0) {
                    SystemChrome.setSystemUIOverlayStyle(
                      const SystemUiOverlayStyle(
                        statusBarColor: AppColors.primaryColor,
                        statusBarIconBrightness: Brightness.light,
                        statusBarBrightness: Brightness.light,
                        systemNavigationBarColor: AppColors.scaffoldBackGround,
                        systemNavigationBarDividerColor: AppColors.scaffoldBackGround,
                      ),
                    );
                  } else {
                    SystemChrome.setSystemUIOverlayStyle(
                      const SystemUiOverlayStyle(
                        statusBarColor: AppColors.scaffoldBackGround,
                        statusBarIconBrightness: Brightness.dark,
                        statusBarBrightness: Brightness.light,
                        systemNavigationBarColor: AppColors.scaffoldBackGround,
                        systemNavigationBarDividerColor: AppColors.scaffoldBackGround,
                      ),
                    );
                  }
                },
              ),
              AnimatedPositioned(
                duration: Durations.medium1,
                left: !context.locale.languageCode.contains('ar')
                    ? ((index == 0
                            ? (context.screenWidth * .08)
                            : index == 1
                                ? (context.screenWidth * .27)
                                : index == 2
                                    ? (context.screenWidth * .48)
                                    : index == 3
                                        ? (context.screenWidth * .67)
                                        : index == 4
                                            ? (context.screenWidth * .87)
                                            : 0)
                        .toDouble())
                    : ((index == 0
                            ? (context.screenWidth * .87)
                            : index == 1
                                ? (context.screenWidth * .67)
                                : index == 2
                                    ? (context.screenWidth * .48)
                                    : index == 3
                                        ? (context.screenWidth * .27)
                                        : index == 4
                                            ? (context.screenWidth * .08)
                                            : 0)
                        .toDouble()),
                child: SizedBox(
                  height: 10,
                  width: 18,
                  child: Container(
                    height: 10,
                    width: 18,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
