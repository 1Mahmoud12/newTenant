import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/constant_gaping.dart';
import 'package:dobzz_seller/feature/account/view/presentation/account_view.dart';
import 'package:dobzz_seller/feature/cart/view/presentation/cart_view.dart';
import 'package:dobzz_seller/feature/favorites/views/presentation/favorite_view.dart';
import 'package:dobzz_seller/feature/home/views/presentation/home_page_view.dart';
import 'package:flutter/material.dart';

class NavigationView extends StatefulWidget {
  const NavigationView({Key? key, this.initialIndex = 0}) : super(key: key);
  final int? initialIndex;
  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  int _selectedIndex = 0;
  @override
  void initState() {
    _selectedIndex = widget.initialIndex!;
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> screens = [
    const HomePageView(),
    const CartView(),
    const FavoriteView(),
    const AccountView(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          screens[_selectedIndex],
          Positioned(
            bottom: 5,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              height: 67,
              decoration: BoxDecoration(
                color: const Color(0xff292526),
                borderRadius: BorderRadius.circular(40),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(0, Icons.home_outlined, Icons.home_filled, true),
                  s,
                  _buildNavItem(1, Icons.shopping_bag_outlined, Icons.shopping_bag, false),
                  s,
                  _buildNavItem(2, Icons.favorite_border, Icons.favorite, false),
                  s,
                  _buildNavItem(3, Icons.person_outline, Icons.person, false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData outlinedIcon, IconData filledIcon, bool hasNotification) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.all(8),
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
        ),
        child: Column(
          children: [
            Icon(
              isSelected ? filledIcon : outlinedIcon,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.8),
              size: 28,
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryColor),
              ),
          ],
        ),
      ),
    );
  }
}
