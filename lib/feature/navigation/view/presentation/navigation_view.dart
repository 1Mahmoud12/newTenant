import 'dart:io';

import 'package:rova_star/core/utils/utils.dart';
import 'package:rova_star/feature/account/view/myOrders/presentation/my_order_view.dart';
import 'package:rova_star/feature/account/view/presentation/themes/account_theme_one.dart';
import 'package:rova_star/feature/cart/view/manager/cartItems/cubit/cart_items_cubit.dart';
import 'package:rova_star/feature/favorites/views/presentation/favorite_view.dart';
import 'package:rova_star/feature/home/views/presentation/home_page_view.dart';
import 'package:rova_star/feature/navigation/view/presentation/navigation_bar_theme/circled_border_Theme.dart';
import 'package:rova_star/feature/navigation/view/presentation/navigation_bar_theme/reguler_theme.dart';
import 'package:rova_star/feature/navigation/view/presentation/navigation_bar_theme/theme_three.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum NavigationTheme {
  circular,
  regular,
  circleNav, // Add this new theme option
}

class NavigationViewWithThemes extends StatefulWidget {
  const NavigationViewWithThemes({
    Key? key,
    this.initialIndex = 0,
    this.theme = NavigationTheme.regular,
  }) : super(key: key);

  final int? initialIndex;
  final NavigationTheme theme;

  @override
  State<NavigationViewWithThemes> createState() => _NavigationViewWithThemesState();
}

class _NavigationViewWithThemesState extends State<NavigationViewWithThemes> {
  int _selectedIndex = 0;
  late NavigationTheme _theme;

  // Track the last time back was pressed
  DateTime? _lastBackPressTime;

  @override
  void initState() {
    CartItemsCubit.of(context).getCartItems(context: context);

    _selectedIndex = widget.initialIndex!;
    _theme = widget.theme;
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _screens = [
    const HomePageView(),
    const MyOrderView(),
    const FavoriteView(),
    const ProfileViewThemeOne(),
  ];

  // Handle back button press with double-press detection
  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    if (_lastBackPressTime == null || now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      // First time pressed or pressed after timeout
      _lastBackPressTime = now;

      // Show "press again to exit" toast
      Utils.showToast(title: 'Press again'.tr(), state: UtilState.error);

      return false; // Prevent app from closing
    }

    // Second press within 2 seconds, allow app to close
    return true;
  }

  @override
  void didChangeDependencies() {
    //checkVersion(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevents default pop behavior
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) {
          // Check if user should exit or show toast
          final shouldExit = await _onWillPop();
          if (shouldExit) {
            SystemNavigator.pop(); // Close the app
          }
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            _screens[_selectedIndex],
            Positioned(
              bottom: Platform.isIOS ? 15 : 0,
              left: 0,
              right: 0,
              child: NavigationThemeSwitcher(
                selectedIndex: _selectedIndex,
                onItemTapped: _onItemTapped,
                theme: _theme,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Example usage with navigation theme switcher
class NavigationThemeSwitcher extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final NavigationTheme theme;

  const NavigationThemeSwitcher({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (theme) {
      case NavigationTheme.circular:
        return CircledBorderTheme(
          selectedIndex: selectedIndex,
          onItemTapped: onItemTapped,
        );
      case NavigationTheme.regular:
        return RegularNavigationBar(
          selectedIndex: selectedIndex,
          onItemTapped: onItemTapped,
        );
      case NavigationTheme.circleNav: // Add the new case
        return CircleNavigationTheme(
          selectedIndex: selectedIndex,
          onItemTapped: onItemTapped,
        );
    }
  }
}
