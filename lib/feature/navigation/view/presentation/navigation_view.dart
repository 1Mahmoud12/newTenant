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

  final List<Widget> _screens = [
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
          _screens[_selectedIndex],
          Positioned(
            bottom: 5,
            left: 0,
            right: 0,
            child: NavigationBar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            ),
          ),
        ],
      ),
    );
  }
}

class NavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const NavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          NavItem(
            index: 0,
            outlinedIcon: Icons.home_outlined,
            filledIcon: Icons.home_filled,
            hasNotification: true,
            isSelected: selectedIndex == 0,
            onTap: onItemTapped,
          ),
          s,
          NavItem(
            index: 1,
            outlinedIcon: Icons.shopping_bag_outlined,
            filledIcon: Icons.shopping_bag,
            hasNotification: false,
            isSelected: selectedIndex == 1,
            onTap: onItemTapped,
          ),
          s,
          NavItem(
            index: 2,
            outlinedIcon: Icons.favorite_border,
            filledIcon: Icons.favorite,
            hasNotification: false,
            isSelected: selectedIndex == 2,
            onTap: onItemTapped,
          ),
          s,
          NavItem(
            index: 3,
            outlinedIcon: Icons.person_outline,
            filledIcon: Icons.person,
            hasNotification: false,
            isSelected: selectedIndex == 3,
            onTap: onItemTapped,
          ),
        ],
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final int index;
  final IconData outlinedIcon;
  final IconData filledIcon;
  final bool hasNotification;
  final bool isSelected;
  final Function(int) onTap;

  const NavItem({
    Key? key,
    required this.index,
    required this.outlinedIcon,
    required this.filledIcon,
    required this.hasNotification,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(index),
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
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
