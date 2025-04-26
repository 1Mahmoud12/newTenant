import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/app_icons.dart';
import 'package:dobzz_seller/core/utils/constant_gaping.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CircledBorderTheme extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CircledBorderTheme({
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
            outlinedIcon: AppIcons.unSelectedHomeC,
            filledIcon: AppIcons.selectedHomeC,
            hasNotification: true,
            isSelected: selectedIndex == 0,
            onTap: onItemTapped,
          ),
          s,
          NavItem(
            index: 1,
            outlinedIcon: AppIcons.unSelectedCartC,
            filledIcon: AppIcons.selectedCartC,
            hasNotification: false,
            isSelected: selectedIndex == 1,
            onTap: onItemTapped,
          ),
          s,
          NavItem(
            index: 2,
            outlinedIcon: AppIcons.unSelectedFavoriteC,
            filledIcon: AppIcons.selectedFavoriteC,
            hasNotification: false,
            isSelected: selectedIndex == 2,
            onTap: onItemTapped,
          ),
          s,
          NavItem(
            index: 3,
            outlinedIcon: AppIcons.unSelectedProfileC,
            filledIcon: AppIcons.selectedProfileC,
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
  final String outlinedIcon;
  final String filledIcon;
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
            SvgPicture.asset(
              isSelected ? filledIcon : outlinedIcon,
              width: 25,
              height: 25,
              colorFilter: ColorFilter.mode(isSelected ? AppColors.primaryColor : Colors.white, BlendMode.srcIn),
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
