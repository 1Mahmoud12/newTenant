import 'package:dobzz_seller/core/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RegularNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const RegularNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 2,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RegularNavItem(
            index: 0,
            outlinedIcon: AppIcons.unSelectedHomeR,
            filledIcon: AppIcons.selectedHomeR,
            isSelected: selectedIndex == 0,
            onTap: onItemTapped,
          ),
          RegularNavItem(
            index: 1,
            outlinedIcon: AppIcons.unSelectedCartR,
            filledIcon: AppIcons.selectedCartR,
            isSelected: selectedIndex == 1,
            onTap: onItemTapped,
          ),
          RegularNavItem(
            index: 2,
            outlinedIcon: AppIcons.unSelectedFavoriteR,
            filledIcon: AppIcons.selectedFavoriteR,
            isSelected: selectedIndex == 2,
            onTap: onItemTapped,
          ),
          RegularNavItem(
            index: 3,
            outlinedIcon: AppIcons.unSelectedProfileR,
            filledIcon: AppIcons.selectedProfileR,
            isSelected: selectedIndex == 3,
            onTap: onItemTapped,
          ),
        ],
      ),
    );
  }
}

class RegularNavItem extends StatelessWidget {
  final int index;
  final String outlinedIcon;
  final String filledIcon;
  final bool isSelected;
  final Function(int) onTap;

  const RegularNavItem({
    Key? key,
    required this.index,
    required this.outlinedIcon,
    required this.filledIcon,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              // padding: const EdgeInsets.all(5),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.grey.shade200 : Colors.transparent,
              ),
              child: Center(
                child: SvgPicture.asset(
                  isSelected ? filledIcon : outlinedIcon,
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
